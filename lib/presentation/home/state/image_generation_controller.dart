import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spritecraft/base/global_providers.dart';
import 'package:spritecraft/core/architecture/domain/prompt_value_object.dart';
import 'package:spritecraft/domain/repository/i_generation_repository.dart';
import 'package:spritecraft/domain/repository/save_and_share_repository.dart';
import 'package:spritecraft/presentation/home/state/image_generation_state.dart';

part 'image_generation_controller.g.dart';

@Riverpod(keepAlive: true)
class GeminiGenerationController extends _$GeminiGenerationController {
  late IGenerationRepository _imageGenerationRepository;
  late SaveAndShareRepository _saveAndShareRepository;

  @override
  ImageGenerationState build() {
    _imageGenerationRepository = ref.watch(imageGenerationRepositoryProvider);
    _saveAndShareRepository = ref.watch(saveAndShareRepositoryProvider);
    return ImageGenerationState.initial();
  }

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
