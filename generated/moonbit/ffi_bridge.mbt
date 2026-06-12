///|
/// generated from api/bridge.json; do not edit
/// ABI version: 0.1.0
///
/// Objects: All opaque object references returned from create/get/stream functions are +1 retained unless the function documentation says otherwise. Call FMRelease when finished.
/// Strings: All nullable char* return values are heap-allocated by the bridge. Call FMFreeString exactly once when finished.
/// Borrowed: Pointers passed as arguments are borrowed for the duration of the call only.

///|
/// FMTaskRef opaque reference.
/// ownership: owned
#external
pub type FMTaskRef

///|
/// FMSystemLanguageModelRef opaque reference.
/// ownership: owned
#external
pub type FMSystemLanguageModelRef

///|
/// FMLanguageModelSessionRef opaque reference.
/// ownership: owned
#external
pub type FMLanguageModelSessionRef

///|
/// FMLanguageModelSessionResponseStreamRef opaque reference.
/// ownership: owned
#external
pub type FMLanguageModelSessionResponseStreamRef

///|
/// FMGenerationSchemaRef opaque reference.
/// ownership: owned
#external
pub type FMGenerationSchemaRef

///|
/// FMGeneratedContentRef opaque reference.
/// ownership: owned
#external
pub type FMGeneratedContentRef

///|
/// FMGenerationSchemaPropertyRef opaque reference.
/// ownership: owned
#external
pub type FMGenerationSchemaPropertyRef

///|
/// FMBridgedToolRef opaque reference.
/// ownership: owned
#external
pub type FMBridgedToolRef

///|
/// FMComposedPromptRef opaque reference.
/// ownership: owned
/// C ABI type: FMComposedPrompt
#external
pub type FMComposedPromptRef

///|
/// FMSystemLanguageModelUnavailableReason enum constants.
/// stability: stable
pub type FMSystemLanguageModelUnavailableReason = Int

///|
/// FMSystemLanguageModelUnavailableReasonAppleIntelligenceNotEnabled value for FMSystemLanguageModelUnavailableReason.
pub const FMSystemLanguageModelUnavailableReasonAppleIntelligenceNotEnabled : FMSystemLanguageModelUnavailableReason = 0

///|
/// FMSystemLanguageModelUnavailableReasonDeviceNotEligible value for FMSystemLanguageModelUnavailableReason.
pub const FMSystemLanguageModelUnavailableReasonDeviceNotEligible : FMSystemLanguageModelUnavailableReason = 1

///|
/// FMSystemLanguageModelUnavailableReasonModelNotReady value for FMSystemLanguageModelUnavailableReason.
pub const FMSystemLanguageModelUnavailableReasonModelNotReady : FMSystemLanguageModelUnavailableReason = 2

///|
/// FMSystemLanguageModelUnavailableReasonUnknown value for FMSystemLanguageModelUnavailableReason.
pub const FMSystemLanguageModelUnavailableReasonUnknown : FMSystemLanguageModelUnavailableReason = 0xFF

///|
/// FMSystemLanguageModelUseCase enum constants.
/// stability: stable
pub type FMSystemLanguageModelUseCase = Int

///|
/// FMSystemLanguageModelUseCaseGeneral value for FMSystemLanguageModelUseCase.
pub const FMSystemLanguageModelUseCaseGeneral : FMSystemLanguageModelUseCase = 0

///|
/// FMSystemLanguageModelUseCaseContentTagging value for FMSystemLanguageModelUseCase.
pub const FMSystemLanguageModelUseCaseContentTagging : FMSystemLanguageModelUseCase = 1

///|
/// FMSystemLanguageModelGuardrails enum constants.
/// stability: stable
pub type FMSystemLanguageModelGuardrails = Int

///|
/// FMSystemLanguageModelGuardrailsDefault value for FMSystemLanguageModelGuardrails.
pub const FMSystemLanguageModelGuardrailsDefault : FMSystemLanguageModelGuardrails = 0

///|
/// FMSystemLanguageModelGuardrailsPermissiveContentTransformations value for FMSystemLanguageModelGuardrails.
pub const FMSystemLanguageModelGuardrailsPermissiveContentTransformations : FMSystemLanguageModelGuardrails = 1

///|
/// FMFeedbackSentiment enum constants.
/// stability: stable
pub type FMFeedbackSentiment = Int

///|
/// FMFeedbackSentimentNone value for FMFeedbackSentiment.
pub const FMFeedbackSentimentNone : FMFeedbackSentiment = 0

///|
/// FMFeedbackSentimentPositive value for FMFeedbackSentiment.
pub const FMFeedbackSentimentPositive : FMFeedbackSentiment = 1

///|
/// FMFeedbackSentimentNegative value for FMFeedbackSentiment.
pub const FMFeedbackSentimentNegative : FMFeedbackSentiment = 2

///|
/// FMFeedbackSentimentNeutral value for FMFeedbackSentiment.
pub const FMFeedbackSentimentNeutral : FMFeedbackSentiment = 3

///|
/// FMComposedPromptAddImageError enum constants.
/// stability: stable
pub type FMComposedPromptAddImageError = Int

///|
/// FMComposedPromptAddImageErrorNone value for FMComposedPromptAddImageError.
pub const FMComposedPromptAddImageErrorNone : FMComposedPromptAddImageError = 0

///|
/// FMComposedPromptAddImageErrorUnsupported value for FMComposedPromptAddImageError.
pub const FMComposedPromptAddImageErrorUnsupported : FMComposedPromptAddImageError = 1

///|
/// FMComposedPromptAddImageErrorUnknown value for FMComposedPromptAddImageError.
pub const FMComposedPromptAddImageErrorUnknown : FMComposedPromptAddImageError = 2

///|
/// FMLanguageModelSessionResponseCallback callback pointer.
/// stability: stable
/// MoonBit native FFI passes callback pointers as UInt in the generated ABI declarations.
/// param content: nullable: true, const: true, pointer: true
/// param userInfo: nullable: true, pointer: true
pub type FMLanguageModelSessionResponseCallback = UInt

///|
/// FMLanguageModelSessionStructuredResponseCallback callback pointer.
/// stability: stable
/// MoonBit native FFI passes callback pointers as UInt in the generated ABI declarations.
/// param content: nullable: true
/// param userInfo: nullable: true, pointer: true
pub type FMLanguageModelSessionStructuredResponseCallback = UInt

///|
/// SystemLanguageModel: FMSystemLanguageModelGetDefault.
/// stability: stable
/// returns: ownership: owned, nullable: false
extern "c" fn fm_system_language_model_get_default() -> FMSystemLanguageModelRef = "FMSystemLanguageModelGetDefault"

///|
/// SystemLanguageModel: FMSystemLanguageModelCreate.
/// stability: stable
/// returns: ownership: owned, nullable: false
extern "c" fn fm_system_language_model_create(
  use_case : FMSystemLanguageModelUseCase,
  guardrails : FMSystemLanguageModelGuardrails
) -> FMSystemLanguageModelRef = "FMSystemLanguageModelCreate"

///|
/// SystemLanguageModel: FMSystemLanguageModelIsAvailable.
/// stability: stable
/// param ref: nullable: false
/// param unavailableReason: direction: out, nullable: true, pointer: true
#borrow(ref_)
extern "c" fn fm_system_language_model_is_available(
  ref_ : FMSystemLanguageModelRef,
  unavailable_reason : UInt
) -> Bool = "FMSystemLanguageModelIsAvailable"

///|
/// LanguageModelSession: FMLanguageModelSessionCreateDefault.
/// stability: stable
/// returns: ownership: owned, nullable: false
extern "c" fn fm_language_model_session_create_default() -> FMLanguageModelSessionRef = "FMLanguageModelSessionCreateDefault"

///|
/// LanguageModelSession: FMLanguageModelSessionCreateFromSystemLanguageModel.
/// stability: stable
/// returns: ownership: owned, nullable: false
/// param model: nullable: true
/// param instructions: nullable: true, const: true, pointer: true
/// param tools: nullable: true, array: true, pointer: true
#borrow(model, instructions)
extern "c" fn fm_language_model_session_create_from_system_language_model(
  model : FMSystemLanguageModelRef,
  instructions : Bytes,
  tools : UInt,
  tool_count : Int
) -> FMLanguageModelSessionRef = "FMLanguageModelSessionCreateFromSystemLanguageModel"

///|
/// Prompt construction: FMComposedPromptInitialize.
/// stability: stable
/// returns: ownership: owned, nullable: false
extern "c" fn fm_composed_prompt_initialize() -> FMComposedPromptRef = "FMComposedPromptInitialize"

///|
/// Prompt construction: FMComposedPromptAddText.
/// stability: stable
/// param composedPrompt: nullable: false
/// param text: nullable: false, const: true, pointer: true
#borrow(composed_prompt, text)
extern "c" fn fm_composed_prompt_add_text(
  composed_prompt : FMComposedPromptRef,
  text : Bytes
) = "FMComposedPromptAddText"

///|
/// Prompt construction: FMComposedPromptGetTextContent.
/// stability: stable
/// returns: ownership: string, nullable: true, pointer: true
/// param composedPrompt: nullable: false
#borrow(composed_prompt)
extern "c" fn fm_composed_prompt_get_text_content(
  composed_prompt : FMComposedPromptRef
) -> Bytes = "FMComposedPromptGetTextContent"

///|
/// Prompt construction: FMComposedPromptAddImage.
/// stability: stable
/// param composedPrompt: nullable: false
/// param imagePath: nullable: false, const: true, pointer: true
/// param error: direction: out, nullable: true, pointer: true
#borrow(composed_prompt, image_path)
extern "c" fn fm_composed_prompt_add_image(
  composed_prompt : FMComposedPromptRef,
  image_path : Bytes,
  error : UInt
) -> Bool = "FMComposedPromptAddImage"

///|
/// Prompt construction: FMComposedPromptAddIdentifiedImage.
/// stability: stable
/// param composedPrompt: nullable: false
/// param imagePath: nullable: false, const: true, pointer: true
/// param imageIdentifier: nullable: false, const: true, pointer: true
/// param error: direction: out, nullable: true, pointer: true
#borrow(composed_prompt, image_path, image_identifier)
extern "c" fn fm_composed_prompt_add_identified_image(
  composed_prompt : FMComposedPromptRef,
  image_path : Bytes,
  image_identifier : Bytes,
  error : UInt
) -> Bool = "FMComposedPromptAddIdentifiedImage"

///|
/// Prompt construction: FMComposedPromptAddAttachment.
/// stability: stable
/// param composedPrompt: nullable: false
/// param imagePath: nullable: false, const: true, pointer: true
/// param label: nullable: true, const: true, pointer: true
/// param error: direction: out, nullable: true, pointer: true
#borrow(composed_prompt, image_path, label)
extern "c" fn fm_composed_prompt_add_attachment(
  composed_prompt : FMComposedPromptRef,
  image_path : Bytes,
  label : Bytes,
  error : UInt
) -> Bool = "FMComposedPromptAddAttachment"

///|
/// Response functions: FMLanguageModelSessionCreateFromTranscript.
/// stability: stable
/// returns: ownership: owned, nullable: false
/// param transcriptSession: nullable: false
/// param model: nullable: true
/// param tools: nullable: true, array: true, pointer: true
#borrow(transcript_session, model)
extern "c" fn fm_language_model_session_create_from_transcript(
  transcript_session : FMLanguageModelSessionRef,
  model : FMSystemLanguageModelRef,
  tools : UInt,
  tool_count : Int
) -> FMLanguageModelSessionRef = "FMLanguageModelSessionCreateFromTranscript"

///|
/// Response functions: FMLanguageModelSessionIsResponding.
/// stability: stable
/// param session: nullable: false
#borrow(session)
extern "c" fn fm_language_model_session_is_responding(
  session : FMLanguageModelSessionRef
) -> Bool = "FMLanguageModelSessionIsResponding"

///|
/// Response functions: FMLanguageModelSessionReset.
/// stability: stable
/// param session: nullable: false
#borrow(session)
extern "c" fn fm_language_model_session_reset(
  session : FMLanguageModelSessionRef
) = "FMLanguageModelSessionReset"

///|
/// Response functions: FMLanguageModelSessionPrewarm.
/// stability: stable
/// param session: nullable: false
/// param promptPrefix: nullable: true, const: true, pointer: true
#borrow(session, prompt_prefix)
extern "c" fn fm_language_model_session_prewarm(
  session : FMLanguageModelSessionRef,
  prompt_prefix : Bytes
) = "FMLanguageModelSessionPrewarm"

///|
/// Response functions: FMLanguageModelSessionRespond.
/// stability: stable
/// returns: ownership: owned
/// param session: nullable: false
/// param composedPrompt: nullable: false
/// param optionsJSON: nullable: true, const: true, pointer: true
/// param userInfo: nullable: true, pointer: true
#borrow(session, composed_prompt, options_json)
extern "c" fn fm_language_model_session_respond(
  session : FMLanguageModelSessionRef,
  composed_prompt : FMComposedPromptRef,
  options_json : Bytes,
  user_info : UInt,
  callback : UInt
) -> FMTaskRef = "FMLanguageModelSessionRespond"

///|
/// Response functions: FMLanguageModelSessionStreamResponse.
/// stability: stable
/// returns: ownership: owned, nullable: false
/// param session: nullable: false
/// param composedPrompt: nullable: false
/// param optionsJSON: nullable: true, const: true, pointer: true
#borrow(session, composed_prompt, options_json)
extern "c" fn fm_language_model_session_stream_response(
  session : FMLanguageModelSessionRef,
  composed_prompt : FMComposedPromptRef,
  options_json : Bytes
) -> FMLanguageModelSessionResponseStreamRef = "FMLanguageModelSessionStreamResponse"

///|
/// Response functions: FMLanguageModelSessionResponseStreamIterate.
/// stability: stable
/// param stream: nullable: false
/// param userInfo: nullable: true, pointer: true
#borrow(stream)
extern "c" fn fm_language_model_session_response_stream_iterate(
  stream : FMLanguageModelSessionResponseStreamRef,
  user_info : UInt,
  callback : UInt
) = "FMLanguageModelSessionResponseStreamIterate"

///|
/// Response functions: FMLanguageModelSessionStreamResponseWithSchema.
/// stability: experimental
/// returns: ownership: owned, nullable: false
/// param session: nullable: false
/// param composedPrompt: nullable: false
/// param schema: nullable: false
/// param optionsJSON: nullable: true, const: true, pointer: true
#borrow(session, composed_prompt, schema, options_json)
extern "c" fn fm_language_model_session_stream_response_with_schema(
  session : FMLanguageModelSessionRef,
  composed_prompt : FMComposedPromptRef,
  schema : FMGenerationSchemaRef,
  include_schema_in_prompt : Bool,
  options_json : Bytes
) -> FMLanguageModelSessionResponseStreamRef = "FMLanguageModelSessionStreamResponseWithSchema"

///|
/// Response functions: FMLanguageModelSessionStructuredResponseStreamIterate.
/// stability: experimental
/// param stream: nullable: false
/// param userInfo: nullable: true, pointer: true
#borrow(stream)
extern "c" fn fm_language_model_session_structured_response_stream_iterate(
  stream : FMLanguageModelSessionResponseStreamRef,
  user_info : UInt,
  callback : UInt
) = "FMLanguageModelSessionStructuredResponseStreamIterate"

///|
/// Transcript functions: FMTranscriptCreateFromJSONString.
/// stability: stable
/// returns: ownership: owned, nullable: true
/// param jsonString: nullable: false, const: true, pointer: true
/// param outErrorCode: direction: out, nullable: true, pointer: true
/// param outErrorDescription: direction: out, nullable: true, pointerDepth: 2
#borrow(json_string, out_error_description)
extern "c" fn fm_transcript_create_from_json_string(
  json_string : Bytes,
  out_error_code : UInt,
  out_error_description : Bytes
) -> FMLanguageModelSessionRef = "FMTranscriptCreateFromJSONString"

///|
/// Transcript functions: FMLanguageModelSessionGetTranscriptJSONString.
/// stability: stable
/// returns: ownership: string, nullable: true, pointer: true
/// param session: nullable: false
/// param outErrorCode: direction: out, nullable: true, pointer: true
/// param outErrorDescription: direction: out, nullable: true, pointerDepth: 2
#borrow(session, out_error_description)
extern "c" fn fm_language_model_session_get_transcript_json_string(
  session : FMLanguageModelSessionRef,
  out_error_code : UInt,
  out_error_description : Bytes
) -> Bytes = "FMLanguageModelSessionGetTranscriptJSONString"

///|
/// Transcript functions: FMLanguageModelSessionGetTranscriptEntryCount.
/// stability: stable
/// param session: nullable: false
#borrow(session)
extern "c" fn fm_language_model_session_get_transcript_entry_count(
  session : FMLanguageModelSessionRef
) -> Int = "FMLanguageModelSessionGetTranscriptEntryCount"

///|
/// Feedback functions: FMLanguageModelSessionLogFeedbackAttachment.
/// stability: stable
/// returns: ownership: string, nullable: true, pointer: true
/// param session: nullable: false
/// param issuesJSON: nullable: true, const: true, pointer: true
/// param desiredResponseText: nullable: true, const: true, pointer: true
/// param outLength: direction: out, nullable: true, pointer: true
/// param outErrorCode: direction: out, nullable: true, pointer: true
/// param outErrorDescription: direction: out, nullable: true, pointerDepth: 2
#borrow(session, issues_json, desired_response_text, out_error_description)
extern "c" fn fm_language_model_session_log_feedback_attachment(
  session : FMLanguageModelSessionRef,
  sentiment : FMFeedbackSentiment,
  issues_json : Bytes,
  desired_response_text : Bytes,
  out_length : UInt,
  out_error_code : UInt,
  out_error_description : Bytes
) -> Bytes = "FMLanguageModelSessionLogFeedbackAttachment"

///|
/// Feedback functions: FMLanguageModelSessionLogFeedbackAttachmentWithDesiredResponseContent.
/// stability: stable
/// returns: ownership: string, nullable: true, pointer: true
/// param session: nullable: false
/// param issuesJSON: nullable: true, const: true, pointer: true
/// param desiredResponseContentJSON: nullable: true, const: true, pointer: true
/// param outLength: direction: out, nullable: true, pointer: true
/// param outErrorCode: direction: out, nullable: true, pointer: true
/// param outErrorDescription: direction: out, nullable: true, pointerDepth: 2
#borrow(session, issues_json, desired_response_content_json, out_error_description)
extern "c" fn fm_language_model_session_log_feedback_attachment_with_desired_response_content(
  session : FMLanguageModelSessionRef,
  sentiment : FMFeedbackSentiment,
  issues_json : Bytes,
  desired_response_content_json : Bytes,
  out_length : UInt,
  out_error_code : UInt,
  out_error_description : Bytes
) -> Bytes = "FMLanguageModelSessionLogFeedbackAttachmentWithDesiredResponseContent"

///|
/// GenerationSchema functions: FMGenerationSchemaCreate.
/// stability: stable
/// returns: ownership: owned, nullable: false
/// param name: nullable: false, const: true, pointer: true
/// param description: nullable: true, const: true, pointer: true
#borrow(name, description)
extern "c" fn fm_generation_schema_create(
  name : Bytes,
  description : Bytes
) -> FMGenerationSchemaRef = "FMGenerationSchemaCreate"

///|
/// GenerationSchema functions: FMGenerationSchemaPropertyCreate.
/// stability: stable
/// returns: ownership: owned, nullable: false
/// param name: nullable: false, const: true, pointer: true
/// param description: nullable: true, const: true, pointer: true
/// param typeName: nullable: false, const: true, pointer: true
#borrow(name, description, type_name)
extern "c" fn fm_generation_schema_property_create(
  name : Bytes,
  description : Bytes,
  type_name : Bytes,
  is_optional : Bool
) -> FMGenerationSchemaPropertyRef = "FMGenerationSchemaPropertyCreate"

///|
/// GenerationSchema functions: FMGenerationSchemaPropertyAddAnyOfGuide.
/// stability: stable
/// param property: nullable: false
/// param anyOf: nullable: false, const: true, array: true, pointerDepth: 2
#borrow(property, any_of)
extern "c" fn fm_generation_schema_property_add_any_of_guide(
  property : FMGenerationSchemaPropertyRef,
  any_of : Bytes,
  choice_count : Int,
  wrapped : Bool
) = "FMGenerationSchemaPropertyAddAnyOfGuide"

///|
/// GenerationSchema functions: FMGenerationSchemaPropertyAddCountGuide.
/// stability: stable
/// param property: nullable: false
#borrow(property)
extern "c" fn fm_generation_schema_property_add_count_guide(
  property : FMGenerationSchemaPropertyRef,
  count : Int,
  wrapped : Bool
) = "FMGenerationSchemaPropertyAddCountGuide"

///|
/// GenerationSchema functions: FMGenerationSchemaPropertyAddMaximumGuide.
/// stability: stable
/// param property: nullable: false
#borrow(property)
extern "c" fn fm_generation_schema_property_add_maximum_guide(
  property : FMGenerationSchemaPropertyRef,
  maximum : Double,
  wrapped : Bool
) = "FMGenerationSchemaPropertyAddMaximumGuide"

///|
/// GenerationSchema functions: FMGenerationSchemaPropertyAddMinimumGuide.
/// stability: stable
/// param property: nullable: false
#borrow(property)
extern "c" fn fm_generation_schema_property_add_minimum_guide(
  property : FMGenerationSchemaPropertyRef,
  minimum : Double,
  wrapped : Bool
) = "FMGenerationSchemaPropertyAddMinimumGuide"

///|
/// GenerationSchema functions: FMGenerationSchemaPropertyAddMinItemsGuide.
/// stability: stable
/// param property: nullable: false
#borrow(property)
extern "c" fn fm_generation_schema_property_add_min_items_guide(
  property : FMGenerationSchemaPropertyRef,
  min_items : Int
) = "FMGenerationSchemaPropertyAddMinItemsGuide"

///|
/// GenerationSchema functions: FMGenerationSchemaPropertyAddMaxItemsGuide.
/// stability: stable
/// param property: nullable: false
#borrow(property)
extern "c" fn fm_generation_schema_property_add_max_items_guide(
  property : FMGenerationSchemaPropertyRef,
  max_items : Int
) = "FMGenerationSchemaPropertyAddMaxItemsGuide"

///|
/// GenerationSchema functions: FMGenerationSchemaPropertyAddRangeGuide.
/// stability: stable
/// param property: nullable: false
#borrow(property)
extern "c" fn fm_generation_schema_property_add_range_guide(
  property : FMGenerationSchemaPropertyRef,
  min_value : Double,
  max_value : Double,
  wrapped : Bool
) = "FMGenerationSchemaPropertyAddRangeGuide"

///|
/// GenerationSchema functions: FMGenerationSchemaPropertyAddRegex.
/// stability: stable
/// param property: nullable: false
/// param pattern: nullable: false, const: true, pointer: true
#borrow(property, pattern)
extern "c" fn fm_generation_schema_property_add_regex(
  property : FMGenerationSchemaPropertyRef,
  pattern : Bytes,
  wrapped : Bool
) = "FMGenerationSchemaPropertyAddRegex"

///|
/// GenerationSchema functions: FMGenerationSchemaAddProperty.
/// stability: stable
/// param schema: nullable: false
/// param property: nullable: false
#borrow(schema, property)
extern "c" fn fm_generation_schema_add_property(
  schema : FMGenerationSchemaRef,
  property : FMGenerationSchemaPropertyRef
) = "FMGenerationSchemaAddProperty"

///|
/// GenerationSchema functions: FMGenerationSchemaAddReferenceSchema.
/// stability: stable
/// param schema: nullable: false
/// param referenceSchema: nullable: false
#borrow(schema, reference_schema)
extern "c" fn fm_generation_schema_add_reference_schema(
  schema : FMGenerationSchemaRef,
  reference_schema : FMGenerationSchemaRef
) = "FMGenerationSchemaAddReferenceSchema"

///|
/// GenerationSchema functions: FMGenerationSchemaGetJSONString.
/// stability: stable
/// returns: ownership: string, nullable: true, pointer: true
/// param schema: nullable: false
/// param outErrorCode: direction: out, nullable: true, pointer: true
/// param outErrorDescription: direction: out, nullable: true, pointerDepth: 2
#borrow(schema, out_error_description)
extern "c" fn fm_generation_schema_get_json_string(
  schema : FMGenerationSchemaRef,
  out_error_code : UInt,
  out_error_description : Bytes
) -> Bytes = "FMGenerationSchemaGetJSONString"

///|
/// GeneratedContent: FMGeneratedContentCreateFromJSON.
/// stability: stable
/// returns: ownership: owned, nullable: true
/// param jsonString: nullable: false, const: true, pointer: true
/// param outErrorCode: direction: out, nullable: true, pointer: true
/// param outErrorDescription: direction: out, nullable: true, pointerDepth: 2
#borrow(json_string, out_error_description)
extern "c" fn fm_generated_content_create_from_json(
  json_string : Bytes,
  out_error_code : UInt,
  out_error_description : Bytes
) -> FMGeneratedContentRef = "FMGeneratedContentCreateFromJSON"

///|
/// GeneratedContent: FMGeneratedContentGetJSONString.
/// stability: stable
/// returns: ownership: string, nullable: true, pointer: true
/// param content: nullable: false
#borrow(content)
extern "c" fn fm_generated_content_get_json_string(
  content : FMGeneratedContentRef
) -> Bytes = "FMGeneratedContentGetJSONString"

///|
/// GeneratedContent: FMGeneratedContentGetPropertyValue.
/// stability: stable
/// returns: ownership: string, nullable: true, pointer: true
/// param content: nullable: false
/// param propertyName: nullable: false, const: true, pointer: true
/// param outErrorCode: direction: out, nullable: true, pointer: true
/// param outErrorDescription: direction: out, nullable: true, pointerDepth: 2
#borrow(content, property_name, out_error_description)
extern "c" fn fm_generated_content_get_property_value(
  content : FMGeneratedContentRef,
  property_name : Bytes,
  out_error_code : UInt,
  out_error_description : Bytes
) -> Bytes = "FMGeneratedContentGetPropertyValue"

///|
/// GeneratedContent: FMGeneratedContentGetPropertyValueAsDouble.
/// stability: stable
/// param content: nullable: false
/// param propertyName: nullable: false, const: true, pointer: true
/// param outValue: direction: out, nullable: true, pointer: true
/// param outErrorCode: direction: out, nullable: true, pointer: true
#borrow(content, property_name)
extern "c" fn fm_generated_content_get_property_value_as_double(
  content : FMGeneratedContentRef,
  property_name : Bytes,
  out_value : UInt,
  out_error_code : UInt
) -> Bool = "FMGeneratedContentGetPropertyValueAsDouble"

///|
/// GeneratedContent: FMGeneratedContentGetPropertyValueAsBool.
/// stability: stable
/// param content: nullable: false
/// param propertyName: nullable: false, const: true, pointer: true
/// param outValue: direction: out, nullable: true, pointer: true
/// param outErrorCode: direction: out, nullable: true, pointer: true
#borrow(content, property_name)
extern "c" fn fm_generated_content_get_property_value_as_bool(
  content : FMGeneratedContentRef,
  property_name : Bytes,
  out_value : UInt,
  out_error_code : UInt
) -> Bool = "FMGeneratedContentGetPropertyValueAsBool"

///|
/// GeneratedContent: FMGeneratedContentGetPropertyValueAsInt.
/// stability: stable
/// param content: nullable: false
/// param propertyName: nullable: false, const: true, pointer: true
/// param outValue: direction: out, nullable: true, pointer: true
/// param outErrorCode: direction: out, nullable: true, pointer: true
#borrow(content, property_name)
extern "c" fn fm_generated_content_get_property_value_as_int(
  content : FMGeneratedContentRef,
  property_name : Bytes,
  out_value : UInt,
  out_error_code : UInt
) -> Bool = "FMGeneratedContentGetPropertyValueAsInt"

///|
/// GeneratedContent: FMGeneratedContentIsComplete.
/// stability: stable
/// param content: nullable: false
#borrow(content)
extern "c" fn fm_generated_content_is_complete(
  content : FMGeneratedContentRef
) -> Bool = "FMGeneratedContentIsComplete"

///|
/// GeneratedContent: FMGeneratedContentHasProperty.
/// stability: stable
/// param content: nullable: false
/// param propertyName: nullable: false, const: true, pointer: true
#borrow(content, property_name)
extern "c" fn fm_generated_content_has_property(
  content : FMGeneratedContentRef,
  property_name : Bytes
) -> Bool = "FMGeneratedContentHasProperty"

///|
/// GeneratedContent: FMGeneratedContentGetPropertyNames.
/// stability: stable
/// returns: ownership: string, nullable: true, pointer: true
/// param content: nullable: false
#borrow(content)
extern "c" fn fm_generated_content_get_property_names(
  content : FMGeneratedContentRef
) -> Bytes = "FMGeneratedContentGetPropertyNames"

///|
/// Structured generation session functions: FMLanguageModelSessionRespondWithSchema.
/// stability: stable
/// returns: ownership: owned
/// param session: nullable: false
/// param composedPrompt: nullable: false
/// param schema: nullable: false
/// param optionsJSON: nullable: true, const: true, pointer: true
/// param userInfo: nullable: true, pointer: true
#borrow(session, composed_prompt, schema, options_json)
extern "c" fn fm_language_model_session_respond_with_schema(
  session : FMLanguageModelSessionRef,
  composed_prompt : FMComposedPromptRef,
  schema : FMGenerationSchemaRef,
  options_json : Bytes,
  user_info : UInt,
  callback : UInt
) -> FMTaskRef = "FMLanguageModelSessionRespondWithSchema"

///|
/// Structured generation session functions: FMLanguageModelSessionRespondWithSchemaFromJSON.
/// stability: stable
/// returns: ownership: owned
/// param session: nullable: false
/// param composedPrompt: nullable: false
/// param schemaJSONString: nullable: false, const: true, pointer: true
/// param optionsJSON: nullable: true, const: true, pointer: true
/// param userInfo: nullable: true, pointer: true
#borrow(session, composed_prompt, schema_json_string, options_json)
extern "c" fn fm_language_model_session_respond_with_schema_from_json(
  session : FMLanguageModelSessionRef,
  composed_prompt : FMComposedPromptRef,
  schema_json_string : Bytes,
  options_json : Bytes,
  user_info : UInt,
  callback : UInt
) -> FMTaskRef = "FMLanguageModelSessionRespondWithSchemaFromJSON"

///|
/// Tools: FMBridgedToolCreate.
/// stability: stable
/// returns: ownership: owned, nullable: true
/// param name: nullable: false, const: true, pointer: true
/// param description: nullable: false, const: true, pointer: true
/// param parameters: nullable: false
/// param callable: callbackPointer: true, nullable: false
/// param outErrorCode: direction: out, nullable: true, pointer: true
/// param outErrorDescription: direction: out, nullable: true, pointerDepth: 2
#borrow(name, description, parameters, out_error_description)
extern "c" fn fm_bridged_tool_create(
  name : Bytes,
  description : Bytes,
  parameters : FMGenerationSchemaRef,
  callable : UInt,
  out_error_code : UInt,
  out_error_description : Bytes
) -> FMBridgedToolRef = "FMBridgedToolCreate"

///|
/// Tools: FMBridgedToolFinishCall.
/// stability: stable
/// param tool: nullable: false
/// param output: nullable: false, const: true, pointer: true
#borrow(tool, output)
extern "c" fn fm_bridged_tool_finish_call(
  tool : FMBridgedToolRef,
  call_id : UInt,
  output : Bytes
) = "FMBridgedToolFinishCall"

///|
/// Memory management: FMTaskCancel.
/// stability: stable
#borrow(task)
extern "c" fn fm_task_cancel(
  task : FMTaskRef
) = "FMTaskCancel"

///|
/// Memory management: FMRetain.
/// stability: stable
/// param object: nullable: false, const: true, pointer: true
extern "c" fn fm_retain(
  object : UInt
) = "FMRetain"

///|
/// Memory management: FMRelease.
/// stability: stable
/// param object: nullable: false, const: true, pointer: true
extern "c" fn fm_release(
  object : UInt
) = "FMRelease"

///|
/// Memory management: FMFreeString.
/// stability: stable
/// param str: nullable: true, pointer: true
#borrow(str)
extern "c" fn fm_free_string(
  str : Bytes
) = "FMFreeString"
