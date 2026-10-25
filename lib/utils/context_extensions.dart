import 'package:flutter/material.dart';
import 'package:spritecraft/l10n/generated/app_localizations.dart';

extension BuildContextExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
