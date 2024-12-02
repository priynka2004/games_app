import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:games_app/tic_tac_toe/score_board.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/game_button.dart';
import 'dialoque_box.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late List<Game_Button> buttonList;
  int? gameStyle;
  List<int> player1 = [];
  List<int> player2 = [];
  int currentPlayer = 1;
  int score1 = 0, score2 = 0;
  int winner = -1;
  int tie = 0;
  int countdown = 30;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    buttonList = doInit();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (countdown > 0) {
        setState(() => countdown--);
      } else {
        timer?.cancel();
        setState(() {
          for (var button in buttonList) {
            button.enabled = false;
          }
        });
        _showDialog('Time’s up!', content: 'Reset the game to play again.');
      }
    });
  }


  List<Game_Button> doInit() {
    player1.clear();  // Clear player 1's moves
    player2.clear();  // Clear player 2's moves
    currentPlayer = 1;  // Set Player 1 as the first player for the new game
    countdown = 30;  // Reset countdown timer
    return List.generate(9, (index) => Game_Button(id: index + 1,
        text: '', enabled: true, bg: Colors.transparent));
  }


  void resetGame() {
    setState(() {
      // Cancel the current timer and reset everything
      timer?.cancel();
      buttonList = doInit();  // Reinitialize button list (resets text and enabled flag)
      winner = -1;
      tie = 0;
      startTimer();  // Start the timer for the next game
    });
  }



  void checkWinner() {
    if (player1.length >= 3 || player2.length >= 3) {
      if (_checkWinningCondition(player1)) {
        setState(() {
          score1++; // Increase Player 1's score
          _showDialog('Player 1 Won');
        });
      } else if (_checkWinningCondition(player2)) {
        setState(() {
          score2++; // Increase Player 2's score
          _showDialog('Player 2 Won');
        });
      } else if (buttonList.every((p) => p.text.isNotEmpty)) {
        _showDialog('Tie', content: 'The game is a tie');
      } else if (currentPlayer == 2 && gameStyle == 1) {
        // Call autoPlay only if it's Man vs Computer
        autoPlay();
      }
    }
  }


  bool _checkWinningCondition(List<int> player) {
    const winningCombos = [
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
      [1, 4, 7],
      [2, 5, 8],
      [3, 6, 9],
      [1, 5, 9],
      [3, 5, 7],
    ];
    return winningCombos
        .any((combo) => combo.every((element) => player.contains(element)));
  }

  void _showDialog(String title, {String content = 'Reset to start the game again'}) {
    timer?.cancel();  // Cancel the timer
    setState(() {
      // Disable all buttons after the game ends
      for (var button in buttonList) {
        button.enabled = false;
      }
    });

    showDialog(
      context: context,
      barrierDismissible: false,  // Prevent dismissing the dialog by tapping outside
      builder: (_) => DialogueBoxes(
        title,
        content,
        resetGame,  // Call resetGame to reset the game state when the dialog is dismissed
      ),
    );
  }

  void autoPlay() {
    var emptyCells = List<int>.generate(9, (i) => i + 1)
        .where((cell) => !player1.contains(cell) && !player2.contains(cell))
        .toList();

    if (emptyCells.isEmpty) return;

    var rand = Random();
    int cellNo = emptyCells[rand.nextInt(emptyCells.length)];
    buttonPressed(buttonList.firstWhere((p) => p.id == cellNo));
    checkWinner();
  }


  void buttonPressed(Game_Button gb) {
    setState(() {
      if (gb.enabled) {
        gb.text = currentPlayer == 1 ? 'X' : 'O'; // Set correct player icon
        gb.bg = currentPlayer == 1
            ? Theme.of(context).primaryColor
            : Theme.of(context).colorScheme.secondary;
        (currentPlayer == 1 ? player1 : player2).add(gb.id); // Add move to the current player's list
        currentPlayer = 3 - currentPlayer; // Switch player after the move
        gb.enabled = false; // Disable the button after the move
        checkWinner(); // Check if there's a winner after the move

        // If Man vs Computer and Computer's turn, auto-play
        if (currentPlayer == 2 && gameStyle == 1) {
          Future.delayed(const Duration(milliseconds: 500), autoPlay);
        }
      }
    });
  }



  Widget buildGameButton(Game_Button button) {
    return ElevatedButton(
      onPressed: button.enabled ? () => buttonPressed(button) : null, // Disable if not enabled
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(10),
        backgroundColor: button.bg, // Set background color depending on the player
      ),
      child: Center(
        child: button.text.isNotEmpty
            ? ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Image.asset(
            button.text == 'X'
                ? 'assets/x-png-35414.png' // Player 1 icon
                : 'assets/pngimg.com - number0_PNG19156.png', // Player 2 icon
          ),
        )
            : const Text(''), // Empty text when no icon is set
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)?.settings.arguments as Map<String, int>;
    gameStyle = routeArgs['gamesstyle']!;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'CT Tic Tac Toe',
              style: GoogleFonts.aboreto(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                const Icon(Icons.timer, size: 20, color: Colors.black),
                const SizedBox(width: 5),
                Text(
                  '$countdown',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ],
        ),
      ),

      body: Column(
        children: <Widget>[
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              padding: const EdgeInsets.all(10),
              itemCount: buttonList.length,
              itemBuilder: (context, index) => buildGameButton(buttonList[index]),
            ),
          ),
          ScoreBoard(score1, score2),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.all(15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: resetGame,
              child: const Text(
                'RESET THE GAME',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
