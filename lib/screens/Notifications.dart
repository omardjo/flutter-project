import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamsyncai/providers/ChangeNotifier.dart';

class Notifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NotificationSettings(),
      child: NotificationsPage(),
    );
  }
}

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
         backgroundColor: Colors.orange,
          elevation: 15, 
          iconTheme: IconThemeData(color: Colors.black38),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Consumer<NotificationSettings>(
                builder: (context, settings, child) => _buildNotificationTile(
                  title: 'Push Notifications',
                  subtitle: 'Receive occasional push notifications from our application.',
                  value: settings.pushNotifications,
                  onChanged: (value) => settings.setPushNotifications(value),
                ),
              ),
              Consumer<NotificationSettings>(
                builder: (context, settings, child) => _buildNotificationTile(
                  title: 'Email Notifications',
                  subtitle: 'Receive email notifications from our marketing team about new features.',
                  value: settings.emailNotifications,
                  onChanged: (value) => settings.setEmailNotifications(value),
                ),
              ),
              Consumer<NotificationSettings>(
                builder: (context, settings, child) => _buildNotificationTile(
                  title: 'Location Services',
                  subtitle: 'Allow us to track your location to keep track of spending and keep you safe (optional).',
                  value: settings.locationServices,
                  onChanged: (value) => settings.setLocationServices(value),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 14.0, color: Colors.black54),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.orange,
        ),
      ),
    );
  }
}
