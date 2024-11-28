// ignore_for_file: file_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'firestore.dart'; // Pastikan untuk menambahkan import FirestoreService

class HasilMBTI extends StatelessWidget {
  final String personalityType;

  // Konstruktor untuk menerima tipe kepribadian
  const HasilMBTI(this.personalityType);

  // Fungsi untuk memperbarui MBTI di Firestore
  Future<void> updateMBTI(String personalityType) async {
    try {
      // Dapatkan UID pengguna yang sedang login
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Panggil FirestoreService untuk memperbarui data MBTI
      FirestoreService firestoreService = FirestoreService();
      await firestoreService.updateMBTI(userId, personalityType);

      print("MBTI berhasil diperbarui ke Firestore");
    } catch (e) {
      print("Error saat memperbarui MBTI: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    String title = '';
    String imagePath = '';
    String description = '';
    String similarity = '';
    String mbtiType = '';
    Color color = Colors.white; // default color

    // Tentukan hasil berdasarkan personalityType
    if (personalityType == 'INTJ') {
      title = 'Arsitek';
      imagePath = 'assets/INTJ.png';
      mbtiType = 'INTJ';
      color = const Color(0xFFE6DEE9);
      description =
          'Pemikir imajinatif dan strategis yang menyiapkan rencana untuk segala hal.';
      similarity = '2.1%';
    } else if (personalityType == 'INTP') {
      title = 'Penemu';
      imagePath = 'assets/INTP.png';
      mbtiType = 'INTP';
      color = const Color(0xFFE6DEE9);
      description = 'Penemu inovatif yang haus akan pengetahuan.';
      similarity = '3.3%';
    } else if (personalityType == 'ENTJ') {
      title = 'Komandan';
      imagePath = 'assets/ENTJ.png';
      mbtiType = 'ENTJ';
      color = const Color(0xFFE6DEE9);
      description =
          'Pemimpin pemberani, imajinatif, dan memiliki determinasi tinggi, selalu menemukan cara - atau menciptakan caranya sendiri.';
      similarity = '1.8%';
    } else if (personalityType == 'ENTP') {
      title = 'Debater';
      imagePath = 'assets/ENTP.png';
      mbtiType = 'ENTP';
      color = const Color(0xFFE6DEE9);
      description =
          'Pemikir cerdas dan penuh rasa ingin tahu yang tidak bisa menolak tantangan intelektual.';
      similarity = '3.2%';
    } else if (personalityType == 'INFJ') {
      title = 'Advokat';
      imagePath = 'assets/INFJ.png';
      mbtiType = 'INFJ';
      color = const Color(0xFFDAEBE3);
      description =
          'Idealis yang tenang dan berjiwa spiritual sekaligus inspiratif dan tak kenal lelah.';
      similarity = '1.5%';
    } else if (personalityType == 'INFP') {
      title = 'Mediator';
      imagePath = 'assets/INFP.png';
      mbtiType = 'INFP';
      color = const Color(0xFFDAEBE3);
      description =
          'Pribadi yang puitis, baik hati, dan altruistik, selalu ingin membantu demi kebaikan.';
      similarity = '4.4%';
    } else if (personalityType == 'ENFJ') {
      title = 'Protagonis';
      imagePath = 'assets/ENFJ.png';
      mbtiType = 'ENFJ';
      color = const Color(0xFFDAEBE3);
      description =
          'Pemimpin yang karismatik dan inspiratif, mampu memukau pendengarnya.';
      similarity = '2.5%';
    } else if (personalityType == 'ENFP') {
      title = 'Kampiun';
      imagePath = 'assets/ENFP.png';
      mbtiType = 'ENFP';
      color = const Color(0xFFDAEBE3);
      description =
          'Jiwa yang antusias, kreatif, dan bebas bergaul sehingga tidak pernah merasa sedih.';
      similarity = '8.1%';
    } else if (personalityType == 'ISTJ') {
      title = 'Logistik';
      imagePath = 'assets/ISTJ.png';
      mbtiType = 'ISTJ';
      color = const Color(0xFFDCE9E);
      description =
          'Individu yang berpikiran praktis, faktual, dan sangat bisa diandalkan.';
      similarity = '11.6%';
    } else if (personalityType == 'ISFJ') {
      title = 'Pelindung';
      imagePath = 'assets/ISFJ.png';
      mbtiType = 'ISFJ';
      color = const Color(0xFFDCE9E);
      description =
          'Pelindung yang sangat berdedikasi dan ramah, selalu siap membela orang yang mereka sayangi.';
      similarity = '13.8%';
    } else if (personalityType == 'ESTJ') {
      title = 'Eksekutif';
      imagePath = 'assets/ESTJ.png';
      mbtiType = 'ESTJ';
      color = const Color(0xFFDCE9E);
      description =
          'Administrator yang unggul, tak tertandingi dalam mengelola segala hal - atau bahkan manusia.';
      similarity = '8.7%';
    } else if (personalityType == 'ESFJ') {
      title = 'Konsul';
      imagePath = 'assets/ESFJ.png';
      mbtiType = 'ESFJ';
      color = const Color(0xFFDCE9E);
      description =
          'Pribadi yang penuh perhatian, supel, dan banyak dikenal, selalu ingin membantu.';
      similarity = '12.3%';
    } else if (personalityType == 'ISTP') {
      title = 'Ahli Teknik';
      imagePath = 'assets/ISTP.png';
      mbtiType = 'ISTP';
      color = const Color(0xFFF6EED9);
      description =
          'Peneliti yang pemberani dan praktis, menguasai semua jenis alat.';
      similarity = '5.4%';
    } else if (personalityType == 'ISFP') {
      title = 'Artis';
      imagePath = 'assets/ISFP.png';
      mbtiType = 'ISFP';
      color = const Color(0xFFF6EED9);
      description =
          'Seniman yang fleksibel dan memesona, selalu siap menjelajahi dan merasakan hal baru.';
      similarity = '8.8%';
    } else if (personalityType == 'ESTP') {
      title = 'Penghibur';
      imagePath = 'assets/ESTP.png';
      mbtiType = 'ESTP';
      color = const Color(0xFFF6EED9);
      description =
          'Pribadi cerdas, energik, dan sangat peka yang benar-benar menikmati hidup yang menantang.';
      similarity = '4.3%';
    } else if (personalityType == 'ESFP') {
      title = 'Penghibur';
      imagePath = 'assets/ESFP.png';
      mbtiType = 'ESFP';
      color = const Color(0xFFF6EED9);
      description =
          'Pribadi yang spontan, energik, dan antusias - bersama mereka, hidup tidak akan terasa membosankan.';
      similarity = '6.8%';
    } else {
      title = 'Tidak Dikenal';
      imagePath = 'assets/default.jpg';
      color = const Color(0xFFDAEBE3);
      mbtiType = personalityType;
      description = 'Kepribadian yang belum terdefinisi dengan jelas.';
      similarity = '0.1 %';
    }

    return Scaffold(
      backgroundColor: color,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Tipe Kepribadian Kamu adalah',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Image.asset(
                imagePath,
                height: 150,
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                mbtiType,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              const Text(
                'Kamu Memiliki Kepribadian yang sama dengan',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                similarity,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
              const Text(
                'Populasi di dunia',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Panggil updateMBTI untuk memperbarui data MBTI pengguna
                  updateMBTI(personalityType);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const HomeScreen()), // Ganti dengan login.dart
                  ); // Kembali ke halaman sebelumnya
                },
                child: const Text("OK"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
