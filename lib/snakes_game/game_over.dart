import 'package:flutter/material.dart';
import 'package:games_app/snakes_game/game_page.dart';

class GameOver extends StatelessWidget {
  final int score;
  final Duration time;

  GameOver({
    required this.score,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.blue,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Game Over',
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 50.0,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                shadows: [
                  Shadow(
                    offset: Offset(-1.5, -1.5),
                    color: Colors.black,
                  ),
                  Shadow(
                    offset: Offset(1.5, -1.5),
                    color: Colors.black,
                  ),
                  Shadow(
                    offset: Offset(1.5, 1.5),
                    color: Colors.black,
                  ),
                  Shadow(
                    offset: Offset(-1.5, 1.5),
                    color: Colors.black,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50.0),
            Text(
              'Your Score is: $score',
              style: const TextStyle(color: Colors.white, fontSize: 20.0),
            ),
            const SizedBox(height: 20.0),
            Text(
              'Time Taken: ${time.inMinutes}:${(time.inSeconds % 60).toString().padLeft(2, '0')}',
              style: const TextStyle(color: Colors.white, fontSize: 20.0),
            ),
            const SizedBox(height: 50.0),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                backgroundColor: Colors.redAccent,
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => GamePage()),
                );
              },
              icon: const Icon(Icons.refresh, color: Colors.white, size: 30.0),
              label: const Text(
                "Try Again",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
