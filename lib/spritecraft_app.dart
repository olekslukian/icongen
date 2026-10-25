import 'package:flutter/material.dart';
import 'package:spritecraft/core/theme/app_theme.dart';
import 'package:spritecraft/l10n/generated/app_localizations.dart';
import 'package:spritecraft/presentation/home/home_screen.dart';

class SpriteCraftApp extends StatelessWidget {
  const SpriteCraftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpriteCraft',
      theme: AppTheme.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: const [
        Locale('en'),
        Locale('uk'),
        Locale('pl'),
        Locale('ru'),
      ],
      home: const HomeScreen(),
    );
  }
}
