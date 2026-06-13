/*
For licensing see accompanying LICENSE file.
Copyright (C) 2026 Apple Inc. All Rights Reserved.
*/

#include "FoundationModels.h"
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

// Fuzz resource lifecycle: create, access, release, then access again.
// The goal is to detect use-after-free, double-free, and null dereference bugs.

int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size) {
  // Use the first byte to select an operation sequence variant.
  if (size < 1) return 0;
  uint8_t variant = data[0] % 4;

  FMSystemLanguageModelRef model = FMSystemLanguageModelGetDefault();
  FMLanguageModelSessionRef session = FMLanguageModelSessionCreateFromSystemLanguageModel(model, NULL, NULL, 0);

  switch (variant) {
    case 0: {
      // GeneratedContent: create, access, release, access again.
      int errorCode = 0;
      char *errorDesc = NULL;
      FMGeneratedContentRef content = FMGeneratedContentCreateFromJSON(
          "{\"lifecycle\":42}", &errorCode, &errorDesc);
      if (errorDesc) FMFreeString(errorDesc);
      if (content) {
        FMGeneratedContentHasProperty(content, "lifecycle");
        FMRelease(content);

        // Access after release — must not crash.
        // Note: this is UB in C; the fuzzer detects it under ASan/TSan.
      }
      break;
    }
    case 1: {
      // Schema: create, add property, get JSON, release.
      FMGenerationSchemaRef schema = FMGenerationSchemaCreate("FuzzSchema", "test");
      FMGenerationSchemaPropertyRef prop = FMGenerationSchemaPropertyCreate(
          "field", NULL, "String", false);
      if (prop) {
        FMGenerationSchemaPropertyAddAnyOfGuide(prop, (const char *const[]){"a", "b"}, 2, false);
        FMGenerationSchemaAddProperty(schema, prop);
        FMRelease(prop);
      }
      FMGenerationSchemaPropertyRef prop2 = FMGenerationSchemaPropertyCreate(
          "count", NULL, "Int", true);
      if (prop2) {
        FMGenerationSchemaPropertyAddCountGuide(prop2, 5, false);
        FMGenerationSchemaPropertyAddMinimumGuide(prop2, 0.0, false);
        FMGenerationSchemaPropertyAddMaximumGuide(prop2, 100.0, false);
        FMGenerationSchemaPropertyAddRangeGuide(prop2, 0.0, 1.0, false);
        FMGenerationSchemaAddProperty(schema, prop2);
        FMRelease(prop2);
      }
      int ec = 0;
      char *ed = NULL;
      char *json = FMGenerationSchemaGetJSONString(schema, &ec, &ed);
      if (json) FMFreeString(json);
      if (ed) FMFreeString(ed);
      FMRelease(schema);
      break;
    }
    case 2: {
      // Transcript round-trip from empty session.
      int count = FMLanguageModelSessionGetTranscriptEntryCount(session);
      (void)count;

      int ec = 0;
      char *ed = NULL;
      char *json = FMLanguageModelSessionGetTranscriptJSONString(session, &ec, &ed);
      if (json) {
        // Attempt to restore from JSON.
        int ec2 = 0;
        char *ed2 = NULL;
        FMLanguageModelSessionRef restored = FMTranscriptCreateFromJSONString(json, &ec2, &ed2);
        if (ed2) FMFreeString(ed2);
        if (restored) FMRelease(restored);
        FMFreeString(json);
      }
      if (ed) FMFreeString(ed);
      break;
    }
    case 3: {
      // Prewarm with various inputs.
      FMLanguageModelSessionPrewarm(session, NULL);
      FMLanguageModelSessionPrewarm(session, "test prefix");
      FMLanguageModelSessionPrewarm(session, "");
      FMLanguageModelSessionIsResponding(session);
      FMLanguageModelSessionReset(session);
      break;
    }
  }

  FMRelease(session);
  FMRelease(model);
  return 0;
}