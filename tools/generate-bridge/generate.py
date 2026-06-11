#!/usr/bin/env python3
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SPEC_PATH = ROOT / "api" / "bridge.json"
HEADER_PATH = ROOT / "Sources" / "FoundationModelsCBindings" / "include" / "FoundationModels.h"
GO_HEADER_PATH = ROOT / "generated" / "go" / "FoundationModels.h"
MOONBIT_PATH = ROOT / "generated" / "moonbit" / "ffi_bridge.mbt"
OPAQUE_TYPES = set()


def load_spec():
    with SPEC_PATH.open("r", encoding="utf-8") as f:
        spec = json.load(f)
    OPAQUE_TYPES.clear()
    OPAQUE_TYPES.update(t["name"] for t in spec["types"] if t["kind"] == "opaque")
    return spec


def nullability(nullable):
    return " _Nullable" if nullable else " _Nonnull"


def type_name(item, *, for_param=False):
    if item.get("callbackPointer"):
        args = ", ".join(type_name(arg, for_param=True) for arg in item["signature"])
        attrs = "".join(f" __attribute__(({attr}))" for attr in item.get("attributes", []))
        return f"void (*{nullability(item.get('nullable', False))} {item['name']})({args}){attrs}"

    base = item["type"]
    if item.get("pointerDepth"):
        depth = item["pointerDepth"]
    elif item.get("pointer") or item.get("array"):
        depth = 1
    else:
        depth = 0

    const_prefix = "const " if item.get("const") else ""
    if depth == 0:
        if base in OPAQUE_TYPES:
            return f"{base}{nullability(item.get('nullable', False))}"
        return base

    stars = []
    for idx in range(depth):
        is_last = idx == depth - 1
        stars.append("*" + (nullability(item.get("nullable", False)) if is_last else ""))
    return f"{const_prefix}{base} {' '.join(stars)}"


def declaration(func):
    returns = type_name(func["returns"])
    params = func.get("params", [])
    if not params:
        params_s = "void"
    else:
        parts = []
        for param in params:
            if param.get("callbackPointer"):
                parts.append(type_name(param, for_param=True))
            else:
                parts.append(f"{type_name(param, for_param=True)} {param['name']}")
        params_s = ", ".join(parts)
    return f"{returns} {func['name']}({params_s});"


def callback_declaration(cb):
    returns = cb["returns"]
    params = ", ".join(f"{type_name(param, for_param=True)} {param['name']}" for param in cb["params"])
    attrs = "".join(f" __attribute__(({attr}))" for attr in cb.get("attributes", []))
    return f"typedef {returns} (*_Nonnull {cb['name']})({params}){attrs};"


def render_header(spec):
    guard = spec["abi"]["headerGuard"]
    lines = [
        "/*",
        f" * {spec['abi']['generatedNotice']}",
        f" * ABI version: {spec['abi']['version']}",
        " */",
        "",
        f"#ifndef {guard}",
        f"#define {guard}",
        "",
    ]
    for include in spec["includes"]:
        lines.append(f"#include <{include}>")
    lines.append("")

    for t in spec["types"]:
        suffix = " _Nonnull" if t.get("nonnull") else ""
        lines.append(f"typedef {t['c']}{suffix} {t['name']};")
    lines.append("")

    lines.append("// Callbacks")
    for cb in spec["callbacks"]:
        lines.append(callback_declaration(cb))
    lines.append("")

    for enum in spec["enums"]:
        lines.append("typedef enum")
        lines.append("{")
        enum_values = enum["values"]
        for idx, value in enumerate(enum_values):
            comma = "," if idx < len(enum_values) - 1 else ""
            if "value" in value:
                lines.append(f"  {value['name']} = {value['value']}{comma}")
            else:
                lines.append(f"  {value['name']}{comma}")
        lines.append(f"}} {enum['name']};")
        lines.append("")

    current_section = None
    for func in spec["functions"]:
        if func["section"] != current_section:
            current_section = func["section"]
            lines.append(f"// MARK: - {current_section}")
            lines.append("")
        lines.append(declaration(func))
    lines.append("")
    lines.append(f"#endif /* {guard} */")
    lines.append("")
    return "\n".join(lines)


def moonbit_type(item):
    if item.get("callbackPointer"):
        return "UInt"
    base = item["type"]
    ptr = item.get("pointer") or item.get("pointerDepth") or item.get("array") or base in {
        "FMTaskRef",
        "FMSystemLanguageModelRef",
        "FMLanguageModelSessionRef",
        "FMLanguageModelSessionResponseStreamRef",
        "FMGenerationSchemaRef",
        "FMGeneratedContentRef",
        "FMGenerationSchemaPropertyRef",
        "FMBridgedToolRef",
        "FMComposedPrompt",
    }
    if ptr:
        if base == "char":
            return "Bytes"
        return "UInt"
    return {
        "void": "Unit",
        "bool": "Bool",
        "int": "Int",
        "int32_t": "Int",
        "size_t": "UInt",
        "double": "Double",
        "unsigned int": "UInt",
        "FMSystemLanguageModelUnavailableReason": "Int",
        "FMSystemLanguageModelUseCase": "Int",
        "FMSystemLanguageModelGuardrails": "Int",
        "FMComposedPromptAddImageError": "Int"
    }.get(base, "UInt")


def render_moonbit(spec):
    lines = [
        "///|",
        f"/// {spec['abi']['generatedNotice']}",
        f"/// ABI version: {spec['abi']['version']}",
        "",
        "///|",
        "pub typealias FMTaskRef = UInt",
        "///|",
        "pub typealias FMSystemLanguageModelRef = UInt",
        "///|",
        "pub typealias FMLanguageModelSessionRef = UInt",
        "///|",
        "pub typealias FMLanguageModelSessionResponseStreamRef = UInt",
        "///|",
        "pub typealias FMGenerationSchemaRef = UInt",
        "///|",
        "pub typealias FMGeneratedContentRef = UInt",
        "///|",
        "pub typealias FMGenerationSchemaPropertyRef = UInt",
        "///|",
        "pub typealias FMBridgedToolRef = UInt",
        "///|",
        "pub typealias FMComposedPromptRef = UInt",
        ""
    ]
    for func in spec["functions"]:
        params = []
        for param in func.get("params", []):
            params.append(f"  {param['name']} : {moonbit_type(param)}")
        ret = moonbit_type(func["returns"])
        ret_s = "" if ret == "Unit" else f" -> {ret}"
        borrowed = [p["name"] for p in func.get("params", []) if moonbit_type(p) == "Bytes"]
        lines.append("///|")
        if borrowed:
            lines.append(f"#borrow({', '.join(borrowed)})")
        if params:
            lines.append(f"extern \"c\" fn {func['name']}(")
            lines.append(",\n".join(params))
            lines.append(f"){ret_s} = \"{func['name']}\"")
        else:
            lines.append(f"extern \"c\" fn {func['name']}(){ret_s} = \"{func['name']}\"")
        lines.append("")
    return "\n".join(lines)


def main():
    spec = load_spec()
    header = render_header(spec)
    HEADER_PATH.write_text(header, encoding="utf-8")
    GO_HEADER_PATH.write_text(header, encoding="utf-8")
    MOONBIT_PATH.write_text(render_moonbit(spec), encoding="utf-8")


if __name__ == "__main__":
    main()
