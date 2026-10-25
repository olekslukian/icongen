// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_generation_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GeminiGenerationController)
final geminiGenerationControllerProvider =
    GeminiGenerationControllerProvider._();

final class GeminiGenerationControllerProvider
    extends
        $NotifierProvider<GeminiGenerationController, ImageGenerationState> {
  GeminiGenerationControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'geminiGenerationControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$geminiGenerationControllerHash();

  @$internal
  @override
  GeminiGenerationController create() => GeminiGenerationController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ImageGenerationState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ImageGenerationState>(value),
    );
  }
}

String _$geminiGenerationControllerHash() =>
    r'ab320c2a3035478be215fba994d397bd75c90170';

abstract class _$GeminiGenerationController
    extends $Notifier<ImageGenerationState> {
  ImageGenerationState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ImageGenerationState, ImageGenerationState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ImageGenerationState, ImageGenerationState>,
              ImageGenerationState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
