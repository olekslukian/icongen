import 'package:spritecraft/core/architecture/domain/sanitizers.dart';

const kMinPromptLength = 3;

extension PromptValidation on String? {
  bool get isValidPrompt => sanitize().length > kMinPromptLength;
}
