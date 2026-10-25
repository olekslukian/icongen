import 'package:equatable/equatable.dart';
import 'package:spritecraft/core/architecture/domain/app_failure.dart';
import 'package:spritecraft/domain/entities/generated_image_entity.dart';

sealed class ImageGenerationState extends Equatable {
  const ImageGenerationState({required this.prompt});

  final String prompt;

  @override
  List<Object?> get props => [prompt];
}

enum ImageGenerationAction { save, share }

sealed class ImageGenerationActionState extends Equatable {
  const ImageGenerationActionState();

  @override
  List<Object?> get props => [];
}

final class ImageGenerationActionIdle extends ImageGenerationActionState {
  const ImageGenerationActionIdle();
}

final class ImageGenerationActionInProgress extends ImageGenerationActionState {
  const ImageGenerationActionInProgress(this.action);

  final ImageGenerationAction action;

  @override
  List<Object?> get props => [action];
}

final class ImageGenerationActionSuccess extends ImageGenerationActionState {
  const ImageGenerationActionSuccess(this.action);

  final ImageGenerationAction action;

  @override
  List<Object?> get props => [action];
}

final class ImageGenerationActionFailure extends ImageGenerationActionState {
  const ImageGenerationActionFailure({
    required this.action,
    required this.failure,
  });

  final ImageGenerationAction action;
  final AppFailure failure;

  @override
  List<Object?> get props => [action, failure];
}

final class ImageGenerationInitial extends ImageGenerationState {
  const ImageGenerationInitial({super.prompt = ''});
}

final class ImageGenerationInProgress extends ImageGenerationState {
  const ImageGenerationInProgress({required super.prompt});
}

final class ImageGenerationSuccess extends ImageGenerationState {
  const ImageGenerationSuccess({
    required super.prompt,
    required this.image,
    this.actionState = const ImageGenerationActionIdle(),
  });

  final GeneratedImageEntity image;
  final ImageGenerationActionState actionState;

  @override
  List<Object?> get props => [prompt, image, actionState];
}

final class ImageGenerationFailure extends ImageGenerationState {
  const ImageGenerationFailure({
    required super.prompt,
    required this.failure,
  });

  final AppFailure failure;

  @override
  List<Object?> get props => [prompt, failure];
}
