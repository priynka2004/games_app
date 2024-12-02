import 'package:flutter/material.dart';

class DialogueBoxes extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback callback;
  final String actionText;

   DialogueBoxes(
      this.title,
      this.content,
      this.callback, [
        this.actionText = 'Reset Game',
      ]);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: callback,
          child: GestureDetector(onTap:(){
            Navigator.pop(context);
          },child: Text(actionText)),
        )
      ],
    );
  }
}
