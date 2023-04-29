// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ikinci_el/core/database/firestore.dart';
import 'package:ikinci_el/core/models/record_detail.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore.instance;
  // Firestore'daki bir koleksiyonu test edin
  test('test collection', () async {
    // Verileri oku
    List<RecordDetail> snapshot = await FirestoreManager().getAllRecords(0);

    // Okunan verileri doğrula
    expect(snapshot.length, 1);
  });
}
