import 'package:equatable/equatable.dart';
import 'package:icongen/core/architecture/domain/prompt_value_object.dart';
import 'package:icongen/domain/entities/generated_icon_entity.dart';

enum IconGenerationStatus {
  initial,
  inProgress,
  success,
  failure,
  invalidPrompt,
}

class IconGenerationState extends Equatable {
  const IconGenerationState._({
    required this.status,
    required this.icon,
    required this.prompt,
  });

  IconGenerationState.initial()
    : status = IconGenerationStatus.initial,
      icon = GeneratedIconEntity.invalid(),
      prompt = PromptValueObject.invalid();

  final IconGenerationStatus status;
  final GeneratedIconEntity icon;
  final PromptValueObject prompt;

  IconGenerationState copyWith({
    IconGenerationStatus? status,
    GeneratedIconEntity? icon,
    PromptValueObject? prompt,
  }) {
    return IconGenerationState._(
      status: status ?? this.status,
      icon: icon ?? this.icon,
      prompt: prompt ?? this.prompt,
    );
  }

  @override
  List<Object?> get props => [status, icon, prompt];
}
