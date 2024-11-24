import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';
import 'question_screen.dart';

class ProfilScreen extends StatelessWidget {
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
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Tampilkan pesan error jika terjadi kesalahan saat mengambil data
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Terjadi kesalahan. Silakan coba lagi!')),
          );
        }

        final userData = snapshot.data;

// Periksa apakah MBTI tersedia
        final String mbti = userData?['MBTI'] ??
            "" ??
            null; // Berikan nilai default kosong jika null
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

  const Profil_Notfound({required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: double.infinity, // Membuat container full width
              color: Colors.purple[100],
              padding: const EdgeInsets.only(top: 50, bottom: 10, left: 20),
              child: Text(
                'Hai, $name!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 30),
            Image.asset(
              'assets/head.png', // Path ke gambar asset
              width: 400, // Set lebar sesuai kebutuhan
              height: 400 // Set tinggi sesuai kebutuhan
            ),
            Text(
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
            // Navigasi ke HomeScreen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } else if (index == 1) {
            // Navigasi ke QuestionScreen (Tes MBTI)
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => QuestionScreen()),
            );
          } else if (index == 2) {
            // Navigasi ke ProfilScreen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ProfilScreen()),
            );
          }
        },
      ),
    );
  }
}

// Tampilan untuk profil jika MBTI sudah ada
class Profil_HasilMBTI extends StatelessWidget {
  final String name;
  final String mbti;

  const Profil_HasilMBTI({required this.name, required this.mbti});

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
      backgroundColor: Color(0xFFDAEBE3),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity, // Membuat container full width
                color: Colors.purple[100],
                padding: const EdgeInsets.only(top: 50, bottom: 10, left: 20),
                child: Text(
                  'Hai, $name!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: 100
              ),
              Text(
                'Kepribadian kamu adalah',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Image.asset(
                imagePath,
                height: 150,
              ),
              SizedBox(height: 20),
              Text(
                title,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
              SizedBox(height: 10),
              Text(
                mbti,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                description,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
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
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } else if (index == 1) {
            // Navigasi ke QuestionScreen (Tes MBTI)
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => QuestionScreen()),
            );
          } else if (index == 2) {
            // Navigasi ke ProfilScreen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ProfilScreen()),
            );
          }
        },
      ),
    );
  }
}
