import 'package:equatable/equatable.dart';
import 'package:icongen/core/architecture/domain/non_empty_string_value_object.dart';
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
      prompt = NonEmptyStringValueObject.invalid();

  final IconGenerationStatus status;
  final GeneratedIconEntity icon;
  final NonEmptyStringValueObject prompt;

  IconGenerationState copyWith({
    IconGenerationStatus? status,
    GeneratedIconEntity? icon,
    NonEmptyStringValueObject? prompt,
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
