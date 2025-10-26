import 'package:firebase_ai/firebase_ai.dart';
import 'package:icongen/core/ai_settings.dart';
import 'package:icongen/core/architecture/domain/value_object.dart';

class PromptValueObject extends ValueObject<String> {
  PromptValueObject(super.value);

  PromptValueObject.invalid() : super.invalid();

  String get completePrompt =>
      '''
Generate an image of: "$value", following these requirements: ${AiSettings.imageRequirementsPrompt}.
The generated image MUST strictly avoid: ${AiSettings.negativePromptParameters}.
'''
          .trim();

  Iterable<Content> get completePromptAsContent => [
    Content.text(completePrompt),
  ];

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty || value.length < 3) {
      return null;
    }

    return value;
  }
}
