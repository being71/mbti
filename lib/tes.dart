// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

void testFirestore() async {
  try {
    var snapshot =
        await FirebaseFirestore.instance.collection('questions').get();
    print("Firestore test data: ${snapshot.docs.map((e) => e.data())}");
  } catch (e) {
    print("Firestore connection failed: $e");
  }
}
