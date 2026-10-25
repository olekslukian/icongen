import 'package:flutter_test/flutter_test.dart';
import 'package:spritecraft/domain/validation/prompt_validation.dart';

void main() {
  group('PromptValidation', () {
    test('rejects prompts with exactly three characters', () {
      expect('abc'.isValidPrompt, isFalse);
    });

    test('accepts prompts longer than three characters', () {
      expect('abcd'.isValidPrompt, isTrue);
    });

    test('trims prompt whitespace before validating', () {
      expect('  abcd  '.isValidPrompt, isTrue);
      expect('   '.isValidPrompt, isFalse);
      expect(null.isValidPrompt, isFalse);
    });
  });
}
