import 'dart:io';
import 'package:flutter/material.dart';

class ImageService extends ChangeNotifier {
  File? _frontId;
  File? _backId;
  File? _personAndId;

  File? get frontId => _frontId;
  File? get backId => _backId;
  File? get personAndId => _personAndId;

  void setFrontId(File image) {
    _frontId = image;
    notifyListeners();
  }

  void setBackId(File image) {
    _backId = image;
    notifyListeners();
  }

  void setPersonAndId(File image) {
    _personAndId = image;
    notifyListeners();
  }
}
