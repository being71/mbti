// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'firestore.dart';
import 'hasil_MBTI.dart'; // Mengimpor halaman HasilMBTI.dart

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  QuestionScreenState createState() => QuestionScreenState();
}

class QuestionScreenState extends State<QuestionScreen> {
  int currentQuestionIndex = 0;

  // Poin untuk setiap tipe kepribadian
  int extrovertPoints = 0;
  int introvertPoints = 0;
  int intuitivePoints = 0;
  int sensingPoints = 0;
  int feelingPoints = 0;
  int thinkingPoints = 0;
  int judgingPoints = 0;
  int perceivingPoints = 0;

  String personalityType = '';
  List<Map<String, String>> questions = [];
  bool isLoading = true; // Tambahkan indikator loading

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    final firestoreService = FirestoreService();
    try {
      List<Map<String, dynamic>> fetchedQuestions =
          await firestoreService.getMBTIQuestions();

      if (fetchedQuestions.isNotEmpty) {
        setState(() {
          questions = fetchedQuestions.map((q) {
            return {
              "question": q["question"] as String,
              "type": q["type"] as String,
              "image": q["image"] as String,
            };
          }).toList();
        });
      } else {
        print("No questions found in Firestore.");
      }
    } catch (e) {
      print("Error loading questions: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void handleAnswer(String answer) {
    // Identifikasi tipe pertanyaan saat ini
    String questionType = questions[currentQuestionIndex]["type"]!;

    // Tambahkan poin berdasarkan jawaban
    if (questionType == "EI") {
      if (answer == "Ya") {
        extrovertPoints++;
      } else {
        introvertPoints++;
      }
    } else if (questionType == "NS") {
      if (answer == "Ya") {
        intuitivePoints++;
      } else {
        sensingPoints++;
      }
    } else if (questionType == "FT") {
      if (answer == "Ya") {
        feelingPoints++;
      } else {
        thinkingPoints++;
      }
    } else if (questionType == "JP") {
      if (answer == "Ya") {
        judgingPoints++;
      } else {
        perceivingPoints++;
      }
    }

    // Lanjutkan ke pertanyaan berikutnya
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      // Hitung hasil setelah semua pertanyaan selesai
      determinePersonalityType();
    }
  }

  void determinePersonalityType() async {
    // Tentukan E/I, N/S, F/T, J/P
    personalityType += (extrovertPoints > introvertPoints) ? "E" : "I";
    personalityType += (intuitivePoints > sensingPoints) ? "N" : "S";
    personalityType += (feelingPoints > thinkingPoints) ? "F" : "T";
    personalityType += (judgingPoints > perceivingPoints) ? "J" : "P";

    // Navigasi ke halaman hasil
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HasilMBTI(personalityType),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while questions are being loaded
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text("MBTI Test")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Show a message if questions list is empty
    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("MBTI Test")),
        body: const Center(
            child: Text("No questions available. Please try again later.")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Pertanyaan ${currentQuestionIndex + 1}")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              constraints: const BoxConstraints(
                maxHeight: 370, // Batas tinggi statis
              ),
              child: Column(
                children: [
                  Image.asset(
                    (questions[currentQuestionIndex]["image"] ?? '') + ".png",
                    width: 250,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 30), // Jarak antara gambar dan teks
                  Container(
                    height: 100, // Tinggi tetap untuk teks
                    child: Text(
                      questions[currentQuestionIndex]["question"]!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8), // Jarak antara kontainer dan tombol
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => handleAnswer("Ya"),
                  child: const Text("Ya"),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => handleAnswer("Tidak"),
                  child: const Text("Tidak"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
