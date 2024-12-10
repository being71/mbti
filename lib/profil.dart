// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';
import 'questionscreen.dart';
import 'login.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get(),
      builder: (context, snapshot) {
        // Tampilkan indikator loading saat data sedang diambil
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Tampilkan pesan error jika terjadi kesalahan saat mengambil data
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text('Terjadi kesalahan. Silakan coba lagi!')),
          );
        }

        final userData = snapshot.data;

// Periksa apakah MBTI tersedia
        final String mbti =
            userData?['MBTI'] ?? ""; // Berikan nilai default kosong jika null
        final String name = userData?['name'] ??
            'User'; // Berikan nilai default 'User' jika null

        if (mbti.isEmpty) {
          // Jika MBTI belum tersedia, tampilkan Profil_Notfound
          return Profil_Notfound(name: name);
        } else {
          // Jika MBTI tersedia, tampilkan hasil MBTI
          return Profil_HasilMBTI(name: name, mbti: mbti);
        }
      },
    );
  }
}

// Tampilan untuk profil jika MBTI belum ada
class Profil_Notfound extends StatelessWidget {
  final String name;

  const Profil_Notfound({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: Colors.purple[100],
              padding: const EdgeInsets.only(
                  top: 50, bottom: 10, left: 20, right: 20),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // Align text and icon
                children: [
                  Text(
                    'Hai, $name!',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.black),
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                        // ignore: use_build_context_synchronously
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Image.asset(
              'assets/head.png',
              width: 400,
              height: 400,
            ),
            const Text(
              'Kamu belum melakukan\nTes MBTI!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.lightBlue),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment, color: Colors.teal),
            label: 'Tes MBTI',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.lightBlue),
            label: 'Profil',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => FrontQuestionScreen()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ProfilScreen()),
            );
          }
        },
      ),
    );
  }
}

class Profil_HasilMBTI extends StatelessWidget {
  final String name;
  final String mbti;

  const Profil_HasilMBTI({super.key, required this.name, required this.mbti});

  @override
  Widget build(BuildContext context) {
    String title = '';
    String imagePath = '';
    String description = '';

    // Tentukan hasil berdasarkan MBTI
    if (mbti == 'ENFJ') {
      title = 'Protagonis';
      imagePath = 'assets/ENFJ.png';
      description =
          'Pemimpin yang karismatik dan inspiratif, dan mampu memukau pendengarnya.';
    } else if (mbti == 'ENFP') {
      title = 'Pencipta';
      imagePath = 'assets/ENFP.png';
      description =
          'Penuh energi, imajinatif, dan kreatif. Mereka senang mengeksplorasi kemungkinan-kemungkinan baru.';
    } else {
      title = 'Tidak Dikenal';
      imagePath = 'assets/default.jpg';
      description = 'Kepribadian yang belum terdefinisi dengan jelas.';
    }

    return Scaffold(
      backgroundColor: const Color(0xFFDAEBE3),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: double.infinity, // Membuat container full width
              padding: const EdgeInsets.only(
                  top: 50, bottom: 10, left: 20, right: 10),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // Align text and icon
                children: [
                  Text(
                    'Hai, $name!',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.black),
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                        // ignore: use_build_context_synchronously
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 20.0), // Menambahkan padding horizontal
              child: Text(
                'Kepribadian kamu adalah',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Image.asset(
              imagePath,
              height: 150,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20.0), // Menambahkan padding horizontal
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20.0), // Menambahkan padding horizontal
              child: Text(
                mbti,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20.0), // Menambahkan padding horizontal
              child: Text(
                description,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.lightBlue),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment, color: Colors.teal),
            label: 'Tes MBTI',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.lightBlue),
            label: 'Profil',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            // Navigasi ke HomeScreen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => FrontQuestionScreen()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ProfilScreen()),
            );
          }
        },
      ),
    );
  }
}
