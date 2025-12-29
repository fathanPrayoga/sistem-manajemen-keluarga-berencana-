import 'package:cloud_firestore/cloud_firestore.dart';

class KonsultasiService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Stream messages for a specific consultation category
  Stream<QuerySnapshot> messagesStream(String categoryId) {
    return _firestore
        .collection('konsultasi')
        .doc(categoryId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots();
  }

  /// Send a message and also write a notification doc for server-side FCM
  Future<void> sendMessage(
    String categoryId,
    String userId,
    String userName,
    String text,
  ) async {
    final messagesRef = _firestore
        .collection('konsultasi')
        .doc(categoryId)
        .collection('messages');

    await messagesRef.add({
      'senderId': userId,
      'senderName': userName,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // update meta info for the consultation room (store timestamp and increment admin unread)
    await _firestore.collection('konsultasi').doc(categoryId).set({
      'lastMessage': text,
      'lastMessageTime': FieldValue.serverTimestamp(),
      'lastUpdated': FieldValue.serverTimestamp(),
      'lastSenderId': userId,
      'userName': userName,
      'unreadCountAdmin': FieldValue.increment(1),
    }, SetOptions(merge: true));

    // Create a notification entry that a Cloud Function / admin backend can listen to and send FCM
    await _firestore.collection('notifications').add({
      'type': 'konsultasi_message',
      'categoryId': categoryId,
      'title': userName,
      'body': text,
      'fromUserId': userId,
      'created_at': FieldValue.serverTimestamp(),
    });
  }
}
