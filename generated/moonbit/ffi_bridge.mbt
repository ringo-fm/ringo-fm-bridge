///|
/// generated from api/bridge.json; do not edit
/// ABI version: 0.1.0

///|
pub typealias FMTaskRef = UInt
///|
pub typealias FMSystemLanguageModelRef = UInt
///|
pub typealias FMLanguageModelSessionRef = UInt
///|
pub typealias FMLanguageModelSessionResponseStreamRef = UInt
///|
pub typealias FMGenerationSchemaRef = UInt
///|
pub typealias FMGeneratedContentRef = UInt
///|
pub typealias FMGenerationSchemaPropertyRef = UInt
///|
pub typealias FMBridgedToolRef = UInt
///|
pub typealias FMComposedPromptRef = UInt

///|
extern "c" fn FMSystemLanguageModelGetDefault() -> UInt = "FMSystemLanguageModelGetDefault"

///|
extern "c" fn FMSystemLanguageModelCreate(
  useCase : Int,
  guardrails : Int
) -> UInt = "FMSystemLanguageModelCreate"

///|
extern "c" fn FMSystemLanguageModelIsAvailable(
  ref : UInt,
  unavailableReason : UInt
) -> Bool = "FMSystemLanguageModelIsAvailable"

///|
extern "c" fn FMLanguageModelSessionCreateDefault() -> UInt = "FMLanguageModelSessionCreateDefault"

///|
#borrow(instructions)
extern "c" fn FMLanguageModelSessionCreateFromSystemLanguageModel(
  model : UInt,
  instructions : Bytes,
  tools : UInt,
  toolCount : Int
) -> UInt = "FMLanguageModelSessionCreateFromSystemLanguageModel"

///|
extern "c" fn FMComposedPromptInitialize() -> UInt = "FMComposedPromptInitialize"

///|
#borrow(text)
extern "c" fn FMComposedPromptAddText(
  composedPrompt : UInt,
  text : Bytes
) = "FMComposedPromptAddText"

///|
#borrow(imagePath)
extern "c" fn FMComposedPromptAddImage(
  composedPrompt : UInt,
  imagePath : Bytes,
  error : UInt
) -> Bool = "FMComposedPromptAddImage"

///|
#borrow(imagePath, imageIdentifier)
extern "c" fn FMComposedPromptAddIdentifiedImage(
  composedPrompt : UInt,
  imagePath : Bytes,
  imageIdentifier : Bytes,
  error : UInt
) -> Bool = "FMComposedPromptAddIdentifiedImage"

///|
#borrow(imagePath, label)
extern "c" fn FMComposedPromptAddAttachment(
  composedPrompt : UInt,
  imagePath : Bytes,
  label : Bytes,
  error : UInt
) -> Bool = "FMComposedPromptAddAttachment"

///|
extern "c" fn FMLanguageModelSessionCreateFromTranscript(
  transcriptSession : UInt,
  model : UInt,
  tools : UInt,
  toolCount : Int
) -> UInt = "FMLanguageModelSessionCreateFromTranscript"

///|
extern "c" fn FMLanguageModelSessionIsResponding(
  session : UInt
) -> Bool = "FMLanguageModelSessionIsResponding"

///|
extern "c" fn FMLanguageModelSessionReset(
  session : UInt
) = "FMLanguageModelSessionReset"

///|
#borrow(promptPrefix)
extern "c" fn FMLanguageModelSessionPrewarm(
  session : UInt,
  promptPrefix : Bytes
) = "FMLanguageModelSessionPrewarm"

///|
#borrow(optionsJSON)
extern "c" fn FMLanguageModelSessionRespond(
  session : UInt,
  composedPrompt : UInt,
  optionsJSON : Bytes,
  userInfo : UInt,
  callback : UInt
) -> UInt = "FMLanguageModelSessionRespond"

///|
#borrow(optionsJSON)
extern "c" fn FMLanguageModelSessionStreamResponse(
  session : UInt,
  composedPrompt : UInt,
  optionsJSON : Bytes
) -> UInt = "FMLanguageModelSessionStreamResponse"

///|
extern "c" fn FMLanguageModelSessionResponseStreamIterate(
  stream : UInt,
  userInfo : UInt,
  callback : UInt
) = "FMLanguageModelSessionResponseStreamIterate"

///|
#borrow(optionsJSON)
extern "c" fn FMLanguageModelSessionStreamResponseWithSchema(
  session : UInt,
  composedPrompt : UInt,
  schema : UInt,
  includeSchemaInPrompt : Bool,
  optionsJSON : Bytes
) -> UInt = "FMLanguageModelSessionStreamResponseWithSchema"

///|
extern "c" fn FMLanguageModelSessionStructuredResponseStreamIterate(
  stream : UInt,
  userInfo : UInt,
  callback : UInt
) = "FMLanguageModelSessionStructuredResponseStreamIterate"

///|
#borrow(jsonString, outErrorDescription)
extern "c" fn FMTranscriptCreateFromJSONString(
  jsonString : Bytes,
  outErrorCode : UInt,
  outErrorDescription : Bytes
) -> UInt = "FMTranscriptCreateFromJSONString"

///|
#borrow(outErrorDescription)
extern "c" fn FMLanguageModelSessionGetTranscriptJSONString(
  session : UInt,
  outErrorCode : UInt,
  outErrorDescription : Bytes
) -> Bytes = "FMLanguageModelSessionGetTranscriptJSONString"

///|
#borrow(name, description)
extern "c" fn FMGenerationSchemaCreate(
  name : Bytes,
  description : Bytes
) -> UInt = "FMGenerationSchemaCreate"

///|
#borrow(name, description, typeName)
extern "c" fn FMGenerationSchemaPropertyCreate(
  name : Bytes,
  description : Bytes,
  typeName : Bytes,
  isOptional : Bool
) -> UInt = "FMGenerationSchemaPropertyCreate"

///|
#borrow(anyOf)
extern "c" fn FMGenerationSchemaPropertyAddAnyOfGuide(
  property : UInt,
  anyOf : Bytes,
  choiceCount : Int,
  wrapped : Bool
) = "FMGenerationSchemaPropertyAddAnyOfGuide"

///|
extern "c" fn FMGenerationSchemaPropertyAddCountGuide(
  property : UInt,
  count : Int,
  wrapped : Bool
) = "FMGenerationSchemaPropertyAddCountGuide"

///|
extern "c" fn FMGenerationSchemaPropertyAddMaximumGuide(
  property : UInt,
  maximum : Double,
  wrapped : Bool
) = "FMGenerationSchemaPropertyAddMaximumGuide"

///|
extern "c" fn FMGenerationSchemaPropertyAddMinimumGuide(
  property : UInt,
  minimum : Double,
  wrapped : Bool
) = "FMGenerationSchemaPropertyAddMinimumGuide"

///|
extern "c" fn FMGenerationSchemaPropertyAddMinItemsGuide(
  property : UInt,
  minItems : Int
) = "FMGenerationSchemaPropertyAddMinItemsGuide"

///|
extern "c" fn FMGenerationSchemaPropertyAddMaxItemsGuide(
  property : UInt,
  maxItems : Int
) = "FMGenerationSchemaPropertyAddMaxItemsGuide"

///|
extern "c" fn FMGenerationSchemaPropertyAddRangeGuide(
  property : UInt,
  minValue : Double,
  maxValue : Double,
  wrapped : Bool
) = "FMGenerationSchemaPropertyAddRangeGuide"

///|
#borrow(pattern)
extern "c" fn FMGenerationSchemaPropertyAddRegex(
  property : UInt,
  pattern : Bytes,
  wrapped : Bool
) = "FMGenerationSchemaPropertyAddRegex"

///|
extern "c" fn FMGenerationSchemaAddProperty(
  schema : UInt,
  property : UInt
) = "FMGenerationSchemaAddProperty"

///|
extern "c" fn FMGenerationSchemaAddReferenceSchema(
  schema : UInt,
  referenceSchema : UInt
) = "FMGenerationSchemaAddReferenceSchema"

///|
#borrow(outErrorDescription)
extern "c" fn FMGenerationSchemaGetJSONString(
  schema : UInt,
  outErrorCode : UInt,
  outErrorDescription : Bytes
) -> Bytes = "FMGenerationSchemaGetJSONString"

///|
#borrow(jsonString, outErrorDescription)
extern "c" fn FMGeneratedContentCreateFromJSON(
  jsonString : Bytes,
  outErrorCode : UInt,
  outErrorDescription : Bytes
) -> UInt = "FMGeneratedContentCreateFromJSON"

///|
extern "c" fn FMGeneratedContentGetJSONString(
  content : UInt
) -> Bytes = "FMGeneratedContentGetJSONString"

///|
#borrow(propertyName, outErrorDescription)
extern "c" fn FMGeneratedContentGetPropertyValue(
  content : UInt,
  propertyName : Bytes,
  outErrorCode : UInt,
  outErrorDescription : Bytes
) -> Bytes = "FMGeneratedContentGetPropertyValue"

///|
extern "c" fn FMGeneratedContentIsComplete(
  content : UInt
) -> Bool = "FMGeneratedContentIsComplete"

///|
#borrow(propertyName)
extern "c" fn FMGeneratedContentHasProperty(
  content : UInt,
  propertyName : Bytes
) -> Bool = "FMGeneratedContentHasProperty"

///|
#borrow(optionsJSON)
extern "c" fn FMLanguageModelSessionRespondWithSchema(
  session : UInt,
  composedPrompt : UInt,
  schema : UInt,
  optionsJSON : Bytes,
  userInfo : UInt,
  callback : UInt
) -> UInt = "FMLanguageModelSessionRespondWithSchema"

///|
#borrow(schemaJSONString, optionsJSON)
extern "c" fn FMLanguageModelSessionRespondWithSchemaFromJSON(
  session : UInt,
  composedPrompt : UInt,
  schemaJSONString : Bytes,
  optionsJSON : Bytes,
  userInfo : UInt,
  callback : UInt
) -> UInt = "FMLanguageModelSessionRespondWithSchemaFromJSON"

///|
#borrow(name, description, outErrorDescription)
extern "c" fn FMBridgedToolCreate(
  name : Bytes,
  description : Bytes,
  parameters : UInt,
  callable : UInt,
  outErrorCode : UInt,
  outErrorDescription : Bytes
) -> UInt = "FMBridgedToolCreate"

///|
#borrow(output)
extern "c" fn FMBridgedToolFinishCall(
  tool : UInt,
  callId : UInt,
  output : Bytes
) = "FMBridgedToolFinishCall"

///|
extern "c" fn FMTaskCancel(
  task : UInt
) = "FMTaskCancel"

///|
extern "c" fn FMRetain(
  object : UInt
) = "FMRetain"

///|
extern "c" fn FMRelease(
  object : UInt
) = "FMRelease"

///|
#borrow(str)
extern "c" fn FMFreeString(
  str : Bytes
) = "FMFreeString"
