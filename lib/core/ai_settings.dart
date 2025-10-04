abstract class AiSettings {
  static const geminiModelName = 'gemini-2.5-flash-image';
  static const imagenModelName = 'imagen-4.0-generate-001';
  static const temperature = 0.4;
  static const topP = 0.8;
  static const topK = 40;

  static const negativePromptParameters = '''
any text,shadows,gradients,3D effects,realistic textures,
      multiple colors,decorations, any background, any non-transparent background, any background color
      ''';
  static const iconRequirementsPrompt = '''
    minimal flat icon,
    single solid black color,
    **fully transparent background, no color on background**,
    absolutely no text or labels,
    no shadows or gradients,
    clean vector style,
    material design inspired,
    simple geometric shapes,
    no decorative elements,
  ''';
}
