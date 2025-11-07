import 'package:flutter/material.dart';
import '../widget/bottom_navbar.dart';
import '../style/colors.dart';
import '../style/text_style.dart';
import 'pengaduan.dart';

class KategoriPengaduanPage extends StatelessWidget {
  const KategoriPengaduanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> kategoriList = [
      {
        'title': 'Pengaduan Bantuan Sosial (Bansos)',
        'icon': Icons.volunteer_activism,
      },
      {
        'title': 'Pengaduan Layanan Anak dan Keluarga',
        'icon': Icons.family_restroom,
      },
      {
        'title': 'Pengaduan Terkait Lansia dan Disabilitas',
        'icon': Icons.elderly,
      },
      {'title': 'Pengaduan Bencana Sosial', 'icon': Icons.warning},
      {'title': 'Pengaduan Kesehatan Mental', 'icon': Icons.psychology},
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.background),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Laporkan Keluhan Anda',
          style: AppTextStyles.headline1,
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.background,
        centerTitle: true,
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: kategoriList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemBuilder: (context, index) {
            final kategori = kategoriList[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PengaduanPage(kategori: kategori['title']),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.textLight.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(kategori['icon'], color: AppColors.primary, size: 40),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        kategori['title'],
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyText.copyWith(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
