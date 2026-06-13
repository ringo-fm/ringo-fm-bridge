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

  FMSystemLanguageModelRef model = FMSystemLanguageModelGetDefault();
  FMLanguageModelSessionRef session = FMLanguageModelSessionCreateFromSystemLanguageModel(model, NULL, NULL, 0);

  // Enumerate all valid sentiments.
  FMFeedbackSentiment sentiments[] = {
    FMFeedbackSentimentNone,
    FMFeedbackSentimentPositive,
    FMFeedbackSentimentNegative,
    FMFeedbackSentimentNeutral,
  };

  for (int i = 0; i < 4; i++) {
    size_t outLength = 0;
    int errorCode = 0;
    char *errorDesc = NULL;
    char *result = FMLanguageModelSessionLogFeedbackAttachment(
        session, sentiments[i], input, NULL, &outLength, &errorCode, &errorDesc);
    if (result) FMFreeString(result);
    if (errorDesc) FMFreeString(errorDesc);
  }

  // Also test with NULL issues (no JSON).
  {
    size_t outLength = 0;
    int errorCode = 0;
    char *errorDesc = NULL;
    char *result = FMLanguageModelSessionLogFeedbackAttachment(
        session, FMFeedbackSentimentPositive, NULL, "desired text", &outLength, &errorCode, &errorDesc);
    if (result) FMFreeString(result);
    if (errorDesc) FMFreeString(errorDesc);
  }

  FMRelease(session);
  FMRelease(model);
  free(input);
  return 0;
}