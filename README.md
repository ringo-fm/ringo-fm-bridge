# Ringo FM Bridge

Shared Swift/C bridge for the Ringo Foundation Models SDKs.

This repository is the source of truth for the C ABI used by:

- `f4ah6o/rust-ringo-fm-sdk`
- `f4ah6o/go-ringo-fm-sdk`
- `f4ah6o/moonbit-ringo-fm-sdk`

The bridge implementation is Swift, while the public ABI is C so Rust, Go, and
MoonBit can call it through their normal FFI systems.

## Source Of Truth

`api/bridge.json` is the only source of truth for the C ABI.

The following files are generated from it and must not be edited by hand:

- `Sources/FoundationModelsCBindings/include/FoundationModels.h`
- `generated/go/FoundationModels.h`
- `generated/moonbit/ffi_bridge.mbt`

Regenerate them with:

```sh
python3 tools/generate-bridge/generate.py
```

CI runs the generator and then `git diff --exit-code` to detect drift or manual
edits to generated files.

## Build

Requirements:

- macOS 26+
- Xcode 26+
- Swift 6.2+

```sh
swift build -c release
swift test
```

## ABI Rules

The ABI definition records:

- ABI version
- function stability: `stable`, `experimental`, or `future`
- string/object ownership and required free functions
- nullable rules
- error handling conventions
- iterator lifetime and stream ownership
- cancellation semantics

Returned `char *` strings are owned by the caller and must be released with
`FMFreeString`. Opaque object refs returned by create/get/stream functions are
owned by the caller and must be released with `FMRelease` unless explicitly
documented otherwise.

## Generated Outputs

Rust uses bindgen against the generated C header, so no Rust-specific generated
file is committed here.

Go uses `generated/go/FoundationModels.h` as the cgo-facing header template.

MoonBit uses `generated/moonbit/ffi_bridge.mbt` as the generated low-level FFI
declaration template.

## Roadmap

PDF/OCR/table extraction APIs are intentionally not fixed in the initial ABI.
They will be added to `api/bridge.json` after this generated ABI baseline is
stable.

Migration of the three SDK repositories to this bridge repository will happen in
separate commits after this repository is established.
