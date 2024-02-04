import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kampus_connect/auth/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kampus_connect/pages/article_slide.dart';
import 'package:kampus_connect/pages/event.dart';
import 'package:kampus_connect/pages/feed_page.dart';
import 'package:kampus_connect/pages/home.dart';
import 'package:kampus_connect/pages/login.dart';
import 'package:kampus_connect/pages/onboarding.dart';
import 'package:kampus_connect/pages/profile.dart';
import 'package:kampus_connect/pages/register.dart';
import 'package:kampus_connect/pages/role.dart';
import 'package:kampus_connect/pages/room_list.dart';
import 'package:kampus_connect/pages/room_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: GoogleFonts.montserrat(fontWeight: FontWeight.w500).fontFamily),
      title: 'Kampus Connect',
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
      initialRoute: '/',
        routes: {
          '/home': (context) => const HomeScreen(),
          '/login': (context) => const LoginPage(),
          '/signup': (context) => const RegisterPage(),
        }
    );
  }

  
}
