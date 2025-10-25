import 'package:flutter/material.dart';
import 'package:icongen/core/theme/app_theme.dart';
import 'package:icongen/presentation/home/home_screen.dart';

class IcongenApp extends StatelessWidget {
  const IcongenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Icongen App',
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}
