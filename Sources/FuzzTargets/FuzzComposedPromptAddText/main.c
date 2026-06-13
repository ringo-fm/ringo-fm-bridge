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

  FMComposedPrompt prompt = FMComposedPromptInitialize();
  // FMComposedPromptAddText takes a non-null const char*.
  FMComposedPromptAddText(prompt, input);

  char *textContent = FMComposedPromptGetTextContent(prompt);
  if (textContent) FMFreeString(textContent);

  FMRelease(prompt);
  free(input);
  return 0;
}