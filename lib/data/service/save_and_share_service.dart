import 'dart:io';
import 'dart:typed_data';

import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:spritecraft/core/architecture/data/result.dart';
import 'package:spritecraft/core/architecture/domain/app_failure.dart';

class SaveAndShareService {
  const SaveAndShareService();

  Future<Result<void>> saveImage(Uint8List imageBytes) async {
    final fileName = 'icon_${DateTime.now().millisecondsSinceEpoch}.png';

    try {
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(imageBytes);

      await Gal.putImage(file.path);

      await file.delete();

      return const Result.success(null);
    } catch (e) {
      return Result.failure(StorageFailure('Error saving image: $e'));
    }
  }

  Future<Result<void>> shareImage(Uint8List imageBytes) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final fileName = 'icon_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(imageBytes);

      await SharePlus.instance.share(ShareParams(files: [XFile(file.path)]));
      await file.delete();

      return const Result.success(null);
    } catch (e) {
      return Result.failure(StorageFailure('Error sharing image: $e'));
    }
  }
}
