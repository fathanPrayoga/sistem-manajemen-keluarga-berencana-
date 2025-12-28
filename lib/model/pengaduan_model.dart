import 'package:cloud_firestore/cloud_firestore.dart';

class PengaduanModel {
  final String? id;
  final String kategori;
  final String nama;
  final String nik;
  final String noHp;
  final String alamat;
  final String keluhan;
  final String? imageUrl;
  final String status;
  final DateTime createdAt;

  PengaduanModel({
    this.id,
    required this.kategori,
    required this.nama,
    required this.nik,
    required this.noHp,
    required this.alamat,
    required this.keluhan,
    this.imageUrl,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'kategori': kategori,
      'nama': nama,
      'nik': nik,
      'no_hp': noHp,
      'alamat': alamat,
      'keluhan': keluhan,
      'image_url': imageUrl,
      'status': status,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }

  factory PengaduanModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PengaduanModel(
      id: doc.id,
      kategori: data['kategori'] ?? '',
      nama: data['nama'] ?? '',
      nik: data['nik'] ?? '',
      noHp: data['no_hp'] ?? '',
      alamat: data['alamat'] ?? '',
      keluhan: data['keluhan'] ?? '',
      imageUrl: data['image_url'],
      status: data['status'] ?? 'menunggu',
      createdAt: (data['created_at'] as Timestamp).toDate(),
    );
  }
}
