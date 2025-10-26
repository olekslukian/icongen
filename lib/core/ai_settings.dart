abstract class AiSettings {
  static const geminiModelName = 'gemini-2.5-flash-image';
  static const imagenGenerativeModelName = 'imagen-4.0-generate-001';
  static const imagenEditingModelName = 'imagen-3.0-capability-001';
  static const temperature = 0.8;
  static const topP = 0.95;
  static const topK = 40;

  static const negativePromptParameters = '''
text, words, letters, numbers, labels, signatures, watermarks
''';

  static const imageRequirementsPrompt = '''
Create a vibrant, high-quality image.
- The subject should be the main focus.
- The style should be artistic and visually appealing and should fit the subject(e.g., digital painting, fantasy, anime, 3D render, abstract).
- The image should be suitable for a profile picture.
- Ensure the image is well-lit and detailed.
''';
}
