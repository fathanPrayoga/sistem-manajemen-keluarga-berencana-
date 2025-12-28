import 'package:cloud_firestore/cloud_firestore.dart';

class PengaduanModel {
  final String id;
  final String kategori;
  final String fullname;
  final String nik;
  final String phone;
  final String address;
  final String description; // Combined 'description' or 'keluhan'
  final String imageUrl; // Proof image
  final String status; // 'pending', 'processed', 'done', 'rejected'
  final DateTime timestamp;

  // Constructor
  PengaduanModel({
    required this.id,
    required this.kategori,
    required this.fullname,
    required this.nik,
    required this.phone,
    required this.address,
    required this.description,
    required this.imageUrl,
    required this.status,
    required this.timestamp,
  });

  // Helper to get user friendly status
  String get statusText {
    switch (status) {
      case 'pending':
        return 'Menunggu';
      case 'processed':
        return 'Diproses';
      case 'done':
        return 'Selesai';
      case 'rejected':
        return 'Ditolak';
      default:
        return 'Menunggu';
    }
  }

  // Factory to create from Firestore Document
  factory PengaduanModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return PengaduanModel(
      id: doc.id,
      kategori: data['kategori'] ?? '',
      fullname: data['fullname'] ?? 'Anonim',
      nik: data['nik'] ?? '',
      phone: data['phone'] ?? '',
      address: data['address'] ?? '',
      // Prioritize 'keluhan' if 'description' is empty/null, based on admin findings
      description: data['description'] ?? data['keluhan'] ?? '', 
      imageUrl: data['imageUrl'] ?? '',
      status: data['status'] ?? 'pending',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
