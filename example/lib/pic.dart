import 'dart:io';

import 'package:flutter/material.dart';

class Pic extends StatelessWidget {
  final String path;
  final int originalSize;
  final int resizedSize;

  const Pic(this.path,
      {Key? key, required this.originalSize, required this.resizedSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resized Image'),
      ),
      body: Column(
        children: [
          Image.file(File(path)),
          const SizedBox(height: 16),
          Text('Original size: ${originalSize / 1000} KB'),
          const SizedBox(height: 16),
          Text('Resized size: ${resizedSize / 1000} KB'),
        ],
      ),
    );
  }
}
