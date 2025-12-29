import 'package:flutter/material.dart';
import '../style/colors.dart';
import '../style/text_style.dart';
import '../widget/bottom_navbar.dart';
import 'package:app_pengaduan/views/chat_konsultasi_page.dart';

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
                    const GreetingCard(userName: 'neymar'),
                    const SizedBox(height: 20),

                    ConsultationCard(
                      title: 'Konsultasi Keluarga Berencana',
                      imagePath:
                          'assets/images/konsultasi_keluarga_berencana.png',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatKonsultasiPage(
                              title: 'Konsultasi Keluarga Berencana',
                              categoryId: 'kb',
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    ConsultationCard(
                      title: 'Konsultasi Psikologi',
                      imagePath: 'assets/images/konsultasi_psikolog.png',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatKonsultasiPage(
                              title: 'Konsultasi Psikologi',
                              categoryId: 'psikologi',
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    ConsultationCard(
                      title: 'Konsultasi Parenting',
                      imagePath: 'assets/images/konsultasi_parenting.png',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatKonsultasiPage(
                              title: 'Konsultasi Parenting',
                              categoryId: 'parenting',
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),
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
          const CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage('assets/images/user_profile.png'),
            backgroundColor: AppColors.secondary,
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SELAMAT SIANG ${userName.toUpperCase()}',
                style: AppTextStyles.bodyText.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Apakah anda baik-baik saja?',
                style: AppTextStyles.caption.copyWith(fontSize: 14),
              ),
            ],
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

  const ConsultationCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onTap,
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
                  child: Image.asset(imagePath, fit: BoxFit.cover),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Center(
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
