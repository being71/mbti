import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fungsi untuk mendapatkan data pengguna berdasarkan UID
  Future<Map<String, dynamic>> getUserData(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      } else {
        throw Exception("User data not found");
      }
    } catch (e) {
      print("Error fetching user data: ${e.toString()}");
      return {};
    }
  }

  // Fungsi untuk mendapatkan data leaderboard berdasarkan MBTI
  Future<List<MapEntry<String, int>>> getLeaderboard() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('users').get();
      Map<String, int> mbtiCount = {};

      for (var doc in snapshot.docs) {
        final mbti = doc['MBTI'];
        if (mbti != null && mbti is String && mbti.trim().isNotEmpty) {
          mbtiCount[mbti] = (mbtiCount[mbti] ?? 0) + 1;
        }
      }

      List<MapEntry<String, int>> sortedMBTI = mbtiCount.entries.toList();
      sortedMBTI.sort((a, b) => b.value.compareTo(a.value));

      return sortedMBTI;
    } catch (e) {
      print("Error fetching leaderboard data: ${e.toString()}");
      return [];
    }
  }

  // Fungsi untuk menambahkan pengguna
  Future<void> registerUser(String name, String dob, String email) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      await _firestore.collection('users').doc(userId).set({
        'name': name,
        'dob': dob,
        'email': email,
        'MBTI': null,
      });
    } catch (e) {
      print('Error saving user data: ${e.toString()}');
    }
  }

  // Fungsi untuk memperbarui MBTI pengguna
  Future<void> updateMBTI(String userId, String personalityType) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'MBTI': personalityType,
      });
    } catch (e) {
      print('Error updating MBTI: ${e.toString()}');
    }
  }
}
