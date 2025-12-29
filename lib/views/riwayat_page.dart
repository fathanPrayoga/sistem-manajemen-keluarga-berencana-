import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/pengaduan_service.dart';
import '../model/pengaduan_model.dart';
import 'dashboard.dart'; 

class RiwayatPage extends StatelessWidget {
  const RiwayatPage({super.key});

  Future<String?> _getUserNik() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      return doc.data()?['nik'] as String?;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pengaduan'),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<String?>(
        future: _getUserNik(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
             return const Center(child: CircularProgressIndicator());
          }
          
          final userNik = userSnapshot.data;

          if (userNik == null) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Silakan lengkapi profil Anda (NIK) untuk melihat riwayat.'),
              ),
            );
          }

          return StreamBuilder<List<PengaduanModel>>(
            stream: PengaduanService().getMyHistory(userNik),
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
          );
        }
      ),
    );
  }
}
