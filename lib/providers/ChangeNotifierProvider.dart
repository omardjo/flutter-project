import 'dart:io';
import 'package:flutter/foundation.dart';

class ImageProvider extends ChangeNotifier {
  File? _image;

  File? get image => _image;

  void setImage(File? image) {
    _image = image;
    notifyListeners();
  }
}
