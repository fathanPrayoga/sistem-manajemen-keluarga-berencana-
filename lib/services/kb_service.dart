import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/kb_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = 'pendaftaran_kb';

  Future<void> addPendaftaran(KbModel data) async {
    await _firestore.collection(collectionName).add(data.toJson());
  }

  Future<List<KbModel>> getPendaftaran(String userId) async {
    QuerySnapshot snapshot = await _firestore
        .collection(collectionName)
        .where('userId', isEqualTo: userId)
        .orderBy('created_at', descending: true)
        .get();
    return snapshot.docs.map((doc) {
      return KbModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  Future<void> updatePendaftaran(String id, KbModel data) async {
    await _firestore.collection(collectionName).doc(id).update(data.toJson());
  }

  Future<void> deletePendaftaran(String id) async {
    await _firestore.collection(collectionName).doc(id).delete();
  }
}
