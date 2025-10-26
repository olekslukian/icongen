import 'dart:io';
import 'dart:typed_data';

import 'package:gal/gal.dart';
import 'package:icongen/core/architecture/data/result.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class SaveAndShareService {
  const SaveAndShareService();

  Future<Result<bool>> saveImage(Uint8List imageBytes) async {
    final fileName = 'icon_${DateTime.now().millisecondsSinceEpoch}.png';

    try {
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(imageBytes);

      await Gal.putImage(file.path);

      await file.delete();

      return Result.success(true);
    } catch (e) {
      return Result.failure(Exception('Error saving image: $e'));
    }
  }

  Future<Result<bool>> shareImage(Uint8List imageBytes) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final fileName = 'icon_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(imageBytes);

      await SharePlus.instance.share(ShareParams(files: [XFile(file.path)]));
      await file.delete();

      return Result.success(true);
    } catch (e) {
      return Result.failure(Exception('Error sharing image: $e'));
    }
  }
}
