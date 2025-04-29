import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.notifications, color: Colors.blue),
            title: Text('Notifications'),
            subtitle: Text('Manage notification preferences'),
          ),
          ListTile(
            leading: Icon(Icons.lock, color: Colors.blue),
            title: Text('Privacy'),
            subtitle: Text('Privacy settings'),
          ),
        ],
      ),
    );
  }
}
