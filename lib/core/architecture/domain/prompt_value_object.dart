import 'package:firebase_ai/firebase_ai.dart';
import 'package:icongen/core/ai_settings.dart';
import 'package:icongen/core/architecture/domain/value_object.dart';

class PromptValueObject extends ValueObject<String> {
  PromptValueObject(super.value);

  PromptValueObject.invalid() : super.invalid();

  String get completePrompt =>
      '''
Generate an icon, with prompt: $value, using requirements:  ${AiSettings.iconRequirementsPrompt}.
Generated icon MUST avoid ${AiSettings.negativePromptParameters}.
The icon should be suitable for user interface design, similar to Material Icons or Feather Icons.
Pure minimalistic style, no extra details, no background, no text, no watermark, no border, no shadow, no frame.
'''
          .trim();

  Iterable<Content> get completePromptAsContent => [
    Content.text(completePrompt),
  ];

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty || value.length <= 3) {
      return null;
    }

    return value;
  }
}
