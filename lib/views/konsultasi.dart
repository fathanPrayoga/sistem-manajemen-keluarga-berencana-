import 'package:flutter/material.dart';
import '../style/colors.dart';
import '../style/text_style.dart';
import 'package:app_pengaduan/views/chat_konsultasi_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:app_pengaduan/viewmodels/auth_provider.dart' as custom_auth;

class KonsultasiPage extends StatelessWidget {
  const KonsultasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primary,
        elevation: 0,
        toolbarHeight: 50,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                print('Tombol Kembali ditekan');
              },
              child: const Icon(
                Icons.arrow_back,
                color: AppColors.background,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              'KONSULTASI',
              style: AppTextStyles.headline1.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.background,
              ),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(height: 40, color: AppColors.primary),

            Transform.translate(
              offset: const Offset(0, -30),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Consumer<custom_auth.AuthProvider>(
                      builder: (context, authProvider, child) {
                        final userName =
                            authProvider.currentUserData?.name ?? 'Pengguna';
                        return GreetingCard(userName: userName);
                      },
                    ),
                    const SizedBox(height: 20),

                    _buildCardWithStream(
                      context,
                      'Konsultasi Keluarga Berencana',
                      'assets/images/konsultasi_keluarga_berencana.png',
                      'kb',
                    ),
                    const SizedBox(height: 16),
                    _buildCardWithStream(
                      context,
                      'Konsultasi Psikologi',
                      'assets/images/konsultasi_psikolog.png',
                      'psikologi',
                    ),
                    const SizedBox(height: 16),
                    _buildCardWithStream(
                      context,
                      'Konsultasi Parenting',
                      'assets/images/konsultasi_parenting.png',
                      'parenting',
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardWithStream(
    BuildContext context,
    String title,
    String imagePath,
    String categoryId,
  ) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return ConsultationCard(
        title: title,
        imagePath: imagePath,
        onTap: () => _navigateToChat(context, title, categoryId),
      );
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('konsultasi')
          .doc(categoryId)
          .collection('chats')
          .doc(userId)
          .snapshots(),
      builder: (context, snapshot) {
        int badgeCount = 0;
        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data() as Map<String, dynamic>?;
          if (data != null) {
            badgeCount = data['unreadCountUser'] as int? ?? 0;
          }
        }

        return ConsultationCard(
          title: title,
          imagePath: imagePath,
          badgeCount: badgeCount,
          onTap: () => _navigateToChat(context, title, categoryId),
        );
      },
    );
  }

  void _navigateToChat(BuildContext context, String title, String categoryId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ChatKonsultasiPage(title: title, categoryId: categoryId),
      ),
    );
  }
}

class GreetingCard extends StatelessWidget {
  final String userName;

  const GreetingCard({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.secondary,
            child: Text(
              (userName.isNotEmpty) ? userName[0].toUpperCase() : '?',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SELAMAT SIANG ${userName.toUpperCase()}',
                  style: AppTextStyles.bodyText.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                  overflow:
                      TextOverflow.ellipsis, // Potong teks jika terlalu panjang
                  maxLines: 2, // Maksimal 2 baris
                ),
                const SizedBox(height: 4),
                Text(
                  'Apakah anda baik-baik saja?',
                  style: AppTextStyles.caption.copyWith(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ConsultationCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;
  final int badgeCount;

  const ConsultationCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onTap,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          height: 120,
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: AppColors.primaryLight, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
                  color: AppColors.secondary.withOpacity(0.3),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.secondary.withOpacity(0.5),
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          textAlign: TextAlign.left,
                          style: AppTextStyles.headline2.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      if (badgeCount > 0)
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            badgeCount > 99 ? '99+' : badgeCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
