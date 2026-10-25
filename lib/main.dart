import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_background_remover/image_background_remover.dart';
import 'package:spritecraft/firebase_options.dart';
import 'package:spritecraft/spritecraft_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await BackgroundRemover.instance.initializeOrt();

  runApp(const ProviderScope(child: SpriteCraftApp()));
}
