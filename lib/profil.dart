import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';
import 'questionscreen.dart';
import 'login.dart';
import 'hasil_MBTI.dart';

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
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text('Terjadi kesalahan. Silakan coba lagi!')),
          );
        }

        final userData = snapshot.data;
        final String MBTI = userData?['MBTI'] ?? "";
        final String name = userData?['name'] ?? 'User';

        if (MBTI.isEmpty) {
          return Profil_Notfound(name: name);
        } else {
          return Profil_HasilMBTI(name: name, MBTI: MBTI);
        }
      },
    );
  }
}

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Image.asset('assets/head.png', width: 400, height: 400),
            const Text(
              'Kamu belum melakukan\nTes MBTI!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.black),
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
  final String MBTI;

  const Profil_HasilMBTI({super.key, required this.name, required this.MBTI});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('hasil_mbti')
          .doc(MBTI) // Fetch the MBTI type details
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(
              child: Text('Terjadi kesalahan saat memuat hasil MBTI.'));
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text('MBTI tidak ditemukan.'));
        }

        final mbtiData = snapshot.data!;
        final String title = mbtiData['title'] ?? 'Tidak Dikenal';
        final String description =
            mbtiData['description'] ?? 'Deskripsi tidak tersedia.';
        final String imagePath = mbtiData['image'] ?? 'assets/default.jpg';
        final colorString = mbtiData['color'] ?? 'ARGB(255, 255, 255, 255)';
        final color = parseColor(colorString);

        return Scaffold(
          backgroundColor: color,
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
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 100),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Kepribadian kamu adalah',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                Image.asset(imagePath, height: 150),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    title,
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800]),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    MBTI,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    description,
                    style: const TextStyle(fontSize: 18, color: Colors.black),
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              } else if (index == 1) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FrontQuestionScreen()),
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
      },
    );
  }
}
