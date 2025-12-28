import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String time; // Formatted time string
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.isRead,
  });

  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    // Timestamp handling
    Timestamp? ts = data['timestamp'] ?? data['created_at'];
    String formattedTime = '';
    if (ts != null) {
      formattedTime = _formatTimeAgo(ts.toDate());
    } else {
      formattedTime = 'Baru saja';
    }

    return NotificationModel(
      id: doc.id,
      title: data['title'] ?? 'Pemberitahuan',
      body: data['body'] ?? '',
      time: formattedTime,
      isRead: data['is_read'] ?? false,
    );
  }

  static String _formatTimeAgo(DateTime date) {
    Duration diff = DateTime.now().difference(date);
    if (diff.inDays > 0) {
      return '${diff.inDays} hari yang lalu';
    } else if (diff.inHours > 0) {
      return '${diff.inHours} jam yang lalu';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes} menit yang lalu';
    } else {
      return 'Baru saja';
    }
  }
}
