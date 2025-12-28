import 'package:flutter/material.dart';
import '../services/pengaduan_service.dart';
import '../model/pengaduan_model.dart';
import 'dashboard.dart'; // To reuse PengaduanCard (or we can extract it)

class RiwayatPage extends StatelessWidget {
  const RiwayatPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pengaduan'),
        automaticallyImplyLeading: false, // Hide back button if using navbar
      ),
      body: StreamBuilder<List<PengaduanModel>>(
        stream: PengaduanService().getMyHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada riwayat pengaduan'));
          }

          final history = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: history.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: PengaduanCard(pengaduan: history[index]),
              );
            },
          );
        },
      ),
    );
  }
}
