// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get enterDescriptionToGenerate =>
      'Додайте опис щоб згенерувати зображення';

  @override
  String get failedToSaveImage => 'Не вдалося зберегти зображення';

  @override
  String get failedToShareImage => 'Не вдалося поділитися зображенням';

  @override
  String get failedToGenerateImage => 'Не вдалося згенерувати зображення';

  @override
  String get generateAnother => 'Згенерувати інше';

  @override
  String get generateFromText => 'Генерувати з тексту';

  @override
  String get imageSavedToGallery => 'Зображення збережено до Галереї';

  @override
  String get imageShared => 'Зображення відправлено';

  @override
  String get invalidPromptMessage => 'Промпт мусить бути більше 3х символів';

  @override
  String get promptFieldHint => 'Наприклад, чашка гарячої кави';

  @override
  String get save => 'Зберегти';

  @override
  String get share => 'Поділитися';

  @override
  String get tryAgain => 'Спробувати ще раз';
}
