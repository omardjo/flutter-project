import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teamsyncai/screens/EditProfile.dart';
import 'package:teamsyncai/screens/StillToCome%20.dart';
import 'package:teamsyncai/screens/home.dart';
import 'package:teamsyncai/screens/login_screen.dart';
import 'package:teamsyncai/screens/Identification.dart';
import 'package:teamsyncai/screens/Notifications.dart';
import 'package:teamsyncai/screens/screenrec/recType.dart';
import 'package:teamsyncai/screens/select_plan.dart';

class Profile extends StatefulWidget {
  final String email;

  const Profile({required this.email});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? _image;
  
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredAccountSettings = [];

  void _navigateToReports(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SubscriptionScreen()));
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _filteredAccountSettings = _accountSettings;
    _searchController.addListener(() {
      _filterAccountSettings(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterAccountSettings(String query) {
    setState(() {
      _filteredAccountSettings = _accountSettings
          .where((item) => item['title'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => home(email: widget.email)),
          (route) => false,
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Account Settings',
        
          ),
          backgroundColor: Colors.white,
          elevation: 15,
          iconTheme: const IconThemeData(color: Colors.black38),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
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
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: _image != null
                                ? Image.file(
                                    _image!,
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                          ),
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
               /* FloatingActionButton(
                  onPressed: () {
                    _showEditProfileBottomSheet(context);
                  },
                  backgroundColor: Colors.orange,
                  child: const Icon(Icons.edit, color: Colors.white),
                ),*/

                const SizedBox(height: 20.0),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),

                const SizedBox(height: 20.0),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _filteredAccountSettings.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 3,
                      shadowColor: Colors.orange.withOpacity(0.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                      child: ListTile(
                        title: Text(
                          _filteredAccountSettings[index]['title'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Icon(_filteredAccountSettings[index]['icon'], color: Colors.orange),
                        onTap: () => _handleAccountSettingTap(context, _filteredAccountSettings[index]['title']),
                      ),
                    );
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
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInPage()));
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

 /* void _showEditProfileBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return EditProfile();
      },
    );
  }*/

  void _handleAccountSettingTap(BuildContext context, String title) {
    switch (title) {
      case 'Identification':
        Navigator.push(context, MaterialPageRoute(builder: (context) => Identification()));
        break;
      case 'Notifications':
        Navigator.push(context, MaterialPageRoute(builder: (context) => Notifications()));
        break;
      case 'Report a problem':
        Navigator.push(context, MaterialPageRoute(builder: (context) => RecTypeScreen(email: widget.email)));
        break;
      case 'Upgrade your Plan':
        _navigateToReports(context);
        break;
     
    }
  }
}

List<Map<String, dynamic>> _accountSettings = [
  {'title': 'Identification', 'icon': Icons.save_as_sharp},
  {'title': 'Notifications', 'icon': Icons.notifications},
  {'title': 'Report a problem', 'icon': Icons.privacy_tip},
  {'title': 'Upgrade your Plan', 'icon': Icons.article},
];