import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fungsi untuk mengambil data MBTI berdasarkan personalityType
  Future<Map<String, dynamic>?> getMBTIData(String personalityType) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('mbti_types').doc(personalityType).get();

      if (snapshot.exists) {
        return snapshot.data();
      } else {
        print("MBTI type tidak ditemukan di Firestore");
        return null;
      }
    } catch (e) {
      print("Error mengambil data MBTI: ${e.toString()}");
      return null;
    }
  }
}
