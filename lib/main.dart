import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamsyncai/providers/chatroom_provider.dart';
import 'package:teamsyncai/providers/subscription_provider.dart';
import 'package:teamsyncai/providers/trialCard_provider.dart';
import 'package:teamsyncai/providers/userprovider.dart';
import 'package:teamsyncai/screens/launch_screen.dart';
import 'package:teamsyncai/screens/login_screen.dart';
import 'package:teamsyncai/screens/home.dart';
import 'package:teamsyncai/screens/register.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:device_preview/device_preview.dart'; // Import DevicePreview package
import 'package:teamsyncai/providers/ChangeNotifierProvider.dart';
import 'package:flutter/foundation.dart';
import 'package:teamsyncai/screens/web/LoginWebPage.dart';
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatroomProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ImageProvider()), 
        ChangeNotifierProvider(create: (_) => SubscriptionProvider()),
        ChangeNotifierProvider(create: (_) => TrialCardProvider()), //// Add ImageProvider here
      ],
      child: MyApp(),
    ),
  );
}
class ImageProvider extends ChangeNotifier {
  // Your image-related logic and state management methods will go here
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: MyAppContent(), // Use MyAppContent instead of HomePage
    );
  }
}

class MyAppContent extends StatefulWidget {
  @override
  _MyAppContentState createState() => _MyAppContentState();
}

class _MyAppContentState extends State<MyAppContent> {
  bool _isDarkModeEnabled = false;

  void _toggleDarkMode(bool value) {
    setState(() {
      _isDarkModeEnabled = value;
    });
  }

   @override
   Widget build(BuildContext context) {
    print('kIsWeb: $kIsWeb'); 
    return MaterialApp(
      title: 'TeamSyncai',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: kIsWeb ? LoginWebPage() : LaunchScreen(), 
      routes: {
        '/login': (context) => SignInPage(),
        '/register': (context) => register(),
      },
    );
  }
}
