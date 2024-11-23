import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firestore.dart';
import 'question_screen.dart';
import 'profil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  String userName = "User";
  String userMBTI = "";
  late Future<List<MapEntry<String, int>>> leaderboardFuture;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    leaderboardFuture = _firestoreService.getLeaderboard();
  }

  void _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final data = await _firestoreService.getUserData(user.uid);
      setState(() {
        userName = data['name'] ?? "User";
        userMBTI = data['MBTI'] ?? "";
      });
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
                  "Selamat datang, $userName!",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Leaderboard",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    FutureBuilder<List<MapEntry<String, int>>>(
                      future: leaderboardFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(child: Text('Terjadi kesalahan.'));
                        }

                        final leaderboard = snapshot.data ?? [];
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.yellow[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Table(
                            columnWidths: const {
                              0: FlexColumnWidth(3),
                              1: FlexColumnWidth(1),
                            },
                            border: TableBorder.symmetric(
                              inside: BorderSide(color: Colors.grey),
                            ),
                            children: leaderboard.map((entry) {
                              return TableRow(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '${leaderboard.indexOf(entry) + 1}. ${entry.key}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      entry.value.toString(),
                                      textAlign: TextAlign.end,
                                      style: TextStyle(fontSize: 16),
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
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Kamu belum tau kepribadian kamu?\nLangsung Tes MBTI kamu, yuk!",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => QuestionScreen()),
                          );
                        },
                        child: Text("Mulai Tes"),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Analis Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  color: Color(0xFFD6EBE2),
                  padding: const EdgeInsets.all(8.0), // Padding dalam container
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceAround, // Atur jarak antar kolom
                    children: [
                      _buildAnalysisCard('assets/INTJ.png', "INTJ",
                          "Pemikir strategis yang fokus pada masa depan."),
                      _buildAnalysisCard('assets/INFJ.png', "INFJ",
                          "Idealistis dan penuh inspirasi untuk "),
                    ],
                  ),
                ),
              ),
              // Analis Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  color: Color(0xFFD6EBE2),
                  padding: const EdgeInsets.all(8.0), // Padding dalam container
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceAround, // Atur jarak antar kolom
                    children: [
                      _buildAnalysisCard('assets/INTJ.png', "INTJ",
                          "Pemikir strategis yang fokus pada masa depan."),
                      _buildAnalysisCard('assets/INFJ.png', "INFJ",
                          "Idealistis dan penuh inspirasi untuk "),
                    ],
                  ),
                ),
              ),
              // Analis Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 184, 142, 192),
                  ),
                  padding: const EdgeInsets.all(8.0), // Padding dalam container
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceAround, // Atur jarak antar kolom
                    children: [
                      _buildAnalysisCard('assets/INTJ.png', "INTJ",
                          "Pemikir strategis yang fokus pada masa depan."),
                      _buildAnalysisCard('assets/INFJ.png', "INFJ",
                          "Idealistis dan penuh inspirasi untuk "),
                    ],
                  ),
                ),
              ),
              // Analis Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 184, 142, 192),
                  ),
                  padding: const EdgeInsets.all(8.0), // Padding dalam container
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceAround, // Atur jarak antar kolom
                    children: [
                      _buildAnalysisCard('assets/INTJ.png', "INTJ",
                          "Pemikir strategis yang fokus pada masa depan."),
                      _buildAnalysisCard('assets/INFJ.png', "INFJ",
                          "Idealistis dan penuh inspirasi untuk "),
                    ],
                  ),
                ),
              ),
              // Analis Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(248, 222, 218, 147),
                  ),
                  padding: const EdgeInsets.all(8.0), // Padding dalam container
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceAround, // Atur jarak antar kolom
                    children: [
                      _buildAnalysisCard('assets/INTJ.png', "INTJ",
                          "Pemikir strategis yang fokus pada masa depan."),
                      _buildAnalysisCard('assets/INFJ.png', "INFJ",
                          "Idealistis dan penuh inspirasi untuk "),
                    ],
                  ),
                ),
              ),
              // Analis Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(248, 222, 218, 147),
                  ),
                  padding: const EdgeInsets.all(8.0), // Padding dalam container
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceAround, // Atur jarak antar kolom
                    children: [
                      _buildAnalysisCard('assets/INTJ.png', "INTJ",
                          "Pemikir strategis yang fokus pada masa depan."),
                      _buildAnalysisCard('assets/INFJ.png', "INFJ",
                          "Idealistis dan penuh inspirasi untuk "),
                    ],
                  ),
                ),
              ),
              // Analis Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(248, 167, 244, 242),
                  ),
                  padding: const EdgeInsets.all(8.0), // Padding dalam container
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceAround, // Atur jarak antar kolom
                    children: [
                      _buildAnalysisCard('assets/INFJ.png', "INTJ",
                          "Pemikir strategis yang fokus pada masa depan."),
                      _buildAnalysisCard('assets/INFJ.png', "INFJ",
                          "Idealistis dan penuh inspirasi untuk "),
                    ],
                  ),
                ),
              ),
              // Analis Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(248, 167, 244, 242),
                  ),
                  padding: const EdgeInsets.all(8.0), // Padding dalam container
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceAround, // Atur jarak antar kolom
                    children: [
                      _buildAnalysisCard('assets/INFJ.png', "INTJ",
                          "Pemikir strategis yang fokus pada masa depan."),
                      _buildAnalysisCard('assets/INFJ.png', "INFJ",
                          "Idealistis dan penuh inspirasi untuk "),
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

  // TableRow for leaderboard display
  TableRow _buildTableRow(String type, String score) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(type, style: TextStyle(fontSize: 16)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(score,
              textAlign: TextAlign.end, style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }

  // Widget to create an analysis card for different MBTI types
  Widget _buildAnalysisCard(
      String imagePath, String title, String description) {
    return Expanded(
      child: Column(
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
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}
