// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get enterDescriptionToGenerate =>
      'Enter a description to generate an icon';

  @override
  String get failedToSaveImage => 'Failed to save image';

  @override
  String get failedToShareImage => 'Failed to share image';

  @override
  String get failedToGenerateImage => 'Failed to generate image';

  @override
  String get generateAnother => 'Generate another';

  @override
  String get generateFromText => 'Generate from text';

  @override
  String get imageSavedToGallery => 'Image saved to gallery';

  @override
  String get imageShared => 'Image shared';

  @override
  String get invalidPromptMessage =>
      'Prompt should be longer than 3 characters';

  @override
  String get promptFieldHint => 'e.g., A coffee cup';

  @override
  String get save => 'Save';

  @override
  String get share => 'Share';

  @override
  String get tryAgain => 'Try again';
}
