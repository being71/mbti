// ignore_for_file: avoid_print

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

  Future<List<Map<String, dynamic>>> getMBTIQuestions() async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection('mbti_questions').orderBy('order').get();

      print("Successfully fetched ${snapshot.docs.length} questions.");
      for (var doc in snapshot.docs) {
        print("Document ID: ${doc.id}, Data: ${doc.data()}");
      }

      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print("Error fetching questions: $e");
      return [];
    }
  }

  // Fungsi untuk mendapatkan data leaderboard berdasarkan MBTI menggunakan Stream
  Stream<List<MapEntry<String, int>>> getLeaderboard() {
    // Stream data untuk mendengarkan perubahan data pada koleksi 'users'
    return _firestore.collection('users').snapshots().map((snapshot) {
      // mengakses Collection 'users' pada database Firestore
      // Membuat peta untuk menghitung jumlah setiap jenis MBTI
      Map<String, int> mbtiCount = {};

      // Proses setiap dokumen dalam snapshot
      for (var doc in snapshot.docs) {
        // setiap dokumen dalam snapshot menjalankan kode berikut
        final mbti = doc['MBTI']; // ambil data MBTI dari dokumen
        if (mbti != null) {
          // pastikan data MBTI tidak kosong
          mbtiCount[mbti] = (mbtiCount[mbti] ?? 0) +
              1; // cek apakah mbti = null ?? jika ya maka 0 jika tidak maka +1
        }
      }

      // Mengurutkan MBTI berdasarkan jumlahnya
      List<MapEntry<String, int>> sortedMBTI = mbtiCount.entries.toList();
      sortedMBTI.sort((a, b) => b.value.compareTo(a.value));

      return sortedMBTI; // return to map entry
    });
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
