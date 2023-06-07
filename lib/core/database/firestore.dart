import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ikinci_el/core/enums/category_enum.dart';
import 'package:ikinci_el/core/enums/collections_enum.dart';
import 'package:ikinci_el/core/enums/sort_types_enum.dart';
import 'package:ikinci_el/core/models/record_detail.dart';
import 'package:ikinci_el/core/models/user_detail.dart';

import '../cache/cache_manager.dart';

class FirestoreManager {
  static final _instance = FirestoreManager._();
  FirestoreManager._();
  factory FirestoreManager() => _instance;

  var firestore = FirebaseFirestore.instance;

  Future<void> createNewUserDoc(UserDetail user) async {
    await firestore.collection(Collections.users.label).doc("${user.uid}").set({
      "uid": user.uid,
      "name": user.name,
      "phoneNumber": user.phoneNumber,
      "photoURL": user.photoURL,
    });
  }

  Future<void> updateUserDoc(
    UserDetail user,
  ) async {
    await firestore.collection(Collections.users.label).doc("${user.uid}").set({
      "uid": user.uid,
      "name": user.name,
      "phoneNumber": user.phoneNumber,
      "photoURL": user.photoURL,
    });
  }

  Future<UserDetail> getUserDetail(String uid) async {
    DocumentSnapshot<Map<String, dynamic>> request =
        await firestore.collection(Collections.users.label).doc(uid).get();
    UserDetail temp = UserDetail.fromDocumentSnapshot(request);

    return temp;
  }

  Future<List<RecordDetail>> getAllRecords(int category) async {
    String sort = CacheManager()
        .getString(PrefTagsString.recordSort, SortTypes.dateAdded.name);

    String order = CacheManager().getString(PrefTagsString.recordOrder, "DESC");
    QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
        .collection(Collections.records.label)
        .where("category", isEqualTo: Categories.values[category].name)
        .orderBy(sort, descending: order == "DESC")
        .get();
    final records = snapshot.docs
        .map((docSnapshot) => RecordDetail.fromDocumentSnapshot(docSnapshot))
        .toList();
    return records;
  }

  Future<List<RecordDetail>> getUserRecords(String uid) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
        .collection(Collections.records.label)
        .where("uid", isEqualTo: uid)
        .orderBy("dateAdded", descending: true)
        .get();
    final records = snapshot.docs
        .map((docSnapshot) => RecordDetail.fromDocumentSnapshot(docSnapshot))
        .toList();
    return records;
  }

  Future<void> createNewRecord(RecordDetail record) async {
    await firestore
        .collection(Collections.records.label)
        .doc("${record.iid}")
        .set({
      "iid": record.iid,
      "uid": record.uid,
      "title": record.title,
      "description": record.description,
      "images": record.images,
      "category": record.category?.name,
      "location": [record.location?.latitude, record.location?.longitude],
      "price": record.price,
      "dateAdded": record.dateAdded,
    });
  }

  Future<void> updateRecord(RecordDetail record) async {
    await firestore
        .collection(Collections.records.label)
        .doc("${record.iid}")
        .set({
      "title": record.title,
      "description": record.description,
      "category": record.category?.name,
      "location": [record.location?.latitude, record.location?.longitude],
      "price": record.price,
      "dateAdded": record.dateAdded,
      "images": record.images,
      "uid": record.uid,
    });
  }

  Future<void> deleteRecord(String iid) async {
    await firestore.collection(Collections.records.label).doc(iid).delete();
  }
}
