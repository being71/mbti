import 'package:flutter/material.dart';
import 'hasil_MBTI.dart'; // Mengimpor halaman HasilMBTI.dart

class QuestionScreen extends StatefulWidget {
  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  // Indeks pertanyaan saat ini
  int currentQuestionIndex = 0;

  // Poin untuk E/I, N/S, F/T, J/P
  String personalityType = '';

  // List pertanyaan dan gambar
  final List<Map<String, String>> questions = [
    {
      "image": "assets/ty4.png",
      "question":
          "Apakah kamu merasa lebih berenergi setelah menghabiskan waktu dengan banyak orang dan berbicara dengan mereka?",
      "type": "EI", // E/I
    },
    {
      "image": "assets/ty1.png",
      "question":
          "Apakah kamu lebih suka membayangkan masa depan dan memikirkan ide-ide besar daripada berfokus pada apa yang ada di depan mata?",
      "type": "NS", // N/S
    },
    {
      "image": "assets/ty5.png",
      "question":
          "Ketika membuat keputusan, apakah kamu lebih cenderung mempertimbangkan perasaan dan dampaknya terhadap orang lain dibandingkan dengan fakta dan logika saja?",
      "type": "FT", // F/T
    },
    {
      "image": "assets/ty4.png",
      "question":
          "Apakah kamu lebih suka membuat rencana dan jadwal terperinci untuk memastikan segalanya terorganisasi dengan baik dibandingkan menghadapi situasi secara spontan?",
      "type": "JP", // J/P
    },
  ];

  // Fungsi untuk mengakumulasi nilai berdasarkan pilihan
  void handleAnswer(String answer) {
    String answerType = questions[currentQuestionIndex]["type"]!;

    // Menambahkan karakter berdasarkan pilihan
    if (answer == "Ya") {
      if (answerType == "EI") {
        personalityType += "E"; // E untuk pertanyaan pertama
      } else if (answerType == "NS") {
        personalityType += "N"; // N untuk pertanyaan kedua
      } else if (answerType == "FT") {
        personalityType += "F"; // F untuk pertanyaan ketiga
      } else if (answerType == "JP") {
        personalityType += "J"; // J untuk pertanyaan keempat
      }
    } else {
      if (answerType == "EI") {
        personalityType += "I"; // I untuk pertanyaan pertama
      } else if (answerType == "NS") {
        personalityType += "S"; // S untuk pertanyaan kedua
      } else if (answerType == "FT") {
        personalityType += "T"; // T untuk pertanyaan ketiga
      } else if (answerType == "JP") {
        personalityType += "P"; // P untuk pertanyaan keempat
      }
    }

    // Lanjutkan ke pertanyaan berikutnya
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      // Jika semua pertanyaan sudah terjawab, navigasi ke hasil
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HasilMBTI(personalityType),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pertanyaan ${currentQuestionIndex + 1}"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              questions[currentQuestionIndex]["image"]!,
              height: 150,
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                questions[currentQuestionIndex]["question"]!,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => handleAnswer("Ya"),
                  child: Text("Ya"),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => handleAnswer("Tidak"),
                  child: Text("Tidak"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
