import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spritecraft/core/constants/app_constants.dart';
import 'package:spritecraft/core/theme/app_colors.dart';
import 'package:spritecraft/presentation/extensions/app_failure_l10n.dart';
import 'package:spritecraft/presentation/home/state/image_generation_controller.dart';
import 'package:spritecraft/presentation/home/state/image_generation_state.dart';
import 'package:spritecraft/utils/context_extensions.dart';

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
    final l10n = context.l10n;

    ref.listen(geminiGenerationControllerProvider, (previous, next) {
      if (!mounted || next is! ImageGenerationSuccess) {
        return;
      }

      final message = switch (next.actionState) {
        ImageGenerationActionSuccess(:final action) =>
          action == ImageGenerationAction.save
              ? l10n.imageSavedToGallery
              : l10n.imageShared,
        ImageGenerationActionFailure(:final action, :final failure) =>
          failure.localized(
            l10n,
            storageMessage: action == ImageGenerationAction.save
                ? l10n.failedToSaveImage
                : l10n.failedToShareImage,
          ),
        _ => null,
      };
      if (message != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(l10n.generateFromText)),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  padding: const EdgeInsets.all(AppConstants.spacingM),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight:
                          constraints.maxHeight - (AppConstants.spacingM * 2),
                    ),
                    child: _IconGenerationResult(
                      state: state,
                      onSave: () => unawaited(generationController.saveImage()),
                      onShare: () =>
                          unawaited(generationController.shareImage()),
                      onReset: () {
                        generationController.reset();
                        _textController.clear();
                        _focusNode.requestFocus();
                      },
                      onTryAgain: () =>
                          unawaited(generationController.generateImage()),
                    ),
                  ),
                ),
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
                    onPressed: state is ImageGenerationInProgress
                        ? null
                        : () {
                            unawaited(generationController.generateImage());
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

    return switch (state) {
      ImageGenerationInitial() => Column(
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
      ImageGenerationInProgress() => const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [CircularProgressIndicator()],
      ),
      ImageGenerationSuccess(
        :final image,
        :final prompt,
        :final actionState,
      ) =>
        Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingM),
            child: Image.memory(image.bytes, fit: BoxFit.contain),
          ),
          const SizedBox(height: AppConstants.spacingL),
          Text(
            prompt,
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
                onPressed: actionState is ImageGenerationActionInProgress
                    ? null
                    : onSave,
                icon: const Icon(Icons.download, size: AppConstants.iconM),
                label: Text(l10n.save),
              ),
              ElevatedButton.icon(
                onPressed: actionState is ImageGenerationActionInProgress
                    ? null
                    : onShare,
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
      ImageGenerationFailure(:final failure) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: AppConstants.iconXl,
            color: AppColors.error,
          ),
          const SizedBox(height: AppConstants.spacingM),
          Text(
            failure.localized(l10n),
            style: const TextStyle(color: AppColors.error),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.spacingM),
          ElevatedButton(
            onPressed: onTryAgain,
            child: Text(l10n.tryAgain),
          ),
        ],
      ),
    };
  }
}
