/*
For licensing see accompanying LICENSE file.
Copyright (C) 2026 Apple Inc. All Rights Reserved.
*/

import Testing
import Foundation
import FoundationModels
import FoundationModelsCDeclarations

@Suite struct FuzzTests {

  @Test(arguments: [
    "{\"name\":\"Alice\",\"score\":99}",
    "{\"active\":true,\"disabled\":false}",
    "{\"price\":3.14,\"count\":7}",
    "{}",
    "",
    "null",
    "[1,2,3]",
    "not json",
    "{\"nested\":{\"deep\":1}}",
    "{\"large\":9223372036854775807}",
    "{\"neg\":-42}",
    "{\"empty\":\"\"}",
    "{\"unicode\":\"日本語\"}",
  ])
  func generatedContentFromJSON(_ input: String) {
    var code: Int32 = 0
    var desc: UnsafeMutablePointer<CChar>?
    let content = FMGeneratedContentCreateFromJSON(input, &code, &desc)
    if let desc { FMFreeString(desc) }
    guard let content else { return }
    defer { FMRelease(content) }

    let _ = FMGeneratedContentIsComplete(content)
    let _ = FMGeneratedContentHasProperty(content, "x")
    let _ = FMGeneratedContentHasProperty(content, "")

    var outD: Double = 0
    var outCode: Int32 = 0
    let _ = FMGeneratedContentGetPropertyValueAsDouble(content, "x", &outD, &outCode)

    var outI: Int64 = 0
    let _ = FMGeneratedContentGetPropertyValueAsInt(content, "x", &outI, &outCode)

    var outB: Bool = false
    let _ = FMGeneratedContentGetPropertyValueAsBool(content, "x", &outB, &outCode)

    var errCode: Int32 = 0
    var errDesc: UnsafeMutablePointer<CChar>?
    if let ptr = FMGeneratedContentGetPropertyValue(content, "x", &errCode, &errDesc) {
      FMFreeString(ptr)
    }
    if let errDesc { FMFreeString(errDesc) }

    if let names = FMGeneratedContentGetPropertyNames(content) {
      FMFreeString(names)
    }
    if let json = FMGeneratedContentGetJSONString(content) {
      FMFreeString(json)
    }
  }

  @Test(arguments: [
    "{\"version\":1,\"type\":\"transcript\",\"transcript\":{\"entries\":[]}}",
    "{}",
    "",
    "null",
    "not json",
    "{\"transcript\":{\"entries\":[{\"role\":\"user\",\"content\":\"hi\"}]}}",
  ])
  func transcriptFromJSON(_ input: String) {
    var code: Int32 = 0
    var desc: UnsafeMutablePointer<CChar>?
    let session = FMTranscriptCreateFromJSONString(input, &code, &desc)
    if let desc { FMFreeString(desc) }
    guard let session else { return }
    defer { FMRelease(session) }

    let _ = FMLanguageModelSessionGetTranscriptEntryCount(session)

    var ec2: Int32 = 0
    var ed2: UnsafeMutablePointer<CChar>?
    if let json = FMLanguageModelSessionGetTranscriptJSONString(session, &ec2, &ed2) {
      FMFreeString(json)
    }
    if let ed2 { FMFreeString(ed2) }
  }

  @Test(arguments: [
    "hello",
    "",
    "日本語",
    "line1\nline2",
    "tab\there",
    " Special chars: !@#$%^&*() ",
  ])
  func composedPromptAddText(_ text: String) {
    let prompt = FMComposedPromptInitialize()
    FMComposedPromptAddText(prompt, text)
    if let content = FMComposedPromptGetTextContent(prompt) {
      FMFreeString(content)
    }
    FMRelease(prompt)
  }

  @Test(arguments: [
    "TypeName", "X", "", "日本語",
  ])
  func schemaCreation(_ name: String) {
    let schema = FMGenerationSchemaCreate(name, nil)
    defer { FMRelease(schema) }

    let prop = FMGenerationSchemaPropertyCreate(name, nil, "String", true)
    FMGenerationSchemaAddProperty(schema, prop)
    FMRelease(prop)

    var code: Int32 = 0
    var desc: UnsafeMutablePointer<CChar>?
    if let json = FMGenerationSchemaGetJSONString(schema, &code, &desc) {
      FMFreeString(json)
    }
    if let desc { FMFreeString(desc) }
  }

  @Test(arguments: [
    "[a-z]+", "", "^$", "^(invalid", "\\d+",
  ])
  func schemaWithRegexGuide(_ pattern: String) {
    let schema = FMGenerationSchemaCreate("FuzzSchema", "test")
    defer { FMRelease(schema) }

    let prop = FMGenerationSchemaPropertyCreate("field1", nil, "String", false)
    FMGenerationSchemaPropertyAddRegex(prop, pattern, false)
    FMGenerationSchemaAddProperty(schema, prop)
    FMRelease(prop)
  }

  @Test(arguments: [
    ("", "", "String"),
    ("field", "desc", "Array<String>"),
    ("日本語", "説明", "Double"),
    ("with space", "line1\nline2", "Bool"),
  ])
  func schemaWithAllGuideFamilies(_ name: String, _ desc: String, _ typeName: String) {
    let schema = FMGenerationSchemaCreate("GuideFuzzSchema", nil)
    defer { FMRelease(schema) }

    let prop = FMGenerationSchemaPropertyCreate(name, desc, typeName, false)
    let choiceStrings: [String] = ["", "alpha", "日本語"]
    let allocatedChoices = choiceStrings.map { strdup($0)! }
    var choices = allocatedChoices.map { Optional(UnsafePointer<CChar>($0)) }
    choices.withUnsafeMutableBufferPointer { buffer in
      FMGenerationSchemaPropertyAddAnyOfGuide(prop, buffer.baseAddress!, Int32(buffer.count), false)
    }
    for choice in allocatedChoices {
      free(choice)
    }
    FMGenerationSchemaPropertyAddCountGuide(prop, 0, false)
    FMGenerationSchemaPropertyAddMinItemsGuide(prop, -1)
    FMGenerationSchemaPropertyAddMaxItemsGuide(prop, 3)
    FMGenerationSchemaPropertyAddMinimumGuide(prop, -Double.greatestFiniteMagnitude, false)
    FMGenerationSchemaPropertyAddMaximumGuide(prop, Double.greatestFiniteMagnitude, false)
    FMGenerationSchemaPropertyAddRangeGuide(prop, -1, 1, false)
    FMGenerationSchemaPropertyAddRegex(prop, ".*", false)
    FMGenerationSchemaAddProperty(schema, prop)
    FMRelease(prop)

    let referenced = FMGenerationSchemaCreate("Referenced", "nested")
    FMGenerationSchemaAddReferenceSchema(schema, referenced)
    FMRelease(referenced)

    var code: Int32 = 0
    var errorDesc: UnsafeMutablePointer<CChar>?
    if let json = FMGenerationSchemaGetJSONString(schema, &code, &errorDesc) {
      FMFreeString(json)
    }
    if let errorDesc { FMFreeString(errorDesc) }
  }

  @Test(arguments: [
    ("", ""),
    ("/tmp/no-such-image.png", ""),
    ("/tmp/no-such image.png", "label"),
    ("日本語.png", "識別子"),
  ])
  func promptAttachmentEdges(_ path: String, _ label: String) {
    let prompt = FMComposedPromptInitialize()
    defer { FMRelease(prompt) }

    var error = FMComposedPromptAddImageErrorNone
    _ = FMComposedPromptAddImage(prompt, path, &error)
    _ = FMComposedPromptAddIdentifiedImage(prompt, path, label, &error)
    _ = FMComposedPromptAddAttachment(prompt, path, label.isEmpty ? nil : label, &error)
    if let content = FMComposedPromptGetTextContent(prompt) {
      FMFreeString(content)
    }
  }

  @Test(arguments: [
    "",
    "{}",
    "{\"temperature\":0}",
    "{\"temperature\":-1,\"maximum_response_tokens\":0}",
    "{\"sampling\":{\"mode\":\"random\",\"top_k\":\"0\",\"top_p\":\"2\",\"seed\":\"-1\"}}",
    "not json",
  ])
  func respondOptionJSONIsAcceptedByAsyncEntryPoint(_ optionsJSON: String) {
    let session = FMLanguageModelSessionCreateDefault()
    let prompt = FMComposedPromptInitialize()
    FMComposedPromptAddText(prompt, "fuzz options")

    let task = FMLanguageModelSessionRespond(
      session,
      prompt,
      optionsJSON.isEmpty ? nil : optionsJSON,
      nil,
      { _, content, _, _ in
        _ = content
      }
    )
    FMTaskCancel(task)
    FMRelease(task)
    FMRelease(session)
  }

  @Test(arguments: [
    "{\"a\":1}",
    "{}",
    "",
    "not json",
  ])
  func feedbackDesiredContentEdges(_ desiredContentJSON: String) {
    let session = FMLanguageModelSessionCreateDefault()
    defer { FMRelease(session) }

    var length = 0
    var code: Int32 = 0
    var desc: UnsafeMutablePointer<CChar>?
    if let result = FMLanguageModelSessionLogFeedbackAttachmentWithDesiredResponseContent(
      session,
      FMFeedbackSentimentNeutral,
      "[]",
      desiredContentJSON,
      &length,
      &code,
      &desc
    ) {
      FMFreeString(result)
    }
    if let desc { FMFreeString(desc) }
  }

  @Test func afterCloseGeneratedContent() {
    var code: Int32 = 0
    var desc: UnsafeMutablePointer<CChar>?
    let content = FMGeneratedContentCreateFromJSON("{\"x\":1}", &code, &desc)
    if let desc { FMFreeString(desc) }
    guard let content else { return }

    let _ = FMGeneratedContentHasProperty(content, "x")
    FMRelease(content)
  }

  @Test func doubleRelease() {
    var code: Int32 = 0
    var desc: UnsafeMutablePointer<CChar>?
    let content = FMGeneratedContentCreateFromJSON("{\"x\":1}", &code, &desc)
    if let desc { FMFreeString(desc) }
    guard let content else { return }
    FMRelease(content)
  }

  @Test func prewarmEdgeCases() {
    let model = FMSystemLanguageModelGetDefault()
    let session = FMLanguageModelSessionCreateFromSystemLanguageModel(model, nil, nil, 0)
    defer {
      FMRelease(session)
      FMRelease(model)
    }

    FMLanguageModelSessionPrewarm(session, nil)
    FMLanguageModelSessionPrewarm(session, "")
    FMLanguageModelSessionPrewarm(session, "test prefix")
    #expect(!FMLanguageModelSessionIsResponding(session))
  }
}
