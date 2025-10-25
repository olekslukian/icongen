abstract class AiSettings {
  static const geminiModelName = 'gemini-2.5-flash-image';
  static const imagenGenerativeModelName = 'imagen-4.0-generate-001';
  static const imagenEditingModelName = 'imagen-3.0-capability-001';
  static const temperature = 0.4;
  static const topP = 0.8;
  static const topK = 40;

  static const negativePromptParameters = '''
text, labels, words, letters, numbers,
shadows, gradients, glows, 3D effects,
realistic textures, photo-realistic details,
multiple colors, color gradients,
decorations, ornaments, embellishments,
complex details, intricate patterns
''';

  static const iconRequirementsPrompt = '''
Create a MINIMAL FLAT ICON with these STRICT requirements:
- SOLID PURE WHITE background (#FFFFFF) - this is critical
- Icon in SOLID BLACK color only (#000000)
- Extremely simple geometric shapes
- Absolutely NO shadows, gradients, or depth effects
- NO text, labels, or letters of any kind
- Clean, flat 2D design
- Similar style to Material Design icons or Feather icons
- The icon should be centered with white space around it
''';
}
