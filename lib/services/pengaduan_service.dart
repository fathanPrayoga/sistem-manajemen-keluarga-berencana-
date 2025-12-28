import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../model/pengaduan_model.dart';

class PengaduanService {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  String _collectionFromKategori(String kategori) {
    return 'pengaduan_$kategori';
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
