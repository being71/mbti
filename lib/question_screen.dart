// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'firestore.dart';
import 'hasil_MBTI.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  QuestionScreenState createState() => QuestionScreenState();
}

class QuestionScreenState extends State<QuestionScreen> {
  int currentQuestionIndex = 0;

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
  bool isLoading = true;

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
    String questionType = questions[currentQuestionIndex]["type"]!;

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

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      determinePersonalityType();
    }
  }

  void determinePersonalityType() async {
    personalityType += (extrovertPoints > introvertPoints) ? "E" : "I";
    personalityType += (intuitivePoints > sensingPoints) ? "N" : "S";
    personalityType += (feelingPoints > thinkingPoints) ? "F" : "T";
    personalityType += (judgingPoints > perceivingPoints) ? "J" : "P";

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HasilMBTI(personalityType),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("MBTI Test"),
          backgroundColor: const Color.fromARGB(255, 194, 231, 215),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("MBTI Test"),
          backgroundColor: const Color.fromARGB(255, 194, 231, 215),
        ),
        body: const Center(
            child: Text("No questions available. Please try again later.")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pertanyaan ${currentQuestionIndex + 1}",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 194, 231, 215),
      ),
      backgroundColor: const Color.fromARGB(255, 246, 238, 217),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 255, 255, 255),
                    Color.fromARGB(255, 242, 236, 244),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border:
                    Border.all(color: const Color.fromARGB(255, 194, 231, 215)),
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
                maxHeight: 370,
              ),
              child: Column(
                children: [
                  Image.asset(
                    (questions[currentQuestionIndex]["image"] ?? '') + ".png",
                    width: 250,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    questions[currentQuestionIndex]["question"]!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: (currentQuestionIndex + 1) / questions.length,
              backgroundColor: const Color.fromARGB(255, 246, 238, 217),
              color: const Color.fromARGB(255, 181, 214, 226),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => handleAnswer("Ya"),
                  child: const Text("Ya"),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
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
