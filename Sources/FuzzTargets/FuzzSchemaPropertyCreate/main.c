/*
For licensing see accompanying LICENSE file.
Copyright (C) 2026 Apple Inc. All Rights Reserved.
*/

#include "FoundationModels.h"
#include <stdint.h>
#include <string.h>
#include <stdlib.h>

// Split fuzz input into 3 NUL-terminated strings: name, description, typeName.
static void split3(const uint8_t *data, size_t size,
                   char **a, char **b, char **c) {
  size_t i = 0;
  // Find first NUL or end.
  while (i < size && data[i] != 0) i++;
  *a = (char *)malloc(i + 1);
  memcpy(*a, data, i);
  (*a)[i] = '\0';

  size_t start = (i < size) ? i + 1 : size;
  size_t j = start;
  while (j < size && data[j] != 0) j++;
  size_t len_b = j - start;
  *b = (char *)malloc(len_b + 1);
  memcpy(*b, data + start, len_b);
  (*b)[len_b] = '\0';

  size_t start2 = (j < size) ? j + 1 : size;
  size_t k = start2;
  while (k < size && data[k] != 0) k++;
  size_t len_c = k - start2;
  *c = (char *)malloc(len_c + 1);
  memcpy(*c, data + start2, len_c);
  (*c)[len_c] = '\0';
}

int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size) {
  char *name, *desc, *typeName;
  split3(data, size, &name, &desc, &typeName);

  FMGenerationSchemaRef schema = FMGenerationSchemaCreate(name, desc[0] ? desc : NULL);

  FMGenerationSchemaPropertyRef prop = FMGenerationSchemaPropertyCreate(name, desc[0] ? desc : NULL, typeName, true);
  if (prop) {
    // Add a regex guide using typeName as a pattern (may be invalid regex).
    FMGenerationSchemaPropertyAddRegex(prop, typeName, false);
    FMGenerationSchemaAddProperty(schema, prop);
    FMRelease(prop);
  }

  int errorCode = 0;
  char *errorDesc = NULL;
  char *jsonStr = FMGenerationSchemaGetJSONString(schema, &errorCode, &errorDesc);
  if (jsonStr) FMFreeString(jsonStr);
  if (errorDesc) FMFreeString(errorDesc);

  FMRelease(schema);
  free(name);
  free(desc);
  free(typeName);
  return 0;
}