import 'package:flutter/material.dart';
import 'package:games_app/auth/google/google_service.dart';
import 'package:games_app/chess/chess_home_page.dart';
import 'package:games_app/sudoku/homepage.dart';
import 'package:games_app/sudoku/sudoku_game_page.dart';
import 'package:games_app/tic_tac_toe/homepage_tic_tac.dart';
import 'auth/mail/ui/login_screen.dart';
import 'snakes_game/home_page.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late BannerAd _bannerAd;
  bool _isBannerAdLoaded = false;

  final List<String> gameNames = [
    'Snake Game',
    'Chess Game',
    'Tic Tac Toe',
    'Sudoku',
  ];

  final List<Widget> gameScreens = [
    const HomePage(),
    const ChessHomePage(),
    HomePageTicTacToe(),
    const SudokuHomePage(),
  ];

  final List<String> gameImages = [
    'assets/img.png',
    'assets/img_1.png',
    'assets/img_3.png',
    'assets/img_2.png',
  ];

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      size: AdSize.largeBanner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('Failed to load a banner ad: ${error.message}');
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Game Hub",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseService().signOut();
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const LoginScreen();
              }));
            },
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                itemCount: gameNames.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return gameScreens[index];
                          }));
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [
                            Colors.blueAccent.withOpacity(0.2),
                            Colors.cyan.withOpacity(0.2),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueAccent.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(-5, -5),
                          ),
                          BoxShadow(
                            color: Colors.cyan.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(5, 5),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: -20,
                            left: -20,
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.blueAccent.withOpacity(0.1),
                            ),
                          ),
                          Positioned(
                            bottom: -20,
                            right: -20,
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.cyan.withOpacity(0.1),
                            ),
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  gameImages[index],
                                  width: 60,
                                  height: 60,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  gameNames[index],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          if (_isBannerAdLoaded)
            SizedBox(
              height: _bannerAd.size.height.toDouble(),
              width: _bannerAd.size.width.toDouble(),
              child: AdWidget(ad: _bannerAd),
            ),
        ],
      ),
    );
  }

}
