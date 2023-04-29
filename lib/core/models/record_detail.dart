import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:ikinci_el/core/enums/category_enum.dart';

class RecordDetail {
  String? id;
  String? iid;
  String? uid;
  String? title;
  String? description;
  List<String>? images;
  Categories? category;
  GeoPoint? location;
  int? price;
  Timestamp? dateAdded;

  RecordDetail();

  RecordDetail.fromMap(Map<String, dynamic> doc)
      : id = doc["id"],
        iid = doc["iid"],
        uid = doc["uid"],
        title = doc["title"],
        description = doc["description"],
        images = doc['images'] is Iterable ? List.from(doc['images']) : null,
        category = Categories.values.byName(doc["category"]),
        location = doc["location"] as GeoPoint,
        price = doc["price"],
        dateAdded = doc["dateAdded"] as Timestamp;

  RecordDetail.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        iid = doc.data()!["iid"],
        uid = doc.data()!["uid"],
        title = doc.data()!["title"],
        description = doc.data()!["description"],
        images = doc.data()?['images'] is Iterable
            ? List.from(doc.data()?['images'])
            : null,
        category = Categories.values.byName(doc.data()!["category"]),
        location =
            GeoPoint(doc.data()!["location"][0], doc.data()!["location"][1]),
        price = doc.data()!["price"],
        dateAdded = doc.data()!["dateAdded"] as Timestamp;
}
