/*
For licensing see accompanying LICENSE file.
Copyright (C) 2026 Apple Inc. All Rights Reserved.
*/

#include "FoundationModels.h"
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size) {
  char *path = (char *)malloc(size + 1);
  if (!path) return 0;
  memcpy(path, data, size);
  path[size] = '\0';

  FMComposedPrompt prompt = FMComposedPromptInitialize();
  FMComposedPromptAddImageError error = FMComposedPromptAddImageErrorNone;
  FMComposedPromptAddImage(prompt, path, &error);
  FMComposedPromptAddIdentifiedImage(prompt, path, "fuzz-id", &error);
  FMComposedPromptAddAttachment(prompt, path, "", &error);
  char *text = FMComposedPromptGetTextContent(prompt);
  if (text) FMFreeString(text);
  FMRelease(prompt);

  free(path);
  return 0;
}
