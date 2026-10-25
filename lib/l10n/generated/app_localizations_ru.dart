// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get enterDescriptionToGenerate =>
      'Введите описание для генерации пиксельного изображения';

  @override
  String get failedToSaveImage => 'Не удалось сохранить изображение';

  @override
  String get failedToShareImage => 'Не удалось поделиться изображением';

  @override
  String get failedToGenerateImage => 'Не удалось сгенерировать изображение';

  @override
  String get generateAnother => 'Сгенерировать ещё';

  @override
  String get generateFromText => 'Генерировать из текста';

  @override
  String get imageSavedToGallery => 'Изображение сохранено в галерею';

  @override
  String get imageShared => 'Изображение отправлено';

  @override
  String get invalidPromptMessage => 'Описание должно быть длиннее 3 символов';

  @override
  String get promptFieldHint => 'например, Чашка горячего кофе';

  @override
  String get save => 'Сохранить';

  @override
  String get share => 'Поделиться';

  @override
  String get tryAgain => 'Попробовать снова';
}
