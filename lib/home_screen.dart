import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firestore.dart';
import 'questionscreen.dart';
import 'profil.dart';
import 'hasil_MBTI.dart'; // memanggil method _parsecolor
import 'detail_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  String userName = "";
  String userMBTI = "";

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final data = await _firestoreService.getUserData(user.uid);
        print('Fetched user data: $data');
        setState(() {
          userName = data['name'] ?? "Unknown";
          userMBTI = data['MBTI'] ?? "Not specified";
        });
      } catch (e) {
        print("Error fetching user data: ${e.toString()}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Selamat datang, $userName !",
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Leaderboard",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    StreamBuilder<List<MapEntry<String, int>>>(
                      // StreamBuilder untuk mendengarkan perubahan data pada Firestore secara real-time
                      stream: _firestoreService.getLeaderboard(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return const Center(
                              child: Text('Terjadi kesalahan.'));
                        }

                        final leaderboard = snapshot.data ?? [];

                        // TAMBAHKAN JIKA LEADERBOARD EMPTY

                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.yellow[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Table(
                            columnWidths: const {
                              0: FlexColumnWidth(
                                  3), // Kolom pertama memiliki fleksibilitas 3
                              1: FlexColumnWidth(
                                  1), // Kolom kedua memiliki fleksibilitas 1
                            },
                            border: const TableBorder.symmetric(
                              inside: BorderSide(color: Colors.grey),
                            ),
                            children: leaderboard.map((entry) {
                              return TableRow(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '${leaderboard.indexOf(entry) + 1}. ${entry.key}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      entry.value.toString(),
                                      textAlign: TextAlign.end,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "Kamu belum tau kepribadian kamu?\nLangsung Tes MBTI kamu, yuk!",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FrontQuestionScreen()),
                          );
                        },
                        child: const Text("Mulai Tes"),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Analis Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  padding: const EdgeInsets.all(8.0), // Padding dalam container
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceAround, // Atur jarak antar kolom
                    children: [
                      _buildAnalysisCard("INTJ", 0),
                      _buildAnalysisCard("INTP", 0),
                    ],
                  ),
                ),
              ),
              // Analis Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  padding: const EdgeInsets.all(8.0), // Padding dalam container
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceAround, // Atur jarak antar kolom
                    children: [
                      _buildAnalysisCard("ENTJ", 0),
                      _buildAnalysisCard("ENTP", 0),
                    ],
                  ),
                ),
              ),
              // Analis Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: const BoxDecoration(),
                  padding: const EdgeInsets.all(8.0), // Padding dalam container
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceAround, // Atur jarak antar kolom
                    children: [
                      _buildAnalysisCard("INFJ", 1),
                      _buildAnalysisCard("INFP", 1),
                    ],
                  ),
                ),
              ),
              // Analis Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: const BoxDecoration(),
                  padding: const EdgeInsets.all(8.0), // Padding dalam container
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceAround, // Atur jarak antar kolom
                    children: [
                      _buildAnalysisCard("ENFJ", 1),
                      _buildAnalysisCard("ENFP", 1),
                    ],
                  ),
                ),
              ),
              // Analis Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: const BoxDecoration(),
                  padding: const EdgeInsets.all(8.0), // Padding dalam container
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceAround, // Atur jarak antar kolom
                    children: [
                      _buildAnalysisCard("ISTJ", 2),
                      _buildAnalysisCard("ISFJ", 2),
                    ],
                  ),
                ),
              ),
              // Analis Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: const BoxDecoration(),
                  padding: const EdgeInsets.all(8.0), // Padding dalam container
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceAround, // Atur jarak antar kolom
                    children: [
                      _buildAnalysisCard("ESTJ", 2),
                      _buildAnalysisCard("ESFJ", 2),
                    ],
                  ),
                ),
              ),
              // Analis Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: const BoxDecoration(),
                  padding: const EdgeInsets.all(8.0), // Padding dalam container
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceAround, // Atur jarak antar kolom
                    children: [
                      _buildAnalysisCard("ISTP", 3),
                      _buildAnalysisCard("ISFP", 3),
                    ],
                  ),
                ),
              ),
              // Analis Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: const BoxDecoration(),
                  padding: const EdgeInsets.all(8.0), // Padding dalam container
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceAround, // Atur jarak antar kolom
                    children: [
                      _buildAnalysisCard("ESTP", 3),
                      _buildAnalysisCard("ESFP", 3),
                    ],
                  ),
                ),
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
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          } else if (index == 1) {
            // Navigasi ke QuestionScreen (Tes MBTI)
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => FrontQuestionScreen()),
            );
          } else if (index == 2) {
            // Navigasi ke ProfilScreen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ProfilScreen()),
            );
          }
        },
      ),
    );
  }

  Widget _buildAnalysisCard(String mbtiType, index) {
    final List<Color> colors = [
      Color.fromARGB(255, 216, 192, 223),
      Color.fromARGB(255, 194, 231, 215),
      Color.fromARGB(255, 181, 214, 226),
      Color(0xFFF6EED9),
    ];

    final color = colors[index % colors.length];

    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPage(mbtiType: mbtiType),
            ),
          );
        },
        child: FutureBuilder<Map<String, dynamic>>(
          future: _firestoreService.getAnalysisData(mbtiType),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              print('Error in _buildAnalysisCard: ${snapshot.error}');
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData) {
              return const Center(child: Text('Data not available'));
            }

            final data = snapshot.data!;
            print('Fetched data for $mbtiType: $data');
            final imagePath = data['image'] ?? 'assets/default.png';
            final description_home =
                data['description_home'] ?? 'No description available';
            final colorString = data['color'] ?? 'ARGB(255, 255, 255, 255)';
            final color = parseColor(colorString);

            return Container(
              width: MediaQuery.of(context).size.width *
                  0.4, // Ukuran proporsional
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                color: colors[index % colors.length],
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    spreadRadius: 2,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      imagePath,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    mbtiType,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Use the color here
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description_home,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
            );
          },
        ));
  }
}
