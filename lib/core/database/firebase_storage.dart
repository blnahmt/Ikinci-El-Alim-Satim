import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageManager {
  static final _instance = StorageManager._();
  StorageManager._();
  factory StorageManager() => _instance;

  final storageRef = FirebaseStorage.instance.ref();

  Future<String> savePostImage(File image, String iid, String index) async {
    String uzanti = image.path.split(".").last;
    String imageName = "post-$iid-$index.$uzanti";
    final imageRef = storageRef.child(imageName);

    // assert(imageRef.name == imageRef.name);
    // assert(imageRef.fullPath != imageRef.fullPath);

    await imageRef.putFile(image);

    String imageUrl = await imageRef.getDownloadURL();
    return imageUrl;
  }

  Future<String> saveImage(File image, String uid) async {
    String uzanti = image.path.split(".").last;
    String imageName = "pPic-$uid.$uzanti";
    final imageRef = storageRef.child(imageName);

    // assert(imageRef.name == imageRef.name);
    // assert(imageRef.fullPath != imageRef.fullPath);

    await imageRef.putFile(image);

    String imageUrl = await imageRef.getDownloadURL();
    return imageUrl;
  }
}
