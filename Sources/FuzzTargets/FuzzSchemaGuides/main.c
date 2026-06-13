/*
For licensing see accompanying LICENSE file.
Copyright (C) 2026 Apple Inc. All Rights Reserved.
*/

#include "FoundationModels.h"
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

static char *slice_to_cstr(const uint8_t *data, size_t size) {
  char *out = (char *)malloc(size + 1);
  if (!out) return NULL;
  memcpy(out, data, size);
  out[size] = '\0';
  return out;
}

int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size) {
  size_t part = size / 3;
  char *name = slice_to_cstr(data, part);
  char *pattern = slice_to_cstr(data + part, part);
  char *typeName = slice_to_cstr(data + (part * 2), size - (part * 2));
  if (!name || !pattern || !typeName) goto done;

  FMGenerationSchemaRef schema = FMGenerationSchemaCreate("FuzzSchema", NULL);
  FMGenerationSchemaPropertyRef prop = FMGenerationSchemaPropertyCreate(name, NULL, typeName, false);
  const char *choices[] = {"", "alpha", name};
  FMGenerationSchemaPropertyAddAnyOfGuide(prop, choices, 3, false);
  FMGenerationSchemaPropertyAddCountGuide(prop, (int)(size % 8) - 2, false);
  FMGenerationSchemaPropertyAddMinItemsGuide(prop, (int)(size % 5) - 1);
  FMGenerationSchemaPropertyAddMaxItemsGuide(prop, (int)(size % 9));
  FMGenerationSchemaPropertyAddMinimumGuide(prop, -1.0 * (double)size, false);
  FMGenerationSchemaPropertyAddMaximumGuide(prop, (double)size, false);
  FMGenerationSchemaPropertyAddRangeGuide(prop, -10.0, 10.0, true);
  FMGenerationSchemaPropertyAddRegex(prop, pattern, false);
  FMGenerationSchemaAddProperty(schema, prop);
  FMRelease(prop);

  int code = 0;
  char *desc = NULL;
  char *json = FMGenerationSchemaGetJSONString(schema, &code, &desc);
  if (json) FMFreeString(json);
  if (desc) FMFreeString(desc);
  FMRelease(schema);

done:
  free(name);
  free(pattern);
  free(typeName);
  return 0;
}
