import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';

Future<String> tobase64(File image) async {
  List<int> imgBytes = await image.readAsBytes();
  String base64img = base64Encode(imgBytes);
  return base64img;
}

//this method returns an image widget from a base63 string, it also prevents the image blinking while scrolling by precaching it
Future<Image> decodedImage(String base64, BuildContext context) async {
  final _image = Base64Decoder().convert(base64);
  final image = Image.memory(
    _image,
    fit: BoxFit.contain,
  );
  await precacheImage(image.image, context);
  return image;
}

//this method returns an ImageProvider from a base63 string
ImageProvider decodedImageProvider(String base64) {
  final _image = Base64Decoder().convert(base64);
  return MemoryImage(_image);
}
