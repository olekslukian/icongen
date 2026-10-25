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
          IGenerationRepository,
          IGenerationRepository,
          IGenerationRepository
        >
    with $Provider<IGenerationRepository> {
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
  $ProviderElement<IGenerationRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  IGenerationRepository create(Ref ref) {
    return imageGenerationRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IGenerationRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IGenerationRepository>(value),
    );
  }
}

String _$imageGenerationRepositoryHash() =>
    r'b9aee0f681c0ee3edd95e98e859197d787c1b7fd';

@ProviderFor(saveAndShareRepository)
final saveAndShareRepositoryProvider = SaveAndShareRepositoryProvider._();

final class SaveAndShareRepositoryProvider
    extends
        $FunctionalProvider<
          ISaveAndShareRepository,
          ISaveAndShareRepository,
          ISaveAndShareRepository
        >
    with $Provider<ISaveAndShareRepository> {
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
  $ProviderElement<ISaveAndShareRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ISaveAndShareRepository create(Ref ref) {
    return saveAndShareRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ISaveAndShareRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ISaveAndShareRepository>(value),
    );
  }
}

String _$saveAndShareRepositoryHash() =>
    r'a3020d32f13d877080d9866e5d4c8009e080a7e7';
