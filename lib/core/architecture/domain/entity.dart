import 'package:equatable/equatable.dart';

abstract class Entity extends Equatable {
  const Entity({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}
