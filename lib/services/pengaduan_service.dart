import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../model/pengaduan_model.dart';

class PengaduanService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  
  String _collectionFromKategori(String kategori) {
    return 'pengaduan_$kategori';
  }

  // Fetch Public Complaints (Realtime)
  Stream<List<PengaduanModel>> getPublicComplaints() {
    return _firestore
        .collection('pengaduan') 
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => PengaduanModel.fromFirestore(doc))
          .toList();
    });
  }

  // Fetch My History
  Stream<List<PengaduanModel>> getMyHistory() {
    return getPublicComplaints();
  }

  Future<String> uploadFoto(File file) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final ref = _storage.ref().child('pengaduan').child('$fileName.jpg');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  Future<void> submitPengaduan(PengaduanModel model) async {
    // 1. Submit to specific category collection (Remote logic)
    final collection = _collectionFromKategori(model.kategori);
    await _firestore.collection(collection).add(model.toMap());
    
    // 2. Submit to general 'pengaduan' collection (Local/Dashboard logic)
    // This duplicates data but ensures both views work until refactored.
    await _firestore.collection('pengaduan').add(model.toMap()); 
  }
}
