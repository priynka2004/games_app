import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';
import 'dart:async';

class ChessGameScreen extends StatefulWidget {
  const ChessGameScreen({super.key});

  @override
  State<ChessGameScreen> createState() => _ChessGameScreenState();
}

class _ChessGameScreenState extends State<ChessGameScreen> {
  final ChessBoardController controller = ChessBoardController();
  late Timer _timer;
  final Stopwatch _stopwatch = Stopwatch();
  Duration _elapsedTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _stopwatch.start();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedTime = _stopwatch.elapsed;
      });
    });
  }

  void _stopTimer() {
    _stopwatch.stop();
    _timer.cancel();
  }

  @override
  void dispose() {
    _stopTimer();
    controller.removeListener(() {});
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final String minutes = twoDigits(duration.inMinutes.remainder(60));
    final String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Chess Game",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Display Elapsed Time
          Text(
            'Time Elapsed: ${_formatDuration(_elapsedTime)}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          // Chess Board
          Expanded(
            child: Center(
              child: ChessBoard(
                controller: controller,
                boardColor: BoardColor.darkBrown,
                boardOrientation: PlayerColor.white,
                onMove: () {
                  // Optional: Handle move logic if needed
                },
                enableUserMoves: true,
                // Optional: Add arrows or other board features
                // arrows: [
                //   BoardArrow(from: "b2", to: "b4", color: Colors.red.withOpacity(0.9))
                // ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(
          _stopwatch.isRunning ? Icons.pause : Icons.play_arrow,
          color: Colors.white,
        ),
        onPressed: () {
          setState(() {
            if (_stopwatch.isRunning) {
              _stopTimer();
            } else {
              _startTimer();
            }
          });
        },
      ),
    );
  }
}
