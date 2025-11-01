import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icongen/base/global_providers.dart';
import 'package:icongen/core/constants/app_constants.dart';
import 'package:icongen/core/theme/app_colors.dart';
import 'package:icongen/l10n/generated/app_localizations.dart';
import 'package:icongen/presentation/home/state/image_generation_controller.dart';
import 'package:icongen/presentation/home/state/image_generation_state.dart';
import 'package:icongen/utils/context_extensions.dart';

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

  Future<void> _onSave({
    required ImageGenerationController controller,
    required AppLocalizations l10n,
  }) async {
    final success = await controller.saveImage();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? l10n.imageSavedToGallery : l10n.failedToSaveImage,
        ),
      ),
    );
  }

  Future<void> _onShare({
    required ImageGenerationController controller,
    required AppLocalizations l10n,
  }) async {
    final success = await controller.shareImage();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? l10n.imageShared : l10n.failedToShareImage),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(geminiGenerationControllerProvider);
    final generationController = ref.read(
      geminiGenerationControllerProvider.notifier,
    );
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.generateFromText)),
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
                        onSave: () => _onSave(
                          controller: generationController,
                          l10n: l10n,
                        ),
                        onShare: () => _onShare(
                          controller: generationController,
                          l10n: l10n,
                        ),
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
                  hintText: l10n.promptFieldHint,
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
    final l10n = context.l10n;

    return switch (state.status) {
      ImageGenerationStatus.initial => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.auto_awesome,
            size: AppConstants.iconXl,
            color: Colors.grey,
          ),
          const SizedBox(height: AppConstants.spacingM),
          Text(l10n.enterDescriptionToGenerate),
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
            state.prompt.getOr(''),
            style: const TextStyle(fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.spacingL),
          Wrap(
            spacing: AppConstants.spacingM,
            runSpacing: AppConstants.spacingS,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: onSave,
                icon: const Icon(Icons.download, size: AppConstants.iconM),
                label: Text(l10n.save),
              ),
              ElevatedButton.icon(
                onPressed: onShare,
                icon: const Icon(Icons.share, size: AppConstants.iconM),
                label: Text(l10n.share),
              ),
              ElevatedButton(
                onPressed: onReset,
                child: Text(l10n.generateAnother),
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
          Text(
            l10n.failedToGenerateImage,
            style: const TextStyle(color: AppColors.error),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.spacingM),

          ElevatedButton(onPressed: onReset, child: Text(l10n.generateAnother)),
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
          Text(
            l10n.invalidPromptMessage,
            style: const TextStyle(color: AppColors.error),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.spacingM),
          ElevatedButton(onPressed: onTryAgain, child: Text(l10n.tryAgain)),
        ],
      ),
    };
  }
}
