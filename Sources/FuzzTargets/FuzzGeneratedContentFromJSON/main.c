/*
For licensing see accompanying LICENSE file.
Copyright (C) 2026 Apple Inc. All Rights Reserved.
*/

#include "FoundationModels.h"
#include <stdint.h>
#include <string.h>
#include <stdlib.h>

int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size) {
  // NUL-terminate the input for C string APIs.
  char *input = (char *)malloc(size + 1);
  if (!input) return 0;
  memcpy(input, data, size);
  input[size] = '\0';

  int errorCode = 0;
  char *errorDesc = NULL;
  FMGeneratedContentRef content = FMGeneratedContentCreateFromJSON(input, &errorCode, &errorDesc);
  if (errorDesc) FMFreeString(errorDesc);
  if (content) {
    // Exercise accessors with fixed property names.
    FMGeneratedContentHasProperty(content, "x");
    FMGeneratedContentHasProperty(content, "");

    double outD = 0.0;
    int outCode = 0;
    FMGeneratedContentGetPropertyValueAsDouble(content, "x", &outD, &outCode);

    int64_t outI = 0;
    FMGeneratedContentGetPropertyValueAsInt(content, "x", &outI, &outCode);

    bool outB = false;
    FMGeneratedContentGetPropertyValueAsBool(content, "x", &outB, &outCode);

    char *propVal = FMGeneratedContentGetPropertyValue(content, "x", &outCode, &errorDesc);
    if (propVal) FMFreeString(propVal);
    if (errorDesc) FMFreeString(errorDesc);

    char *names = FMGeneratedContentGetPropertyNames(content);
    if (names) FMFreeString(names);

    char *jsonStr = FMGeneratedContentGetJSONString(content);
    if (jsonStr) FMFreeString(jsonStr);

    FMGeneratedContentIsComplete(content);

    FMRelease(content);
  }

  free(input);
  return 0;
}