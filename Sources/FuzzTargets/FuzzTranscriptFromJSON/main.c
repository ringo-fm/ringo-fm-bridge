/*
For licensing see accompanying LICENSE file.
Copyright (C) 2026 Apple Inc. All Rights Reserved.
*/

#include "FoundationModels.h"
#include <stdint.h>
#include <string.h>
#include <stdlib.h>

int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size) {
  char *input = (char *)malloc(size + 1);
  if (!input) return 0;
  memcpy(input, data, size);
  input[size] = '\0';

  int errorCode = 0;
  char *errorDesc = NULL;
  FMLanguageModelSessionRef session = FMTranscriptCreateFromJSONString(input, &errorCode, &errorDesc);
  if (errorDesc) FMFreeString(errorDesc);
  if (session) {
    int count = FMLanguageModelSessionGetTranscriptEntryCount(session);
    (void)count;

    char *jsonOut = FMLanguageModelSessionGetTranscriptJSONString(session, &errorCode, &errorDesc);
    if (jsonOut) FMFreeString(jsonOut);
    if (errorDesc) FMFreeString(errorDesc);

    FMRelease(session);
  }

  free(input);
  return 0;
}