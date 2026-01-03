import 'package:flutter/material.dart';

import '../style/colors.dart';
import '../style/text_style.dart';
import '../model/kategori_pengaduan.dart';
import 'pengaduan.dart';

class KategoriPengaduanPage extends StatelessWidget {
  const KategoriPengaduanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<KategoriPengaduan> kategoriList = const [
      KategoriPengaduan(
        id: 'bansos',
        title: 'Pengaduan Bantuan Sosial (Bansos)',
        icon: Icons.volunteer_activism,
      ),
      KategoriPengaduan(
        id: 'anak',
        title: 'Pengaduan Layanan Anak dan Keluarga',
        icon: Icons.family_restroom,
      ),
      KategoriPengaduan(
        id: 'lansia',
        title: 'Pengaduan Terkait Lansia dan Disabilitas',
        icon: Icons.elderly,
      ),
      KategoriPengaduan(
        id: 'bencana',
        title: 'Pengaduan Bencana Sosial',
        icon: Icons.warning,
      ),
      KategoriPengaduan(
        id: 'mental',
        title: 'Pengaduan Kesehatan Mental',
        icon: Icons.psychology,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Laporkan Keluhan Anda',
          style: AppTextStyles.headline1,
        ),
        backgroundColor: AppColors.primary,
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: kategoriList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemBuilder: (context, index) {
            final kategori = kategoriList[index];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PengaduanPage(kategori: kategori.id),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(kategori.icon, size: 40, color: AppColors.primary),
                    const SizedBox(height: 12),
                    Text(
                      kategori.title,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyText.copyWith(fontSize: 14),
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
