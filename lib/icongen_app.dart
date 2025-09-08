import 'package:flutter/material.dart';

class IcongenApp extends StatelessWidget {
  const IcongenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        useSystemColors: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Center(child: Text('Home screen')),
    );
  }
}
