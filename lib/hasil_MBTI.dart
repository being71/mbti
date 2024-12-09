// ignore_for_file: file_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';

// Function to parse the ARGB string into a Color object
Color parseColor(String colorString) {
  // Example: ARGB(255, 194, 231, 215)
  final match =
      RegExp(r'ARGB\((\d+), (\d+), (\d+), (\d+)\)').firstMatch(colorString);
  if (match != null) {
    final a = int.parse(match.group(1)!);
    final r = int.parse(match.group(2)!);
    final g = int.parse(match.group(3)!);
    final b = int.parse(match.group(4)!);
    return Color.fromARGB(a, r, g, b);
  }
  return Colors.white; // Return a default color if parsing fails
}

class HasilMBTI extends StatelessWidget {
  final String personalityType;

  const HasilMBTI(this.personalityType);

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

  @override
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchhasil_mbti(personalityType),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return Scaffold(
            body: Center(
              child: Text("Error atau data tidak ditemukan."),
            ),
          );
        }

        // Ambil data dari snapshot
        final data = snapshot.data!;
        final title = data['title'] ?? 'Tidak Dikenal';
        final imagePath = data['image'] ?? 'assets/default.jpg';
        final mbtiType = data['mbtiType'] ?? 'Tidak Dikenal';
        final description = data['description'] ?? 'Deskripsi tidak tersedia';
        final similarity = data['similarity'] ?? '0.0%';
        final colorString = data['color'] ?? 'ARGB(255, 255, 255, 255)';
        final color = parseColor(colorString);

        return Scaffold(
          backgroundColor: color,
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
                      updateMBTI(personalityType);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                      );
                    },
                    child: const Text("OK"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
