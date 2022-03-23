import 'package:flutter/material.dart';

class Score extends StatelessWidget {
  final int totalScore;
  final int round;
  final VoidCallback onStartOver;
  Score(
      {Key key,
      @required this.totalScore,
      @required this.round,
      @required this.onStartOver})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextButton(child: Text('Start Over'), onPressed: () => onStartOver()),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text('Score:$totalScore'),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text('Round: $round'),
            ],
          ),
        ),
        TextButton(
          child: Text('Info'),
          onPressed: () => print('Pressed Info'),
        )
      ],
    );
  }
}
