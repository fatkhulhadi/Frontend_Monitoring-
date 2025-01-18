import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifikasi'),
        centerTitle: true,
        backgroundColor: Colors.blue[100],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            return _buildNotificationCard(notifications[index]);
          },
        ),
      ),
    );
  }

  Widget _buildNotificationCard(Notification notification) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      child: ListTile(
        leading: Icon(notification.icon, color: Colors.blue),
        title: Text(notification.title),
        subtitle: Text(notification.message),
        trailing: Text(notification.time),
        onTap: () {
          // Tindakan saat notifikasi ditekan
          print('Tapped on notification: ${notification.title}');
        },
      ),
    );
  }
}

// Contoh data notifikasi
class Notification {
  final String title;
  final String message;
  final String time;
  final IconData icon;

  Notification({
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
  });
}

// Daftar notifikasi contoh
final List<Notification> notifications = [
  Notification(
    title: 'Notifikasi 1',
    message: 'Anda memiliki 3 tugas baru.',
    time: '2 menit yang lalu',
    icon: Icons.notifications,
  ),
  Notification(
    title: 'Notifikasi 2',
    message: 'Jadwal rapat pada pukul 10:00.',
    time: '1 jam yang lalu',
    icon: Icons.event,
  ),
  Notification(
    title: 'Notifikasi 3',
    message: 'Anda telah mendapatkan umpan balik.',
    time: '3 jam yang lalu',
    icon: Icons.feedback,
  ),
  Notification(
    title: 'Notifikasi 4',
    message: 'Pembayaran berhasil.',
    time: '1 hari yang lalu',
    icon: Icons.payment,
  ),
];