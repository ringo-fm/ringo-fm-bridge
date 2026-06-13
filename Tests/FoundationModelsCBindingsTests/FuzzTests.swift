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