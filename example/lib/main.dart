import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:resize_media/resize_media.dart';
import 'package:resize_media_example/pic.dart';

void main() {
  runApp(const MaterialApp(home: App()));
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resize Media Example')),
      body: Center(
        child: TextButton(
          child: const Text("Resize Asset Picture"),
          onPressed: () async {
            var byteData = await rootBundle.load('assets/image.jpg');

            File fileAsset =
                File('${(await getTemporaryDirectory()).path}/image.jpg');

            File fileImage = await fileAsset.writeAsBytes(byteData.buffer
                .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

            int originalSize = fileImage.lengthSync();

            if (fileImage.existsSync()) {
              var result = await ResizeMedia().image(
                path: fileImage.path,
                imageQuality: 1,
                maxWidth: 1920,
                maxHeight: 1920,
              );

              int resizedSize = File(result!).lengthSync();

              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Pic(
                  result,
                  originalSize: originalSize,
                  resizedSize: resizedSize,
                );
              }));
            }
          },
        ),
      ),
    );
  }
}
