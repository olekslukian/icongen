import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gal/gal.dart';
import 'package:icongen/base/global_providers.dart';
import 'package:icongen/core/constants/app_constants.dart';
import 'package:icongen/core/theme/app_colors.dart';
import 'package:icongen/presentation/home/state/icon_generation_state.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

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

  Future<void> _saveImage(Uint8List imageBytes) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final fileName = 'icon_${DateTime.now().millisecondsSinceEpoch}.png';

    try {
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(imageBytes);

      await Gal.putImage(file.path);

      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Image saved to gallery!')),
      );

      await file.delete();
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Error saving image: $e')),
      );
    }
  }

  Future<void> _shareImage(Uint8List imageBytes, String prompt) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final fileName = 'icon_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(imageBytes);

      await SharePlus.instance.share(ShareParams(files: [XFile(file.path)]));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error sharing image: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(geminiGenerationControllerProvider);
    final generationController = ref.read(
      geminiGenerationControllerProvider.notifier,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Generate from text')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(AppConstants.spacingM),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight:
                            constraints.maxHeight - (AppConstants.spacingM * 2),
                      ),
                      child: _IconGenerationResult(
                        state: state,
                        onSave: _saveImage,
                        onShare: _shareImage,
                        onReset: () {
                          generationController.reset();
                          _textController.clear();
                          _focusNode.requestFocus();
                        },
                        onTryAgain: () async =>
                            generationController.generateIcon(state.prompt),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingM,
                vertical: AppConstants.spacingXl,
              ),
              child: TextField(
                controller: _textController,
                focusNode: _focusNode,
                onChanged: generationController.updatePrompt,
                decoration: InputDecoration(
                  hintText: 'e.g., A minimalist coffee cup icon',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: state.status == IconGenerationStatus.inProgress
                        ? null
                        : () {
                            unawaited(
                              generationController.generateIcon(state.prompt),
                            );
                            _focusNode.unfocus();
                          },
                  ),
                ),
              ),
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
    required this.onSave,
    required this.onShare,
  });

  final IconGenerationState state;
  final VoidCallback onReset;
  final VoidCallback onTryAgain;
  final void Function(Uint8List) onSave;
  final void Function(Uint8List, String) onShare;

  @override
  Widget build(BuildContext context) {
    return switch (state.status) {
      IconGenerationStatus.initial => const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_awesome,
            size: AppConstants.iconXl,
            color: Colors.grey,
          ),
          SizedBox(height: AppConstants.spacingM),
          Text('Enter a description to generate an icon'),
        ],
      ),
      IconGenerationStatus.inProgress => const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [CircularProgressIndicator()],
      ),
      IconGenerationStatus.success => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingM),
            child: Image.memory(
              state.icon.bytes.getOr(Uint8List(0)),
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: AppConstants.spacingL),
          Text(
            'Prompt: ${state.prompt.getOr("")}',
            style: const TextStyle(fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
          Wrap(
            spacing: AppConstants.spacingM,
            runSpacing: AppConstants.spacingS,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  final bytes = state.icon.bytes.getOrNull;
                  if (bytes != null) {
                    onSave(bytes);
                  }
                },
                icon: const Icon(Icons.download, size: AppConstants.iconM),
                label: const Text('Save'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  final bytes = state.icon.bytes.getOrNull;
                  final prompt = state.prompt.getOr('');
                  if (bytes != null) {
                    onShare(bytes, prompt);
                  }
                },
                icon: const Icon(Icons.share, size: AppConstants.iconM),
                label: const Text('Share'),
              ),
              ElevatedButton(
                onPressed: onReset,
                child: const Text('Generate Another'),
              ),
            ],
          ),
        ],
      ),
      IconGenerationStatus.failure => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: AppConstants.iconXl,
            color: AppColors.error,
          ),
          const SizedBox(height: AppConstants.spacingM),
          const Text(
            'Failed to generate icon',
            style: TextStyle(color: AppColors.error),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.spacingM),

          ElevatedButton(
            onPressed: onReset,
            child: const Text('Generate Another'),
          ),
        ],
      ),
      IconGenerationStatus.invalidPrompt => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: AppConstants.iconXl,
            color: AppColors.error,
          ),
          const SizedBox(height: AppConstants.spacingM),
          const Text(
            'Prompt should be longer than 3 characters',
            style: TextStyle(color: AppColors.error),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.spacingM),
          ElevatedButton(onPressed: onTryAgain, child: const Text('Try Again')),
        ],
      ),
    };
  }
}
