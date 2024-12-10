import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailPage extends StatelessWidget {
  final String mbtiType;

  const DetailPage({super.key, required this.mbtiType});

  Future<Map<String, dynamic>> _fetchMBTIDetails() async {
    final doc = await FirebaseFirestore.instance
        .collection('hasil_mbti')
        .doc(mbtiType)
        .get();
    return doc.data() ?? {};
  }

  Future<List<String>> _fetchUsersWithSameMBTI() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('MBTI', isEqualTo: mbtiType)
        .limit(5)
        .get();

    return snapshot.docs.map((doc) => doc['name'] as String).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _fetchMBTIDetails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (!snapshot.hasData || snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text("Data tidak ditemukan.")),
          );
        }

        final mbtiDetails = snapshot.data!;
        final image = mbtiDetails['image'] ?? 'assets/default.png';
        final description =
            mbtiDetails['description_full'] ?? 'Tidak ada deskripsi.';

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(mbtiType),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    image,
                    height: 150,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Tipe Kepribadian kamu adalah: $mbtiType",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  description,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Teman kepribadian yang sama dengan kamu:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                FutureBuilder<List<String>>(
                  future: _fetchUsersWithSameMBTI(),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (!userSnapshot.hasData || userSnapshot.data!.isEmpty) {
                      return const Text(
                          "Belum ada user lain dengan MBTI yang sama.");
                    }

                    final users = userSnapshot.data!;
                    return Column(
                      children: users.map((user) => Text(user)).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
