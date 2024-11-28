import 'package:flutter/material.dart';

class QuestionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Kotak pertama dengan gambar dan teks
            Container(
              width: 220,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: const Offset(2, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/head.png',
                    fit: BoxFit.contain,
                    height: 100,
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
            // Kotak kedua dengan gambar dan teks
            Container(
              width: 220,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.yellow[100],
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: const Offset(2, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/theory.png',
                    fit: BoxFit.contain,
                    height: 100,
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
            // Kotak ketiga dengan gambar dan teks
            Container(
              width: 220,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.purple[100],
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: const Offset(2, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/exercise.png',
                    fit: BoxFit.contain,
                    height: 100,
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
            // Tombol besar dengan shadow
            Container(
              width: 250,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: const Offset(2, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Warna tombol
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  // Tambahkan logika ketika tombol ditekan
                  Text("Mulai Tes MBTI!");
                },
                child: const Text(
                  "Mulai Tes MBTI!",
                  style: TextStyle(
                    fontSize: 18, // Ukuran font
                    fontWeight: FontWeight.bold, // Ketebalan font
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
