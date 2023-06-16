import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tubesuts/screens/profile_page.dart';

import 'screens/HomePage.dart';
import 'screens/LoginPage.dart';
import 'screens/SignupPage.dart';
import 'widgets/navbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Polls App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      routes: {
        '/home': (context) => BottomNavigation(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
      },
      initialRoute: '/login',
    );
  }
}
