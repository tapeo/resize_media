
# resize_media

Resize media to a given size

## Features

* Pictures resize (currently only iOS)

## To do

* Pictures resize Andorid side
* Video resize

## Install

In the `pubspec.yaml` of your flutter project, add the following dependency:

```yaml
dependencies:
  resize_media: <latest_version>
```

In your library add the following import:

```dart
import 'package:resize_media/resize_media.dart';
```

## Getting started

Example:

```dart
ResizeMedia().image(
                path: fileImage.path,
                imageQuality: 1,
                maxWidth: 1920,
                maxHeight: 1920,
              );
```

## Parameters

Leave empty `imageQuality`,`maxWidth`,`maxHeight` to get the original image