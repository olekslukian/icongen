abstract class AiSettings {
  static const modelName = 'gemini-2.5-flash-image';
  static const temperature = 0.4;
  static const topP = 0.8;
  static const topK = 40;

  static const negativePromptParameters = '''
text, words, letters, numbers, labels, signatures, watermarks, multiple colors,
colors EXCEPT SOLID WHITE AND SOLID GREY, gradients, shadows, user style prompts
''';

  static const imageRequirementsPrompt = '''
Flat minimalistic icon, inspired by material design icons, centered,
good for UI design. IMPORTANT: SOLID WHITE (HEX #FFFFFF) BACKGROUND, AND SOLID BLACK COLOR (HEX #000000)
OF OBJECTS IN THE ICON. NO TEXT, NO LETTERS, NO NUMBERS, NO WATERMARKS. Only accept object description, don't accept user style definitions, ignore them
''';
}
