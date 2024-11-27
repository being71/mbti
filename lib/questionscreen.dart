import 'package:flutter/material.dart';
import 'question_screen.dart';

class FrontQuestionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Kotak pertama dengan gambar dan teks
            Container(
              width: 200,
              height: 150, // Meningkatkan tinggi untuk menampung teks
              decoration: BoxDecoration(
                color: Colors.yellow[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/head.png',
                    fit: BoxFit.contain,
                    height: 60,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Jadilah diri Anda sepenuhnya dan beri jawaban sejujurnya untuk mengetahui tipe kepribadian Anda.",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Kotak kedua dengan gambar dan teks
            Container(
              width: 200,
              height: 150, // Meningkatkan tinggi untuk menampung teks
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/head.png',
                    fit: BoxFit.contain,
                    height: 60,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Pelajari cara tipe kepribadian Anda memengaruhi banyak aspek dalam hidup Anda.",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Kotak ketiga dengan gambar dan teks
            Container(
              width: 200,
              height: 150, // Meningkatkan tinggi untuk menampung teks
              decoration: BoxDecoration(
                color: Colors.purple[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/head.png',
                    fit: BoxFit.contain,
                    height: 50,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Berkembanglah menjadi pribadi yang Anda inginkan dengan berbagai materi premium opsional kami.",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            // Tombol
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => QuestionScreen()));
                print("Mulai Tes MBTI!");
              },
              child: const Text("Mulai Tes MBTI!"),
            ),
          ],
        ),
      ),
    );
  }
}
