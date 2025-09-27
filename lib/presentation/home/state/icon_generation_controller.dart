import 'package:flutter_riverpod/legacy.dart';
import 'package:icongen/core/architecture/domain/non_empty_string_value_object.dart';
import 'package:icongen/domain/repository/icon_generation_repository.dart';
import 'package:icongen/presentation/home/state/icon_generation_state.dart';

class IconGenerationController extends StateNotifier<IconGenerationState> {
  IconGenerationController(IconGenerationRepository iconGenerationRepository)
    : _iconGenerationRepository = iconGenerationRepository,
      super(IconGenerationState.initial());

  final IconGenerationRepository _iconGenerationRepository;

  void updatePrompt(String? prompt) {
    state = state.copyWith(
      prompt: NonEmptyStringValueObject(prompt ?? ''),
      status: IconGenerationStatus.initial,
    );
  }

  Future<void> generateIcon(NonEmptyStringValueObject prompt) async {
    if (state.status == IconGenerationStatus.inProgress) {
      return;
    }

    state = state.copyWith(status: IconGenerationStatus.inProgress);

    if (prompt.invalid) {
      state = state.copyWith(status: IconGenerationStatus.invalidPrompt);

      return;
    }

    final icon = await _iconGenerationRepository.generateIcon(prompt);

    if (icon.invalid) {
      state = state.copyWith(status: IconGenerationStatus.failure);

      return;
    }

    state = state.copyWith(status: IconGenerationStatus.success, icon: icon);
  }

  void reset() {
    state = IconGenerationState.initial();
  }
}
