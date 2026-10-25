import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spritecraft/base/global_providers.dart';
import 'package:spritecraft/core/architecture/domain/app_failure.dart';
import 'package:spritecraft/domain/entities/generated_image_entity.dart';
import 'package:spritecraft/domain/repository/i_generation_repository.dart';
import 'package:spritecraft/domain/repository/i_save_and_share_repository.dart';
import 'package:spritecraft/domain/validation/prompt_validation.dart';
import 'package:spritecraft/presentation/home/state/image_generation_state.dart';

part 'image_generation_controller.g.dart';

@Riverpod(keepAlive: true)
class GeminiGenerationController extends _$GeminiGenerationController {
  late IGenerationRepository _imageGenerationRepository;
  late ISaveAndShareRepository _saveAndShareRepository;

  @override
  ImageGenerationState build() {
    _imageGenerationRepository = ref.watch(imageGenerationRepositoryProvider);
    _saveAndShareRepository = ref.watch(saveAndShareRepositoryProvider);
    return const ImageGenerationInitial();
  }

  void updatePrompt(String? prompt) {
    state = ImageGenerationInitial(prompt: prompt ?? '');
  }

  Future<void> generateImage() async {
    final currentState = state;
    if (currentState is ImageGenerationInProgress ||
        (currentState is ImageGenerationSuccess &&
            currentState.actionState is ImageGenerationActionInProgress)) {
      return;
    }

    final prompt = state.prompt.trim();
    if (!prompt.isValidPrompt) {
      state = ImageGenerationFailure(
        prompt: prompt,
        failure: const ValidationFailure('prompt'),
      );
      return;
    }

    state = ImageGenerationInProgress(prompt: prompt);
    final result = await _imageGenerationRepository.generateImage(prompt);
    state = result.map(
      onSuccess: (image) =>
          ImageGenerationSuccess(prompt: prompt, image: image),
      onFailure: (failure) =>
          ImageGenerationFailure(prompt: prompt, failure: failure),
    );
  }

  Future<void> saveImage() => _performImageAction(
    ImageGenerationAction.save,
    _saveAndShareRepository.saveImage,
  );

  Future<void> shareImage() => _performImageAction(
    ImageGenerationAction.share,
    _saveAndShareRepository.shareImage,
  );

  Future<void> _performImageAction(
    ImageGenerationAction action,
    Future<bool> Function(GeneratedImageEntity image) perform,
  ) async {
    final currentState = state;
    if (currentState is! ImageGenerationSuccess ||
        currentState.actionState is ImageGenerationActionInProgress) {
      return;
    }

    final image = currentState.image;
    state = ImageGenerationSuccess(
      prompt: currentState.prompt,
      image: image,
      actionState: ImageGenerationActionInProgress(action),
    );

    final succeeded = await perform(image);
    final latestState = state;
    if (latestState is! ImageGenerationSuccess ||
        !identical(latestState.image, image) ||
        latestState.actionState is! ImageGenerationActionInProgress) {
      return;
    }

    state = succeeded
        ? ImageGenerationSuccess(
            prompt: currentState.prompt,
            image: currentState.image,
            actionState: ImageGenerationActionSuccess(action),
          )
        : ImageGenerationSuccess(
            prompt: currentState.prompt,
            image: currentState.image,
            actionState: ImageGenerationActionFailure(
              action: action,
              failure: const StorageFailure(),
            ),
          );
  }

  void reset() {
    state = const ImageGenerationInitial();
  }
}
