import 'package:icongen/domain/entities/generated_image_entity.dart';

abstract interface class ISaveAndShareRepository {
  Future<bool> saveImage(GeneratedImageEntity image);
  Future<bool> shareImage(GeneratedImageEntity image);
}
