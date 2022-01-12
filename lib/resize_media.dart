import 'dart:async';

import 'package:flutter/services.dart';

class ResizeMedia {
  static const MethodChannel _channel = MethodChannel('resize_media');

  /// Resize a media file to a given size.
  /// [path] is the path to the media file.
  /// [maxWidth] is the max width of the new image, [null] for no resize.
  /// [maxHeight] is the max height of the new image, [null] for no resize.
  /// [quality] is the quality of the new image from 0.0 to 1.0, [null] for original.
  Future<String?> image({
    required String path,
    double? maxWidth,
    double? maxHeight,
    double? imageQuality,
  }) async {
    return _channel.invokeMethod<String>(
      'image',
      <String, dynamic>{
        'path': path,
        'maxWidth': maxWidth,
        'maxHeight': maxHeight,
        'imageQuality': imageQuality,
      },
    );
  }
}
