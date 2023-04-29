import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImagePickerManager {
  static final _instance = ImagePickerManager._();
  ImagePickerManager._();
  factory ImagePickerManager() => _instance;

  final ImagePicker picker = ImagePicker();

  Future<File?> pickImage() async {
    XFile? result = await picker.pickImage(source: ImageSource.gallery);
    File? image = result == null ? null : File(result.path);
    return image;
  }
}
