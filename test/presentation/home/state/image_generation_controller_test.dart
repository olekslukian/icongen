import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spritecraft/base/global_providers.dart';
import 'package:spritecraft/core/architecture/data/result.dart';
import 'package:spritecraft/core/architecture/domain/app_failure.dart';
import 'package:spritecraft/domain/entities/generated_image_entity.dart';
import 'package:spritecraft/domain/repository/i_generation_repository.dart';
import 'package:spritecraft/domain/repository/i_save_and_share_repository.dart';
import 'package:spritecraft/presentation/home/state/image_generation_controller.dart';
import 'package:spritecraft/presentation/home/state/image_generation_state.dart';

void main() {
  group('GeminiGenerationController', () {
    test('transitions from initial to in progress to success', () async {
      final response = Completer<Result<GeneratedImageEntity>>();
      final repository = _FakeGenerationRepository(() => response.future);
      final container = _createContainer(repository);
      addTearDown(container.dispose);

      final controller = container.read(
        geminiGenerationControllerProvider.notifier,
      );
      expect(
        container.read(geminiGenerationControllerProvider),
        isA<ImageGenerationInitial>(),
      );

      controller.updatePrompt('blue sprite');
      final generation = controller.generateImage();
      expect(
        container.read(geminiGenerationControllerProvider),
        isA<ImageGenerationInProgress>(),
      );

      final image = GeneratedImageEntity.fromGeneration(
        id: 'image-1',
        prompt: 'blue sprite',
        data: Uint8List.fromList([1]),
      );
      response.complete(Result.success(image));
      await generation;

      final state = container.read(geminiGenerationControllerProvider);
      expect(state, isA<ImageGenerationSuccess>());
      expect((state as ImageGenerationSuccess).image, image);
    });

    test('transitions to failure when generation fails', () async {
      final container = _createContainer(
        _FakeGenerationRepository(
          () async => const Result.failure(RemoteFailure()),
        ),
      );
      addTearDown(container.dispose);

      final controller = container.read(
        geminiGenerationControllerProvider.notifier,
      );
      await (controller..updatePrompt('blue sprite')).generateImage();

      final state = container.read(geminiGenerationControllerProvider);
      expect(state, isA<ImageGenerationFailure>());
      expect((state as ImageGenerationFailure).failure, isA<RemoteFailure>());
    });

    test('records save success in the state', () async {
      final image = _image();
      final container = _createContainer(
        _FakeGenerationRepository(() async => Result.success(image)),
      );
      addTearDown(container.dispose);

      final controller = container.read(
        geminiGenerationControllerProvider.notifier,
      );
      await (controller..updatePrompt('blue sprite')).generateImage();
      await controller.saveImage();

      final state =
          container.read(geminiGenerationControllerProvider)
              as ImageGenerationSuccess;
      expect(
        state.actionState,
        const ImageGenerationActionSuccess(ImageGenerationAction.save),
      );
    });

    test('records share failure in the state', () async {
      final image = _image();
      final container = _createContainer(
        _FakeGenerationRepository(() async => Result.success(image)),
        saveAndShareRepository: const _FakeSaveAndShareRepository(
          shareResult: false,
        ),
      );
      addTearDown(container.dispose);

      final controller = container.read(
        geminiGenerationControllerProvider.notifier,
      );
      await (controller..updatePrompt('blue sprite')).generateImage();
      await controller.shareImage();

      final state =
          container.read(geminiGenerationControllerProvider)
              as ImageGenerationSuccess;
      expect(
        state.actionState,
        const ImageGenerationActionFailure(
          action: ImageGenerationAction.share,
          failure: StorageFailure(),
        ),
      );
    });
  });
}

GeneratedImageEntity _image() => GeneratedImageEntity.fromGeneration(
  id: 'image-1',
  prompt: 'blue sprite',
  data: Uint8List.fromList([1]),
);

ProviderContainer _createContainer(
  IGenerationRepository generationRepository, {
  ISaveAndShareRepository saveAndShareRepository =
      const _FakeSaveAndShareRepository(),
}) => ProviderContainer(
  overrides: [
    imageGenerationRepositoryProvider.overrideWith(
      (ref) => generationRepository,
    ),
    saveAndShareRepositoryProvider.overrideWith(
      (ref) => saveAndShareRepository,
    ),
  ],
);

class _FakeGenerationRepository implements IGenerationRepository {
  const _FakeGenerationRepository(this.generate);

  final Future<Result<GeneratedImageEntity>> Function() generate;

  @override
  Future<Result<GeneratedImageEntity>> generateImage(String prompt) =>
      generate();
}

class _FakeSaveAndShareRepository implements ISaveAndShareRepository {
  const _FakeSaveAndShareRepository({
    this.shareResult = true,
  });

  final bool shareResult;

  @override
  Future<bool> saveImage(GeneratedImageEntity image) async => true;

  @override
  Future<bool> shareImage(GeneratedImageEntity image) async => shareResult;
}
