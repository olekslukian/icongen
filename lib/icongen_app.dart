import 'package:flutter/material.dart';
import 'package:icongen/presentation/home/home_screen.dart';

class IcongenApp extends StatelessWidget {
  const IcongenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Icongen App',
      theme: ThemeData(
        useMaterial3: true,
        useSystemColors: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomeScreen(),
    );
  }
}
