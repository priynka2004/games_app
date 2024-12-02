import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:games_app/snakes_game/game_over.dart';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with TickerProviderStateMixin {
  int _playerScore = 0;
  bool _hasStarted = true;
  late Animation<double> _snakeAnimation;
  late AnimationController _snakeController;
  final List<int> _snake = [404, 405, 406, 407];
  final int _noOfSquares = 500;
  final Duration _duration = const Duration(milliseconds: 250);
  final int _squareSize = 20;
  String _currentSnakeDirection = 'RIGHT';
  late int _snakeFoodPosition;
  final Random _random = Random();

  Timer? _gameTimer;
  Duration _elapsedTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    _setUpGame();
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    _snakeController.dispose();
    super.dispose();
  }

  void _setUpGame() {
    _playerScore = 0;
    _currentSnakeDirection = 'RIGHT';
    _hasStarted = true;
    _elapsedTime = Duration.zero;

    do {
      _snakeFoodPosition = _random.nextInt(_noOfSquares);
    } while (_snake.contains(_snakeFoodPosition));

    _snakeController = AnimationController(vsync: this, duration: _duration);
    _snakeAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _snakeController);
  }

  void _startGameTimer() {
    _gameTimer?.cancel();  // Cancel any previous timer if running
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedTime += const Duration(seconds: 1);
      });
    });
  }

  void _stopGameTimer() {
    _gameTimer?.cancel();
  }

  void _gameStart() {
    _startGameTimer();  // Start timer
    Timer.periodic(_duration, (Timer timer) {
      _updateSnake();
      if (_hasStarted) timer.cancel();
    });
  }

  bool _gameOver() {
    for (int i = 0; i < _snake.length - 1; i++) {
      if (_snake.last == _snake[i]) return true;
    }
    return false;
  }

  void _updateSnake() {
    if (!_hasStarted) {
      setState(() {
        _playerScore = (_snake.length - 4) * 100;

        switch (_currentSnakeDirection) {
          case 'DOWN':
            if (_snake.last + _squareSize > _noOfSquares) {
              _snake.add(
                  _snake.last + _squareSize - (_noOfSquares + _squareSize));
            } else {
              _snake.add(_snake.last + _squareSize);
            }
            break;
          case 'UP':
            if (_snake.last < _squareSize) {
              _snake.add(
                  _snake.last - _squareSize + (_noOfSquares + _squareSize));
            } else {
              _snake.add(_snake.last - _squareSize);
            }
            break;
          case 'RIGHT':
            if ((_snake.last + 1) % _squareSize == 0) {
              _snake.add(_snake.last + 1 - _squareSize);
            } else {
              _snake.add(_snake.last + 1);
            }
            break;
          case 'LEFT':
            if (_snake.last % _squareSize == 0) {
              _snake.add(_snake.last - 1 + _squareSize);
            } else {
              _snake.add(_snake.last - 1);
            }
        }

        if (_snake.last != _snakeFoodPosition) {
          _snake.removeAt(0);
        } else {
          do {
            _snakeFoodPosition = _random.nextInt(_noOfSquares);
          } while (_snake.contains(_snakeFoodPosition));
        }

        if (_gameOver()) {
          _stopGameTimer();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) => GameOver(
                  score: _playerScore,
                  time: _elapsedTime,
                )),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: Text(
          'CT SnakeGame',
          style: GoogleFonts.lato(
            textStyle: Theme.of(context).textTheme.displayLarge,
            fontSize: 20,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.italic,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.redAccent,
        actions: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Score: $_playerScore',
                style: GoogleFonts.lato(
                  textStyle: Theme.of(context).textTheme.displayLarge,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                'Time: ${_elapsedTime.inMinutes}:${(_elapsedTime.inSeconds % 60).toString().padLeft(2, '0')}',
                style: GoogleFonts.lato(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.redAccent,
          elevation: 20,
          label: Text(
            _hasStarted ? 'Start' : 'Pause',
            style: GoogleFonts.lato(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          onPressed: () {
            setState(() {
              if (_hasStarted) {
                _snakeController.forward();
              } else {
                _snakeController.reverse();
                _stopGameTimer();
              }
              _hasStarted = !_hasStarted;
              _gameStart();
            });
          },
          icon: AnimatedIcon(
              icon: AnimatedIcons.play_pause, progress: _snakeAnimation, color: Colors.white),
        ),
      ),
      body: Center(
        child: GestureDetector(
          onVerticalDragUpdate: (drag) {
            if (drag.delta.dy > 0 && _currentSnakeDirection != 'UP') {
              _currentSnakeDirection = 'DOWN';
            } else if (drag.delta.dy < 0 && _currentSnakeDirection != 'DOWN')
              _currentSnakeDirection = 'UP';
          },
          onHorizontalDragUpdate: (drag) {
            if (drag.delta.dx > 0 && _currentSnakeDirection != 'LEFT') {
              _currentSnakeDirection = 'RIGHT';
            } else if (drag.delta.dx < 0 && _currentSnakeDirection != 'RIGHT')
              _currentSnakeDirection = 'LEFT';
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: GridView.builder(
              itemCount: _squareSize + _noOfSquares,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _squareSize),
              itemBuilder: (BuildContext context, int index) {
                return Center(
                  child: Container(
                    color: Colors.white,
                    padding: _snake.contains(index)
                        ? const EdgeInsets.all(1)
                        : const EdgeInsets.all(0),
                    child: ClipRRect(
                      borderRadius:
                      index == _snakeFoodPosition || index == _snake.last
                          ? BorderRadius.circular(7)
                          : _snake.contains(index)
                          ? BorderRadius.circular(2.5)
                          : BorderRadius.circular(1),
                      child: Container(
                        color: _snake.contains(index)
                            ? Colors.black
                            : index == _snakeFoodPosition
                            ? Colors.green
                            : Colors.blue,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
