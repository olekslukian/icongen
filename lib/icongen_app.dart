import 'package:flutter/material.dart';
import 'package:icongen/core/theme/app_theme.dart';
import 'package:icongen/l10n/generated/app_localizations.dart';
import 'package:icongen/presentation/home/home_screen.dart';

class IcongenApp extends StatelessWidget {
  const IcongenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Icongen',
      theme: AppTheme.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: const [Locale('en'), Locale('uk')],
      home: const HomeScreen(),
    );
  }
}
