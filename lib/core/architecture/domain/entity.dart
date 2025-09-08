import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:icongen/core/architecture/domain/validable.dart';

abstract class Entity extends Equatable implements IValidable {
  const Entity();

  @override
  bool get valid => props.every((element) => element.valid);

  @override
  bool get invalid => !valid;

  @override
  List<IValidable> get props;
}

typedef WhereCallback<T> = bool Function(T element);

abstract class EntityList<T extends Entity> extends Iterable<T>
    with EquatableMixin
    implements IValidable {
  const EntityList(List<T>? entities) : value = entities;

  const EntityList.invalid() : value = null;

  @protected
  final List<T>? value;

  List<T> get entities => value ?? [];

  @override
  bool get valid =>
      value != null &&
      entities.isNotEmpty &&
      entities.every((element) => element.valid);

  @override
  bool get invalid => !valid;

  T operator [](int index) => entities[index];

  void add(T entity) => entities.add(entity);

  void insert(int index, T entity) => entities.insert(index, entity);

  List<T> get whereValid => entities.where((element) => element.valid).toList();

  T? firstWhereOrNull(WhereCallback<T> function) =>
      entities.firstWhereOrNull(function);

  @override
  List<T> get props => entities;

  @override
  Iterator<T> get iterator => entities.iterator;
}
