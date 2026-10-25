// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'global_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(aiModel)
final aiModelProvider = AiModelProvider._();

final class AiModelProvider
    extends
        $FunctionalProvider<GenerativeModel, GenerativeModel, GenerativeModel>
    with $Provider<GenerativeModel> {
  AiModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiModelProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiModelHash();

  @$internal
  @override
  $ProviderElement<GenerativeModel> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GenerativeModel create(Ref ref) {
    return aiModel(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GenerativeModel value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GenerativeModel>(value),
    );
  }
}

String _$aiModelHash() => r'f5e05fbce83f4a875d6ecb5fbba59556c89ebb9f';

@ProviderFor(imageGenerationService)
final imageGenerationServiceProvider = ImageGenerationServiceProvider._();

final class ImageGenerationServiceProvider
    extends
        $FunctionalProvider<
          ImageGenerationService,
          ImageGenerationService,
          ImageGenerationService
        >
    with $Provider<ImageGenerationService> {
  ImageGenerationServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'imageGenerationServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$imageGenerationServiceHash();

  @$internal
  @override
  $ProviderElement<ImageGenerationService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ImageGenerationService create(Ref ref) {
    return imageGenerationService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ImageGenerationService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ImageGenerationService>(value),
    );
  }
}

String _$imageGenerationServiceHash() =>
    r'db68e3b05ae0d6ed78a7b5643ed5649996d89264';

@ProviderFor(saveAndShareService)
final saveAndShareServiceProvider = SaveAndShareServiceProvider._();

final class SaveAndShareServiceProvider
    extends
        $FunctionalProvider<
          SaveAndShareService,
          SaveAndShareService,
          SaveAndShareService
        >
    with $Provider<SaveAndShareService> {
  SaveAndShareServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'saveAndShareServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$saveAndShareServiceHash();

  @$internal
  @override
  $ProviderElement<SaveAndShareService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SaveAndShareService create(Ref ref) {
    return saveAndShareService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SaveAndShareService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SaveAndShareService>(value),
    );
  }
}

String _$saveAndShareServiceHash() =>
    r'c1976c75e5d68f2b1eee6d67c579d079a2893335';

@ProviderFor(imageGenerationRepository)
final imageGenerationRepositoryProvider = ImageGenerationRepositoryProvider._();

final class ImageGenerationRepositoryProvider
    extends
        $FunctionalProvider<
          ImageGenerationRepository,
          ImageGenerationRepository,
          ImageGenerationRepository
        >
    with $Provider<ImageGenerationRepository> {
  ImageGenerationRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'imageGenerationRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$imageGenerationRepositoryHash();

  @$internal
  @override
  $ProviderElement<ImageGenerationRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ImageGenerationRepository create(Ref ref) {
    return imageGenerationRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ImageGenerationRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ImageGenerationRepository>(value),
    );
  }
}

String _$imageGenerationRepositoryHash() =>
    r'e3f9b5b040dd1aff304f95587b174ea56e176eb5';

@ProviderFor(saveAndShareRepository)
final saveAndShareRepositoryProvider = SaveAndShareRepositoryProvider._();

final class SaveAndShareRepositoryProvider
    extends
        $FunctionalProvider<
          SaveAndShareRepository,
          SaveAndShareRepository,
          SaveAndShareRepository
        >
    with $Provider<SaveAndShareRepository> {
  SaveAndShareRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'saveAndShareRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$saveAndShareRepositoryHash();

  @$internal
  @override
  $ProviderElement<SaveAndShareRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SaveAndShareRepository create(Ref ref) {
    return saveAndShareRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SaveAndShareRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SaveAndShareRepository>(value),
    );
  }
}

String _$saveAndShareRepositoryHash() =>
    r'071f1ace3c77eea56d0104c8129c4361bcce74d4';
