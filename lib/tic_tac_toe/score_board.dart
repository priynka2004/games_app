import 'package:flutter/material.dart';

class ScoreBoard extends StatelessWidget {
  static const textstyling =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  var score1 ;
  var score2 ;
  ScoreBoard(this.score1,this.score2);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * .3,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround, 
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,

              children: <Widget>[

                const Text(
                  'Player 1',
                  style: textstyling,
                ),
                //Score
                Text(score1.toString(),style: textstyling,),
              ],
            ),
            SizedBox(width: 8,),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                const Text('Player 2', style: textstyling),
                //Score
                Text(score2.toString(),style: textstyling,),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
