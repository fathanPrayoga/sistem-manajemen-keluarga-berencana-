import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../model/pengaduan_model.dart';

import 'package:async/async.dart';

class PengaduanService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final List<String> _collections = [
    'pengaduan_bansos',
    'pengaduan_anak',
    'pengaduan_lansia',
    'pengaduan_bencana',
    'pengaduan_mental',
  ];

  String _collectionFromKategori(String kategori) {
    return 'pengaduan_$kategori';
  }

  // Fetch Public Complaints (Realtime) - Combined from all categories
  Stream<List<PengaduanModel>> getPublicComplaints() {
    final streams = _collections.map((collection) {
      return _firestore
          .collection(collection)
          .orderBy('created_at', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs
                .map((doc) => PengaduanModel.fromFirestore(doc))
                .toList();
          });
    });

    return StreamZip(streams).map((lists) {
      final allComplaints = lists.expand((e) => e).toList();
      allComplaints.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return allComplaints;
    });
  }

  // Fetch My History (Verified by NIK) - Combined from all categories
  Stream<List<PengaduanModel>> getMyHistory(String nik) {
    final streams = _collections.map((collection) {
      return _firestore
          .collection(collection)
          .where('nik', isEqualTo: nik)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs
                .map((doc) => PengaduanModel.fromFirestore(doc))
                .toList();
          });
    });

    return StreamZip(streams).map((lists) {
      final allComplaints = lists.expand((e) => e).toList();
      allComplaints.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return allComplaints;
    });
  }

  Future<String> uploadFoto(File file) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final ref = _storage.ref().child('pengaduan').child('$fileName.jpg');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  Future<void> submitPengaduan(PengaduanModel model) async {
    final collection = _collectionFromKategori(model.kategori);
    await _firestore.collection(collection).add(model.toMap());
  }
}
