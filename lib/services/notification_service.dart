import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/notification_model.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream of Notifications
  // Stream of Notifications
  // Filter by recipientNik
  Stream<List<NotificationModel>> getNotifications(String nik) {
    return _firestore
        .collection('notifications')
        .where('recipientNik', isEqualTo: nik)
        // .orderBy('createdAt', descending: true) // Commented out to test Index issue
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => NotificationModel.fromFirestore(doc))
          .toList();
    });
  }

  // Create a Notification (For Admin / Testing)
  Future<void> sendNotification({
    required String nik,
    required String title,
    required String body,
  }) async {
    await _firestore.collection('notifications').add({
      'recipientNik': nik,
      'title': title,
      'body': body,
      'isRead': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
  Future<void> deleteNotification(String id) async {
    await _firestore.collection('notifications').doc(id).delete();
  }
}
