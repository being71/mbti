// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Fungsi login pengguna menggunakan email dan password
  Future<User?> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Login gagal, coba lagi.');
    }
  }

// Fungsi untuk mengecek apakah data pengguna ada di Firestore
  Future<bool> isUserExists(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(userId).get();
      return userDoc.exists;
    } catch (e) {
      throw Exception("Gagal memeriksa data pengguna: $e");
    }
  }

  Future<Map<String, dynamic>> getAnalysisData(String mbtiType) async {
    try {
      DocumentSnapshot doc =
          await firestore.collection('hasil_mbti').doc(mbtiType).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      } else {
        throw Exception('Dokumen tidak ditemukan');
      }
    } catch (e) {
      throw Exception('Gagal mengambil data: $e');
    }
  }

  // Fungsi untuk mendapatkan data pengguna berdasarkan UID
  Future<Map<String, dynamic>> getUserData(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(userId).get();
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
          await firestore.collection('mbti_questions').orderBy('order').get();

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
    return firestore.collection('users').snapshots().map((snapshot) {
      // mengakses Collection 'users' pada database Firestore
      // Membuat peta untuk menghitung jumlah setiap jenis MBTI
      Map<String, int> mbtiCount = {};

      // Proses setiap dokumen dalam snapshot
      for (var doc in snapshot.docs) {
        // setiap dokumen dalam snapshot menjalankan kode berikut
        final mbti = doc['mbtiType']; // ambil data MBTI dari dokumen
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
      await firestore.collection('users').doc(userId).set({
        'name': name,
        'dob': dob,
        'email': email,
        'mbtiType': null,
      });
    } catch (e) {
      print('Error saving user data: ${e.toString()}');
    }
  }

  // Fungsi untuk memperbarui MBTI di Firestore
  Future<void> updateMBTI(String personalityType) async {
    try {
      // Dapatkan UID pengguna yang sedang login
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Update data MBTI di Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'mbtiType': personalityType});

      print("MBTI berhasil diperbarui ke Firestore");
    } catch (e) {
      print("Error saat memperbarui MBTI: ${e.toString()}");
    }
  }

  // Fungsi untuk mengambil data MBTI dari Firestore
  Future<Map<String, dynamic>> fetchhasil_mbti(String personalityType) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('hasil_mbti')
          .doc(personalityType)
          .get();

      return snapshot.data() ?? {};
    } catch (e) {
      print("Error saat mengambil data MBTI: ${e.toString()}");
      return {};
    }
  }
}
