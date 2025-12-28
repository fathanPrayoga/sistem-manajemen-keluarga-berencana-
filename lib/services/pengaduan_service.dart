import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/pengaduan_model.dart';

class PengaduanService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch Public Complaints (Realtime)
  Stream<List<PengaduanModel>> getPublicComplaints() {
    return _firestore
        .collection('pengaduan')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => PengaduanModel.fromFirestore(doc))
          .toList();
    });
  }

  // Fetch My History
  // Currently returns the same public stream until Auth filters are implemented
  Stream<List<PengaduanModel>> getMyHistory() {
    return getPublicComplaints();
  }
}
