import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firestore.dart';
import 'questionscreen.dart';
import 'profil.dart';
import 'hasil_MBTI.dart';
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

                        final leaderboard =
                            (snapshot.data ?? []).take(5).toList();

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
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildAnalysisCard("INTJ"),
                      _buildAnalysisCard("INTP"),
                    ],
                  ),
                ),
              ),
              // Analis Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildAnalysisCard("ENTJ"),
                      _buildAnalysisCard("ENTP"),
                    ],
                  ),
                ),
              ),
              // Analis Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: const BoxDecoration(),
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildAnalysisCard("INFJ"),
                      _buildAnalysisCard("INFP"),
                    ],
                  ),
                ),
              ),
              // Analis Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: const BoxDecoration(),
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildAnalysisCard("ENFJ"),
                      _buildAnalysisCard("ENFP"),
                    ],
                  ),
                ),
              ),
              // Analis Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: const BoxDecoration(),
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildAnalysisCard("ISTJ"),
                      _buildAnalysisCard("ISFJ"),
                    ],
                  ),
                ),
              ),
              // Analis Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: const BoxDecoration(),
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildAnalysisCard("ESTJ"),
                      _buildAnalysisCard("ESFJ"),
                    ],
                  ),
                ),
              ),
              // Analis Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: const BoxDecoration(),
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildAnalysisCard("ISTP"),
                      _buildAnalysisCard("ISFP"),
                    ],
                  ),
                ),
              ),
              // Analis Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: const BoxDecoration(),
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildAnalysisCard("ESTP"),
                      _buildAnalysisCard("ESFP"),
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

  Widget _buildAnalysisCard(String mbtiType) {
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
              width: MediaQuery.of(context).size.width * 0.4,
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                color: color,
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
                      color: Colors.black,
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

  Color _parseColor(String colorString) {
    final match =
        RegExp(r'ARGB\((\d+), (\d+), (\d+), (\d+)\)').firstMatch(colorString);
    if (match != null) {
      final a = int.parse(match.group(1)!);
      final r = int.parse(match.group(2)!);
      final g = int.parse(match.group(3)!);
      final b = int.parse(match.group(4)!);
      return Color.fromARGB(a, r, g, b);
    }
    return Colors.white;
  }
}
