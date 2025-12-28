import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/notification_model.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream of Notifications
  // TODO: Add userId filter when auth is ready: .where('user_id', isEqualTo: uid)
  Stream<List<NotificationModel>> getNotifications() {
    return _firestore
        .collection('notifications') // Assumed collection name
        .orderBy('created_at', descending: true) // Assumed field
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => NotificationModel.fromFirestore(doc))
          .toList();
    });
  }
}
