import 'package:flutter/material.dart';
import '../model/notification_model.dart';
import '../services/notification_service.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pemberitahuan'),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<List<NotificationModel>>(
        stream: NotificationService().getNotifications(),
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
                  style: TextStyle(
                    fontWeight: item.isRead ? FontWeight.normal : FontWeight.bold,
                  ),
                ),
                subtitle: Text(item.body),
                trailing: Text(
                  item.time,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
