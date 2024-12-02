import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:games_app/auth/google/google_service.dart';
import 'package:games_app/auth/mail/ui/login_screen.dart';
import 'package:games_app/home_screen.dart';

class GoogleLoginScreen extends StatefulWidget {
  const GoogleLoginScreen({super.key});

  @override
  State<GoogleLoginScreen> createState() => _GoogleLoginScreenState();
}

class _GoogleLoginScreenState extends State<GoogleLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.pink,
            Colors.blue,
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            child: ElevatedButton(
              onPressed: () async {
                await FirebaseService().signInWithGoogle();
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return HomeScreen();
                }));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/download.png',
                      width: 40,
                      height: 40,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'Login with Gmail',
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}



