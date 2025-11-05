import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // ✅ White background
      body: SafeArea(
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
                          'PEMKO',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        Text(
                          'Padang Panjang',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.green,
                          ),
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
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search, color: Colors.grey),
                            hintText: 'Search',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const CircleAvatar(
                      radius: 25,
                      backgroundImage:
                          AssetImage('assets/images/foto_dummy_1.jpg'),
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
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const [
                      TrendingCard('assets/images/foto_dummy_1.jpg'),
                      TrendingCard('assets/images/foto_dummy_2.jpg'),
                      TrendingCard('assets/images/foto_dummy_3.png'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ✅ Kategori Section
                // const Text(
                //   'Kategori',
                //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                // ),
                // const SizedBox(height: 12),
                // SizedBox(
                //   height: 100,
                //   child: ListView(
                //     scrollDirection: Axis.horizontal,
                //     children: const [
                //       KategoriItem('Informasi', Icons.campaign),
                //       KategoriItem('Konsultasi', Icons.thumb_up),
                //       KategoriItem('Pengaduan', Icons.feedback),
                //       KategoriItem('Lainnya', Icons.more_horiz),
                //     ],
                //   ),
                // ),
                // const SizedBox(height: 20),
                // ✅ Kategori Section
                const Text(
                  'Kategori',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                // ✅ Evenly spaced 4 Kategori items
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Expanded(child: KategoriItem('Informasi', Icons.campaign)),
                    Expanded(child: KategoriItem('Konsultasi', Icons.thumb_up)),
                    Expanded(child: KategoriItem('Pengaduan', Icons.feedback)),
                    Expanded(child: KategoriItem('Lainnya', Icons.more_horiz)),
                  ],
                ),
                const SizedBox(height: 20),


                // ✅ Pengaduan Section
                // ✅ Fixed Pengaduan Section (no more overflow)
                const Text(
                  'Pengaduan',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  // Increased height for longer text + flexibility
                  height: 220,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const [
                      PengaduanCard('assets/images/foto_dummy_1.jpg'),
                      PengaduanCard('assets/images/foto_dummy_2.jpg'),
                      PengaduanCard('assets/images/foto_dummy_3.png'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // ✅ Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Pemberitahuan'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

// ------------------------ COMPONENTS ------------------------

class TrendingCard extends StatelessWidget {
  final String imagePath;
  const TrendingCard(this.imagePath, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 70,
            child: Container(
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(16)),
                color: Colors.green.withOpacity(0.7),
              ),
              padding: const EdgeInsets.all(8),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Berita Terkini',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Lihat berita terbaru di daerah Anda',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class KategoriItem extends StatelessWidget {
//   final String title;
//   final IconData icon;
//   const KategoriItem(this.title, this.icon, {super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 80,
//       margin: const EdgeInsets.only(right: 12),
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               border: Border.all(color: Colors.green),
//             ),
//             child: Icon(icon, color: Colors.green, size: 28),
//           ),
//           const SizedBox(height: 6),
//           Text(title, style: const TextStyle(color: Colors.grey)),
//         ],
//       ),
//     );
//   }
// }
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
  final String imagePath;
  const PengaduanCard(this.imagePath, {super.key});

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
              CircleAvatar(radius: 20, backgroundImage: AssetImage(imagePath)),
              const SizedBox(width: 8),
              const Text('Neymar', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Pengaduan ODGJ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Saya mohon Bapak/Ibu dapat menindaklanjuti laporan ini dengan segera. '
            'Kami berharap ODGJ ini dapat segera ditangani sehingga ketertiban '
            'dan keamanan lingkungan dapat terjaga.',
            style: TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}
