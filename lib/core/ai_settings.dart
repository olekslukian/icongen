abstract class AiSettings {
  static const modelName = 'gemini-2.5-flash-image';
  static const temperature = 0.4;
  static const topP = 0.8;
  static const topK = 40;

  static const negativePromptParameters = '''
text, words, letters, numbers, labels, signatures, watermarks, multiple colors,
colors EXCEPT SOLID WHITE AND SOLID BLACK, gradients, shadows,
''';

  static const imageRequirementsPrompt = '''
Flat minimalistic icon, inspired by material design icons, centered,
good for UI design. IMPORTANT: SOLID WHITE BACKGROUND, AND SOLID BLACK COLOR
OF OBJECTS IN THE ICON. NO TEXT, NO LETTERS, NO NUMBERS, NO WATERMARKS.
''';
}
