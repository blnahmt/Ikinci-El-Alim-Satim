import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetail {
  String? id;
  String? uid;
  String? name;
  String? phoneNumber;
  String? photoURL;

  UserDetail();

  UserDetail.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        uid = doc.data()!["uid"],
        name = doc.data()!["name"],
        phoneNumber = doc.data()!["phoneNumber"],
        photoURL = doc.data()!["photoURL"];
}
