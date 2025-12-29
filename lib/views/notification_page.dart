import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/notification_model.dart';
import '../services/notification_service.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  Future<String?> _getUserNik() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return doc.data()?['nik'] as String?;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pemberitahuan'),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<String?>(
        future: _getUserNik(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final userNik = userSnapshot.data;

          if (userNik == null) {
             return const Center(child: Text('Nomer NIK tidak ditemukan.'));
          }

          return StreamBuilder<List<NotificationModel>>(
            stream: NotificationService().getNotifications(userNik),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Tidak ada pemberitahuan'));
              }

              final notifications = snapshot.data!;
              return ListView.separated(
                itemCount: notifications.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final item = notifications[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: item.isRead ? Colors.grey[300] : Colors.green[100],
                      child: Icon(Icons.notifications_active, 
                       color: item.isRead ? Colors.grey : Colors.green),
                    ),
                    title: Text(
                      item.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          item.time,
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.body,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await NotificationService().deleteNotification(item.id);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Notifikasi dihapus')),
                          );
                        }
                      },
                    ),
                  );
                },
              );
            },
          );
        }
      ),
    );
  }
}
