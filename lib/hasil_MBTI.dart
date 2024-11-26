import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mbti/home_screen.dart';
import 'firestore.dart'; // Pastikan untuk menambahkan import FirestoreService

class HasilMBTI extends StatelessWidget {
  final String personalityType;

  // Konstruktor untuk menerima tipe kepribadian
  const HasilMBTI(this.personalityType);

  // Fungsi untuk memperbarui MBTI di Firestore
  Future<void> updateMBTI(String personalityType) async {
    try {
      // Dapatkan UID pengguna yang sedang login
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Panggil FirestoreService untuk memperbarui data MBTI
      FirestoreService firestoreService = FirestoreService();
      await firestoreService.updateMBTI(userId, personalityType);

      print("MBTI berhasil diperbarui ke Firestore");
    } catch (e) {
      print("Error saat memperbarui MBTI: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    String title = '';
    String imagePath = '';
    String description = '';
    String similarity = '';
    String mbtiType = '';

    // Tentukan hasil berdasarkan personalityType
    if (personalityType == 'ENFJ') {
      title = 'Protagonis';
      imagePath = 'assets/ENFJ.png';
      mbtiType = 'ENFJ';
      description =
          'Pemimpin yang karismatik dan inspiratif, dan mampu memukau pendengarnya.';
      similarity = '2.5 %';
    } else if (personalityType == 'ENFP') {
      title = 'Pencipta';
      imagePath = 'assets/ENFP.png';
      mbtiType = 'ENFP';
      description =
          'Penuh energi, imajinatif, dan kreatif. Mereka senang mengeksplorasi kemungkinan-kemungkinan baru.';
      similarity = '8.1 %';
    } else {
      title = 'Tidak Dikenal';
      imagePath =
          'assets/default.jpg'; // Ganti dengan gambar default jika tipe tidak dikenali
      mbtiType = personalityType;
      description = 'Kepribadian yang belum terdefinisi dengan jelas.';
      similarity = '0.1 %';
    }

    return Scaffold(
      backgroundColor: const Color(0xFFDAEBE3),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Tipe Kepribadian Kamu adalah',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Image.asset(
                imagePath,
                height: 150,
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                mbtiType,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              const Text(
                'Kamu Memiliki Kepribadian yang sama dengan',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                similarity,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
              const Text(
                'Populasi di dunia',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Panggil updateMBTI untuk memperbarui data MBTI pengguna
                  updateMBTI(personalityType);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const HomeScreen()), // Ganti dengan login.dart
                  ); // Kembali ke halaman sebelumnya
                },
                child: const Text("OK"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
