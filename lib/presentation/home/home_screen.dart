import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icongen/base/global_providers.dart';
import 'package:icongen/core/icongen_size.dart';
import 'package:icongen/presentation/home/state/icon_generation_state.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(geminiGenerationControllerProvider);
    final generationController = ref.read(
      geminiGenerationControllerProvider.notifier,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('IconGen')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(IcongenSize.l.size),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              focusNode: _focusNode,
              onChanged: generationController.updatePrompt,
              decoration: const InputDecoration(
                labelText: 'Describe your icon',
                hintText: 'e.g., A minimalist coffee cup icon',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: IcongenSize.m.size),
            ElevatedButton(
              onPressed: state.status == IconGenerationStatus.inProgress
                  ? null
                  : () {
                      unawaited(
                        generationController.generateIcon(state.prompt),
                      );
                      _focusNode.unfocus();
                    },
              child: state.status == IconGenerationStatus.inProgress
                  ? const Text('Generating...')
                  : const Text('Generate Icon'),
            ),
            SizedBox(height: IcongenSize.m.size),
            _IconGenerationResult(
              state: state,
              onReset: () {
                generationController.reset();
                _textController.clear();
                _focusNode.requestFocus();
              },
              onTryAgain: () async =>
                  generationController.generateIcon(state.prompt),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconGenerationResult extends StatelessWidget {
  const _IconGenerationResult({
    required this.state,
    required this.onReset,
    required this.onTryAgain,
  });

  final IconGenerationState state;
  final VoidCallback onReset;
  final VoidCallback onTryAgain;

  @override
  Widget build(BuildContext context) {
    return switch (state.status) {
      IconGenerationStatus.initial => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_awesome,
              size: IcongenSize.xl.size,
              color: Colors.grey,
            ),
            SizedBox(height: IcongenSize.m.size),
            const Text('Enter a description to generate an icon'),
          ],
        ),
      ),
      IconGenerationStatus.inProgress => const Center(
        child: CircularProgressIndicator(),
      ),
      IconGenerationStatus.success => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(IcongenSize.m.size),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.memory(
                state.icon.bytes.getOr(Uint8List(0)),
                height: 200,
                width: 200,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Prompt: ${state.prompt.getOr("")}',
              style: const TextStyle(fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onReset,
              child: const Text('Generate Another'),
            ),
          ],
        ),
      ),
      IconGenerationStatus.failure => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            SizedBox(height: IcongenSize.m.size),
            const Text(
              'Failed to generate icon',
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: IcongenSize.m.size),
            ElevatedButton(
              onPressed: onTryAgain,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
      IconGenerationStatus.invalidPrompt => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: IcongenSize.xl.size,
              color: Colors.red,
            ),
            SizedBox(height: IcongenSize.m.size),
            const Text(
              'Prompt should be longer than 3 characters',
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: IcongenSize.m.size),
            ElevatedButton(
              onPressed: onTryAgain,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    };
  }
}
