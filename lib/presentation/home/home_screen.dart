import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icongen/base/global_providers.dart';
import 'package:icongen/core/constants/app_constants.dart';
import 'package:icongen/core/theme/app_colors.dart';
import 'package:icongen/presentation/home/state/image_generation_controller.dart';
import 'package:icongen/presentation/home/state/image_generation_state.dart';

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

  Future<void> _onSave(ImageGenerationController controller) async {
    final success = await controller.saveImage();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? 'Image saved to gallery!' : 'Failed to save image.',
        ),
      ),
    );
  }

  Future<void> _onShare(ImageGenerationController controller) async {
    final success = await controller.shareImage();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? 'Image shared!' : 'Failed to share image.'),
      ),
    );
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
                        onSave: () => _onSave(generationController),
                        onShare: () => _onShare(generationController),
                        onReset: () {
                          generationController.reset();
                          _textController.clear();
                          _focusNode.requestFocus();
                        },
                        onTryAgain: () async =>
                            generationController.generateImage(state.prompt),
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
                    onPressed: state.status == ImageGenerationStatus.inProgress
                        ? null
                        : () {
                            unawaited(
                              generationController.generateImage(state.prompt),
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

  final ImageGenerationState state;
  final VoidCallback onReset;
  final VoidCallback onTryAgain;
  final VoidCallback onSave;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    return switch (state.status) {
      ImageGenerationStatus.initial => const Column(
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
      ImageGenerationStatus.inProgress => const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [CircularProgressIndicator()],
      ),
      ImageGenerationStatus.success => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingM),
            child: Image.memory(state.icon.bytes.get, fit: BoxFit.contain),
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
                onPressed: onSave,
                icon: const Icon(Icons.download, size: AppConstants.iconM),
                label: const Text('Save'),
              ),
              ElevatedButton.icon(
                onPressed: onShare,
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
      ImageGenerationStatus.failure => Column(
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
      ImageGenerationStatus.invalidPrompt => Column(
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
