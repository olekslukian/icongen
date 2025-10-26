import 'package:flutter_riverpod/legacy.dart';
import 'package:icongen/core/architecture/domain/prompt_value_object.dart';
import 'package:icongen/domain/repository/i_genration_repository.dart';
import 'package:icongen/domain/repository/save_and_share_repository.dart';
import 'package:icongen/presentation/home/state/image_generation_state.dart';

class ImageGenerationController extends StateNotifier<ImageGenerationState> {
  ImageGenerationController({
    required IGenerationRepository imageGenerationRepository,
    required SaveAndShareRepository saveAndShareRepository,
  }) : _imageGenerationRepository = imageGenerationRepository,
       _saveAndShareRepository = saveAndShareRepository,
       super(ImageGenerationState.initial());

  final IGenerationRepository _imageGenerationRepository;
  final SaveAndShareRepository _saveAndShareRepository;

  void updatePrompt(String? prompt) {
    state = state.copyWith(
      prompt: PromptValueObject(prompt ?? ''),
      status: ImageGenerationStatus.initial,
    );
  }

  Future<void> generateImage(PromptValueObject prompt) async {
    if (state.status == ImageGenerationStatus.inProgress) {
      return;
    }

    state = state.copyWith(status: ImageGenerationStatus.inProgress);

    if (prompt.invalid) {
      state = state.copyWith(status: ImageGenerationStatus.invalidPrompt);

      return;
    }

    final image = await _imageGenerationRepository.generateImage(prompt);

    if (image.invalid) {
      state = state.copyWith(status: ImageGenerationStatus.failure);

      return;
    }

    state = state.copyWith(status: ImageGenerationStatus.success, icon: image);
  }

  Future<bool> saveImage() async =>
      _saveAndShareRepository.saveImage(state.icon);

  Future<bool> shareImage() async =>
      _saveAndShareRepository.shareImage(state.icon);

  void reset() {
    state = ImageGenerationState.initial();
  }
}
