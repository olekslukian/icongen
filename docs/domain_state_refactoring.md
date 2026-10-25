# Domain & State Refactoring — SpriteCraft

Goal: remove over-engineering from the domain layer, keep entities always valid and non-nullable, and replace flag-based state with sealed hierarchies.

## Decisions

| Topic | Decision |
|---|---|
| Error handling | Hybrid. The repository parses untrusted data with exceptions, catches them, and exposes only `Result<T>`. Controllers and UI never see exceptions. |
| `Result<T>` | Truly sealed: `Success(data)` / `Failure(failure)`, consumed with Dart 3 `switch`. The `_data != null` check is removed, so `Result<void>` works. |
| Failures | Sealed `AppFailure` hierarchy, mapped to l10n strings in the UI. |
| Prompt validation | Domain validator returns `Result<String>` and accepts only prompts longer than 3 characters. The controller emits `ImageGenerationFailure(ValidationFailure)`. |
| Prompt ownership | Lives in the sealed state and is updated via `updatePrompt`. |
| Entity | `GeneratedImageEntity` has `id`, `prompt` and `bytes`. It is always valid. |
| Background removal | Removed (`image_background_remover` and ONNX init); no replacement background instruction is added to the generation prompt. |
| Save/share | Repositories return `bool`; the controller stores action success/failure in generation state, and the UI listens to that state to show localized snackbars. |

## Golden rules

1. An entity instance is always valid: no `invalid()` factories, no dummy values, no nullable payloads.
2. Validate at the boundary (repository/service) before an entity is constructed.
3. A missing **mandatory** field from the backend is an error (`InvalidResponseFailure`). A missing **optional** field is sanitized to an empty or default value and is not an error.
4. The domain is pure Dart: no Flutter, no Firebase types.
5. Repositories and services return `Result<T>` and never throw. Exceptions exist only inside the data layer, between the parser and the repository's `catch`.
6. Don't use value-object wrappers with a nullable `value`, `EntityList`, or extension-type collections until a second entity needs them (YAGNI).

## Target structure

```
lib/core/architecture/
  domain/entity.dart            # Entity base (id, Equatable)
  domain/app_failure.dart       # sealed AppFailure
  domain/sanitizers.dart        # EntityValidationException + String? extensions
  data/result.dart              # sealed Result<T>
lib/domain/entities/generated_image_entity.dart
lib/domain/validation/prompt_validation.dart
```

## Core code

### `entity.dart`

```dart
@immutable
abstract class Entity extends Equatable {
  const Entity({required this.id});
  final String id;

  @override
  List<Object?> get props => [id];
}
```

Delete `EntityList` and `WhereCallback`. They are unused and mutate a copied list.

### `app_failure.dart`

```dart
sealed class AppFailure implements Exception {
  const AppFailure([this.message]);
  final String? message; // for logs only, never shown to the user
}

final class ValidationFailure extends AppFailure {      // bad user input
  const ValidationFailure(this.field, [super.message]);
  final String field;
}
final class InvalidResponseFailure extends AppFailure { // backend data missing mandatory fields
  const InvalidResponseFailure([super.message]);
}
final class EmptyResponseFailure extends AppFailure {   // the model returned no image
  const EmptyResponseFailure();
}
final class RemoteFailure extends AppFailure {          // network / AI call failed
  const RemoteFailure([super.message]);
}
final class StorageFailure extends AppFailure {         // save / share failed
  const StorageFailure([super.message]);
}
```

### `result.dart`

```dart
sealed class Result<T> {
  const Result();
  const factory Result.success(T data) = Success<T>;
  const factory Result.failure(AppFailure failure) = Failure<T>;

  R map<R>({
    required R Function(T data) onSuccess,
    required R Function(AppFailure failure) onFailure,
  }) => switch (this) {
    Success(:final data) => onSuccess(data),
    Failure(:final failure) => onFailure(failure),
  };
}

final class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;
}

final class Failure<T> extends Result<T> {
  const Failure(this.failure);
  final AppFailure failure;
}
```

### `sanitizers.dart`

```dart
class EntityValidationException implements Exception {
  const EntityValidationException(this.message);
  final String message;
}

extension StringSanitizer on String? {
  // Optional field: null, blank or 'null' become the fallback (no error).
  String sanitize({String fallback = ''}) {
    final v = this?.trim();
    return (v == null || v.isEmpty || v.toLowerCase() == 'null') ? fallback : v;
  }

  // Mandatory field: throws EntityValidationException.
  String requireValid(String field) {
    final v = sanitize();
    if (v.isEmpty) throw EntityValidationException('"$field" is required');
    return v;
  }
}
```

### `generated_image_entity.dart`

```dart
final class GeneratedImageEntity extends Entity {
  const GeneratedImageEntity._({
    required super.id,
    required this.prompt,
    required this.bytes,
  });

  /// Throws [EntityValidationException]; call only inside a repository try/catch.
  factory GeneratedImageEntity.fromGeneration({
    required String? id,
    required String? prompt,
    required Uint8List? data,
  }) {
    if (data == null || data.isEmpty) {
      throw const EntityValidationException('"bytes" cannot be empty');
    }
    return GeneratedImageEntity._(
      id: id.requireValid('id'),
      prompt: prompt.requireValid('prompt'),
      bytes: data,
    );
  }

  final String prompt;
  final Uint8List bytes;

  // Compare by id: it is unique, and comparing the whole image on every state change is O(n).
  @override
  List<Object?> get props => [id, prompt];
}
```

Business logic (e.g. `fileName`, `byteSize`) goes here as getters when needed.

### `prompt_validation.dart`

```dart
const kMinPromptLength = 3; // keep in sync with l10n `invalidPromptMessage`

extension PromptValidation on String? {
  Result<String> validatePrompt() {
    final value = sanitize();
    return value.length <= kMinPromptLength
        ? const Result.failure(ValidationFailure('prompt'))
        : Result.success(value);
  }
}
```

The current ARB text says "longer than 3 characters"; the rule is `> 3`.

### Repository (data/service flow)

```dart
abstract interface class IGenerationRepository {
  Future<Result<GeneratedImageEntity>> generateImage(String prompt);
}

@override
Future<Result<GeneratedImageEntity>> generateImage(String prompt) async {
  final response = await _service.generateImage([Content.text(prompt)]);

  return switch (response) {
    Failure(:final failure) => _logged(failure),
    Success(:final data) => _toEntity(prompt, data),
  };
}

Result<GeneratedImageEntity> _toEntity(String prompt, InlineDataPart part) {
  try {
    return Result.success(GeneratedImageEntity.fromGeneration(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      prompt: prompt,
      data: part.bytes,
    ));
  } on EntityValidationException catch (e) {
    return _logged(InvalidResponseFailure(e.message));
  }
}
```

Service changes:

- `response.inlineDataParts.isEmpty` returns `Failure(EmptyResponseFailure())`.
- The `catch` block returns `Failure(RemoteFailure('$e'))`.

Log failures with `SpriteCraftLogger.error(..., error: failure)` inside `_logged`.

Save/share:

```dart
abstract interface class ISaveAndShareRepository {
  Future<bool> saveImage(GeneratedImageEntity image);
  Future<bool> shareImage(GeneratedImageEntity image);
}
```

- Drop the `image.invalid` check, since the entity is always valid.
- `SaveAndShareService` returns `Result<void>` and `Failure(StorageFailure('$e'))`.
- The repository consumes that result, logs failures, and returns `true` for success or `false` for failure.
- Use `image.bytes` (the `.get` accessor is gone).

## State

```dart
sealed class ImageGenerationState extends Equatable {
  const ImageGenerationState({required this.prompt});
  final String prompt;
  @override
  List<Object?> get props => [prompt];
}

final class ImageGenerationInitial extends ImageGenerationState {
  const ImageGenerationInitial({super.prompt = ''});
}
final class ImageGenerationInProgress extends ImageGenerationState {
  const ImageGenerationInProgress({required super.prompt});
}
final class ImageGenerationSuccess extends ImageGenerationState {
  const ImageGenerationSuccess({required super.prompt, required this.image});
  final GeneratedImageEntity image;
  @override
  List<Object?> get props => [prompt, image];
}
final class ImageGenerationFailure extends ImageGenerationState {
  const ImageGenerationFailure({required super.prompt, required this.failure});
  final AppFailure failure;
  @override
  List<Object?> get props => [prompt, failure];
}
```

`invalidPrompt` is no longer a state. It is `ImageGenerationFailure(failure: ValidationFailure('prompt'))`.

### Controller

```dart
@override
ImageGenerationState build() {
  _generation = ref.watch(imageGenerationRepositoryProvider);
  _saveAndShare = ref.watch(saveAndShareRepositoryProvider);
  return const ImageGenerationInitial();
}

void updatePrompt(String? prompt) =>
    state = ImageGenerationInitial(prompt: prompt ?? '');

Future<void> generateImage() async {
  if (state is ImageGenerationInProgress) return;

  final prompt = state.prompt;
  switch (prompt.validatePrompt()) {
    case Failure(:final failure):
      state = ImageGenerationFailure(prompt: prompt, failure: failure);
    case Success(data: final valid):
      state = ImageGenerationInProgress(prompt: valid);
      final result = await _generation.generateImage(valid);
      state = result.map(
        onSuccess: (image) => ImageGenerationSuccess(prompt: valid, image: image),
        onFailure: (f) => ImageGenerationFailure(prompt: valid, failure: f),
      );
  }
}

// The image comes from the Success branch in the UI, so no null or invalid case exists.
Future<void> saveImage() =>
    _performImageAction(ImageGenerationAction.save, _saveAndShare.saveImage);
Future<void> shareImage() =>
    _performImageAction(ImageGenerationAction.share, _saveAndShare.shareImage);

void reset() => state = const ImageGenerationInitial();
```

The controller depends on `IGenerationRepository` and `ISaveAndShareRepository` through interface providers; the application root overrides those providers with the concrete repository implementations.

### UI

- `HomeScreen`: replace `switch (state.status)` with an exhaustive `switch (state)`, and use `ImageGenerationSuccess(:final image)` for `Image.memory(image.bytes)`.
- The send button is disabled when `state is ImageGenerationInProgress`.
- Presentation extension, with no hardcoded text:

```dart
extension AppFailureL10n on AppFailure {
  String localized(AppLocalizations l10n) => switch (this) {
    ValidationFailure() => l10n.invalidPromptMessage,
    InvalidResponseFailure() || EmptyResponseFailure() || RemoteFailure() => l10n.failedToGenerateImage,
    StorageFailure() => l10n.failedToSaveImage, // refine per action: save vs share
  };
}
```

- Listen to generation state action outcomes and show localized save/share snackbars; presentation does not handle `Result`.
- If distinct texts are needed (e.g. network vs empty response), add keys to all four ARB files (`en`, `uk`, `pl`, `ru`) and run `flutter gen-l10n`.

## `AsyncValue` guidance (future features)

- Simple read-only or CRUD screens use `AsyncValue<T>` and map `Result` to it: `Success` → `AsyncValue.data`, `Failure` → `AsyncValue.error(failure, StackTrace.current)`.
- Multi-field screens that carry user input, like this one, use a sealed state hierarchy.
- Image generation stays sealed because it carries the prompt across all states.

## Migration checklist

1. **Core**
   - [x] Rewrite `result.dart` as truly sealed.
   - [x] Add `app_failure.dart` and `sanitizers.dart`.
   - [x] Update `entity.dart` (const constructor with `id`) and delete `EntityList`.
2. **Domain**
   - [x] Rewrite `GeneratedImageEntity` (private constructor, validating `fromGeneration` factory).
   - [x] Add `prompt_validation.dart`.
   - [x] Change `IGenerationRepository` and `ISaveAndShareRepository` signatures.
3. **Data**
   - [x] Update `ImageGenerationService` to return `Result<InlineDataPart>` with typed failures.
   - [x] Update `SaveAndShareService` to return `Result<void>`.
   - [x] Update both repositories (map exceptions to failures and log).
4. **Remove background removal**
   - [x] Delete `_removeBackground` and the `image_background_remover` import.
   - [x] Delete `BackgroundRemover.instance.initializeOrt()` and its import from `lib/main.dart`.
   - [x] Remove `image_background_remover` from `pubspec.yaml`, then run `flutter pub get`.
   - [x] Remove it from the web-unavailable plugin list in `AGENTS.md`.
   - [x] Remove the leftover ONNX Runtime plugin registration (`flutter_onnxruntime` appears in `macos/Flutter/GeneratedPluginRegistrant.swift`) by regenerating.
   - [x] Document that generated backgrounds may remain opaque; no generation prompt instructions were changed.
5. **State**
   - [x] Replace `image_generation_state.dart` with the sealed hierarchy.
   - [x] Rewrite `GeminiGenerationController` (remove the missing `prompt_value_object.dart` import).
   - [x] Run `dart run build_runner build -d` to regenerate `.g.dart`.
6. **UI**
   - [x] Update `HomeScreen` to an exhaustive `switch`, the `image` payload, and `Result`-based save/share.
   - [x] Add the failure-to-l10n extension; no new ARB keys were required.
7. **Verify**
   - [x] Run `flutter analyze`.
   - [x] Add unit tests for `validatePrompt`, the entity factory (empty bytes, blank id), and the controller transitions (initial → in progress → success/failure).
   - [x] Run `flutter test`.

## Confirmed behavior

- Prompts must have more than 3 characters; a prompt of exactly 3 characters is invalid.
- Background removal is dropped without adding or changing any generation prompt instructions. Generated backgrounds may remain opaque.
