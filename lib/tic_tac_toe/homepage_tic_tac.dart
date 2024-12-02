import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:games_app/auth/google/google_service.dart';
import 'package:games_app/auth/mail/ui/login_screen.dart';
import 'landing_page.dart';

class HomePageTicTacToe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios)),
        title:  Text('CT    Tic Tac Toe',style: GoogleFonts.aboreto(
        fontWeight: FontWeight.bold,
        ),),
      ),
      body:Center(child: LandingPage()),

    );
  }
}