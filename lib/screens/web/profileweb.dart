import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teamsyncai/screens/login_screen.dart';

class Profileweb extends StatefulWidget {
  final String email;

  const Profileweb({required this.email});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profileweb> {
  Uint8List? _imageBytes;
  bool _isDarkMode = false;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = Uint8List.fromList(bytes);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
        backgroundColor: Colors.white,
        elevation: 15,
        iconTheme: const IconThemeData(color: Colors.black38),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: GestureDetector(
                onTap: () {
                  _pickImage(ImageSource.gallery);
                },
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      if (_imageBytes != null)
                        Image.memory(
                          _imageBytes!,
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        )
                      else
                        const Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            for (final setting in _accountSettings)
              ListTile(
                title: Text(
                  setting['title'] as String,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Icon(setting['icon'] as IconData?, color: Colors.orange),
                onTap: () => _handleAccountSettingTap(context, setting['title'] as String),
              ),
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: _isDarkMode,
              onChanged: (value) {
                setState(() {
                  _isDarkMode = value;
                });
              },
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _showLogoutDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.exit_to_app, // Change icon to exit icon
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(width: 10), // Add some spacing between icon and text
                  Text(
                    'Exit', // Change text to 'Exit'
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Log out logic here
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _handleAccountSettingTap(BuildContext context, String title) {
    switch (title) {
      case 'Identification':
        // Navigate to identification screen
        break;
      case 'Notifications':
        // Navigate to notifications screen
        break;
      case 'Report a problem':
        // Navigate to report a problem screen
        break;
      case 'Reports':
        // Navigate to reports screen
        break;
      case 'Still to come':
        // Navigate to still to come screen
        break;
    }
  }
}

final _accountSettings = [
  {'title': 'Identification', 'icon': Icons.save_as_sharp},
  {'title': 'Notifications', 'icon': Icons.notifications},
  {'title': 'Report a problem', 'icon': Icons.privacy_tip},
  {'title': 'Reports', 'icon': Icons.article},
  {'title': 'Still to come', 'icon': Icons.more_horiz},
];