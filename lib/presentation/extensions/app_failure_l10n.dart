import 'package:spritecraft/core/architecture/domain/app_failure.dart';
import 'package:spritecraft/l10n/generated/app_localizations.dart';

extension AppFailureL10n on AppFailure {
  String localized(
    AppLocalizations l10n, {
    String? storageMessage,
  }) => switch (this) {
    ValidationFailure() => l10n.invalidPromptMessage,
    InvalidResponseFailure() || EmptyResponseFailure() || RemoteFailure() =>
      l10n.failedToGenerateImage,
    StorageFailure() => storageMessage ?? l10n.failedToSaveImage,
  };
}
