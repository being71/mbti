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
        .where('mbtiType', isEqualTo: mbtiType)
        .limit(5)
        .get();

    return snapshot.docs.map((doc) => doc['name'] as String).toList();
  }

  Color _parseColor(String colorString) {
    final rgb = colorString
        .replaceAll('ARGB(', '')
        .replaceAll(')', '')
        .split(',')
        .map((e) => int.parse(e.trim()))
        .toList();
    return Color.fromARGB(rgb[0], rgb[1], rgb[2], rgb[3]);
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
        final colorString = mbtiDetails['color'] ?? 'ARGB(255, 255, 255, 255)';
        final backgroundColor = _parseColor(colorString);
        final compatible = mbtiDetails['compatible'] ?? 'Tidak tersedia';
        final notCompatible = mbtiDetails['not_compatible'] ?? 'Tidak tersedia';

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              mbtiType,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: backgroundColor,
          ),
          body: Container(
            color: backgroundColor,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          image,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            "Tipe Kepribadian Kamu",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            mbtiType,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(color: Colors.black87),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      description,
                      style: const TextStyle(
                          fontSize: 16, color: Colors.black87, height: 1.5),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "MBTI yang cocok dengan kamu adalah $compatible.",
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "MBTI yang kurang cocok dengan kamu adalah $notCompatible.",
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    const SizedBox(height: 24),
                    const Divider(
                      thickness: 1,
                      color: Colors.black54,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Teman Kepribadian yang Sama:",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                    FutureBuilder<List<String>>(
                      future: _fetchUsersWithSameMBTI(),
                      builder: (context, userSnapshot) {
                        if (userSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (!userSnapshot.hasData ||
                            userSnapshot.data!.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Text(
                              "Belum ada user lain dengan MBTI yang sama.",
                              style: TextStyle(fontSize: 16),
                            ),
                          );
                        }

                        final users = userSnapshot.data!;
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: const Icon(Icons.person),
                              title: Text(users[index]),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
