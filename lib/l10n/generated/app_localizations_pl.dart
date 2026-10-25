// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get enterDescriptionToGenerate =>
      'Wprowadź opis, aby wygenerować pikselową grafikę';

  @override
  String get failedToSaveImage => 'Nie udało się zapisać obrazu';

  @override
  String get failedToShareImage => 'Nie udało się udostępnić obrazu';

  @override
  String get failedToGenerateImage => 'Nie udało się wygenerować obrazu';

  @override
  String get generateAnother => 'Generuj kolejny';

  @override
  String get generateFromText => 'Generuj z tekstu';

  @override
  String get imageSavedToGallery => 'Obraz zapisany do galerii';

  @override
  String get imageShared => 'Obraz udostępniony';

  @override
  String get invalidPromptMessage => 'Opis powinien mieć więcej niż 3 znaki';

  @override
  String get promptFieldHint => 'np. Filiżanka gorącej kawy';

  @override
  String get save => 'Zapisz';

  @override
  String get share => 'Udostępnij';

  @override
  String get tryAgain => 'Spróbuj ponownie';
}
