import 'package:icongen/data/service/save_and_share_service.dart';
import 'package:icongen/domain/entities/generated_image_entity.dart';
import 'package:icongen/domain/repository/i_save_and_share_repository.dart';
import 'package:icongen/utils/icongen_logger.dart';

class SaveAndShareRepository implements ISaveAndShareRepository {
  SaveAndShareRepository(this._service);

  final SaveAndShareService _service;

  @override
  Future<bool> saveImage(GeneratedImageEntity image) async {
    if (image.invalid) {
      return false;
    }

    final result = await _service.saveImage(image.bytes.get);

    return result.map(
      onSuccess: (_) => true,
      onError: (e) {
        IcongenLogger.error(
          'SaveAndShareRepository.saveImage: Failed to save image',
          error: e,
        );

        return false;
      },
    );
  }

  @override
  Future<bool> shareImage(GeneratedImageEntity image) async {
    if (image.invalid) {
      return false;
    }

    final result = await _service.shareImage(image.bytes.get);

    return result.map(
      onSuccess: (_) => true,
      onError: (e) {
        IcongenLogger.error(
          'SaveAndShareRepository.shareImage: Failed to share image',
          error: e,
        );

        return false;
      },
    );
  }
}
