import 'dart:io';

import 'package:flutter/material.dart';

class Pic extends StatelessWidget {
  final String path;
  const Pic(this.path, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image'),
      ),
      body: Image.file(File(path)),
    );
  }
}
