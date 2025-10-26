import 'package:equatable/equatable.dart';
import 'package:icongen/core/architecture/domain/prompt_value_object.dart';
import 'package:icongen/domain/entities/generated_image_entity.dart';

enum ImageGenerationStatus {
  initial,
  inProgress,
  success,
  failure,
  invalidPrompt,
}

class ImageGenerationState extends Equatable {
  const ImageGenerationState._({
    required this.status,
    required this.icon,
    required this.prompt,
  });

  ImageGenerationState.initial()
    : status = ImageGenerationStatus.initial,
      icon = GeneratedImageEntity.invalid(),
      prompt = PromptValueObject.invalid();

  final ImageGenerationStatus status;
  final GeneratedImageEntity icon;
  final PromptValueObject prompt;

  ImageGenerationState copyWith({
    ImageGenerationStatus? status,
    GeneratedImageEntity? icon,
    PromptValueObject? prompt,
  }) {
    return ImageGenerationState._(
      status: status ?? this.status,
      icon: icon ?? this.icon,
      prompt: prompt ?? this.prompt,
    );
  }

  @override
  List<Object?> get props => [status, icon, prompt];
}
