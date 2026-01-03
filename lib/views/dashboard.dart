import 'package:app_pengaduan/views/news_detail.dart';
import 'package:app_pengaduan/views/kategori_pengaduan.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:app_pengaduan/viewmodels/auth_provider.dart' as custom_auth;
import 'package:app_pengaduan/views/konsultasi.dart';
import 'package:flutter/material.dart';
import '../model/news_model.dart';
import '../services/news_service.dart';
import 'news_detail.dart';
import '../model/pengaduan_model.dart';
import '../services/pengaduan_service.dart';
import 'riwayat_page.dart';
import 'notification_page.dart';
import 'package:app_pengaduan/views/profile_page.dart';
import '../utils/news_seeder.dart'; // Contains GlobalDataSeeder and NewsSeeder

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Auto-Run Seeder on Dashboard Load
    // This allows News to seed if empty, and 'Gambrul' users to get data if new.
    _runSeeder();
  }

  Future<void> _runSeeder() async {
    await GlobalDataSeeder.seedAll();
  }

  final List<Widget> _pages = [
    const DashboardContent(),
    const RiwayatPage(),
    const NotificationPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Pemberitahuan',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Logo and Title
              Row(
                children: [
                  Image.asset(
                    'assets/images/logo_pemkot.png',
                    width: 60,
                    height: 60,
                  ),
                  const SizedBox(width: 8),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PEMKOT',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        'Padang Panjang',
                        style: TextStyle(fontSize: 16, color: Colors.green),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ✅ Search bar and profile
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const TextField(
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search, color: Colors.grey),
                          hintText: 'Search',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Dynamic Profile Avatar
                  // Dynamic Profile Avatar
                  Consumer<custom_auth.AuthProvider>(
                    builder: (context, authProvider, child) {
                      final user = authProvider.currentUserData;
                      final String initial =
                          (user != null && user.name.isNotEmpty)
                          ? user.name[0].toUpperCase()
                          : '?';

                      return CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.green,
                        child: Text(
                          initial,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ✅ Trending Section
              const Text(
                'Trending',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 180,
                child: StreamBuilder<List<NewsModel>>(
                  stream: NewsService().getTrendingNews(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("Belum ada berita"));
                    }
                    final newsList = snapshot.data!;
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: newsList.length,
                      itemBuilder: (context, index) {
                        return TrendingCard(news: newsList[index]);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // ✅ Kategori Section
              const Text(
                'Kategori',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // ✅ Evenly spaced 4 Kategori items
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: KategoriItem('Informasi', Icons.campaign)),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const KonsultasiPage(),
                          ),
                        );
                      },
                      child: KategoriItem('Konsultasi', Icons.thumb_up),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => KategoriPengaduanPage(),
                          ),
                        );
                      },
                      child: KategoriItem('Pengaduan', Icons.feedback),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/KeluargaBerencana');
                      },
                      child: KategoriItem(
                        'Keluarga Berencana',
                        Icons.family_restroom,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ✅ Pengaduan Section
              const Text(
                'Pengaduan Saya',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 220,
                child: FutureBuilder<DocumentSnapshot>(
                  future: FirebaseAuth.instance.currentUser != null
                      ? FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .get()
                      : null,
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final userNik = userSnapshot.data?.data() != null
                        ? (userSnapshot.data!.data()
                                  as Map<String, dynamic>)['nik']
                              as String?
                        : null;

                    return StreamBuilder<List<PengaduanModel>>(
                      stream: userNik != null
                          ? PengaduanService().getMyHistory(userNik)
                          : Stream.value([]),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text("Belum ada pengaduan anda"),
                          );
                        }
                        final pengaduanList = snapshot.data!;
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: pengaduanList.length,
                          itemBuilder: (context, index) {
                            return PengaduanCard(
                              pengaduan: pengaduanList[index],
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------------ COMPONENTS ------------------------

class TrendingCard extends StatelessWidget {
  final NewsModel news;

  const TrendingCard({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NewsDetailPage(news: news)),
        );
      },
      child: Container(
        width: 250,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: NetworkImage(
              news.imagePath,
            ), // Changed to NetworkImage for generic support, or handle assets vs network
            fit: BoxFit.cover,
            onError: (exception, stackTrace) {
              // Fallback if network fails, or if it's a local asset path
            },
          ),
        ),

        child: Stack(
          children: [
            Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image(
                  image:
                      (news.imagePath.startsWith('http')
                              ? NetworkImage(news.imagePath)
                              : AssetImage(news.imagePath))
                          as ImageProvider,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      alignment: Alignment.center,
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 80, // Increased from 70 to 80 to prevent overflow
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(16),
                  ),
                  color: Colors.green.withOpacity(0.7),
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      news.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      news.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class KategoriItem extends StatelessWidget {
  final String title;
  final IconData icon;
  const KategoriItem(this.title, this.icon, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.green),
          ),
          child: Icon(icon, color: Colors.green, size: 28),
        ),
        const SizedBox(height: 6),
        Text(title, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

class PengaduanCard extends StatelessWidget {
  final PengaduanModel pengaduan;

  const PengaduanCard({super.key, required this.pengaduan});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 20,
                child: Icon(Icons.person, color: Colors.white),
                backgroundColor: Colors.green,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  pengaduan.fullname,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            pengaduan.kategori,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            pengaduan.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              pengaduan.statusText,
              style: const TextStyle(fontSize: 12, color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }
}
