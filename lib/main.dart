import 'package:bullseye/control.dart';
import 'package:bullseye/gamemodel.dart';
import 'package:bullseye/score.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'prompt.dart';
import 'dart:math';

void main() => runApp(BullsEyeApp());

class BullsEyeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    return MaterialApp(
      title: 'BullsEye',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: GamePage(title: 'Bullseye'),
    );
  }
}

class GamePage extends StatefulWidget {
  GamePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  bool _alertIsVisible = false;
  GameModel _model;
  @override
  void initState() {
    super.initState();
    _model = GameModel(newTargetValue());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              image: AssetImage('images/background.png'), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              /*Text('Hello BullsEye',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.green))*/
              Prompt(targetValue: _model.target),
              Control(
                model: _model,
              ),
              TextButton(
                child: Text("Hit Me!"),
                onPressed: () {
                  _showAlert(context);
                },
              ),
              Score(
                totalScore: _model.totalScore,
                round: _model.round,
                onStartOver: startNewGame,
              )
            ],
          ),
        ),
      ),
    );
  }

  int newTargetValue() => Random().nextInt(100) + 1;

  int sliderValue() => _model.current;

  int _pointsForCurrentRound() {
    int maximumScore = 100;
    return (maximumScore - amountOff() + bonus());
  }

  int amountOff() => (_model.target - sliderValue()).abs();

  int bonus() {
    if (amountOff() == 0) {
      return 100;
    } else if (amountOff() == 1) {
      return 50;
    } else {
      return 0;
    }
  }

  void startNewGame() {
    setState(() {
      _model.totalScore = GameModel.SCORE_START;
      _model.round = GameModel.ROUND_START;
      _model.current = GameModel.SLIDER_START;
      _model.target = newTargetValue();
    });
  }

  void _showAlert(BuildContext context) {
    Widget okButton = TextButton(
        child: Text('Awesome'),
        onPressed: () {
          Navigator.of(context).pop();
          this._alertIsVisible = false;
          setState(() {
            this._alertIsVisible = true;
            _model.totalScore += (_pointsForCurrentRound());
            _model.target = newTargetValue();
            _model.round += 1;
          });
        });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(alertTitle()),
          content: Text('You Hit ${sliderValue()}.\n' +
              'You Scored ${_pointsForCurrentRound()} this round.'),
          actions: <Widget>[okButton],
          elevation: 5,
        );
      },
    );
  }

  String alertTitle() {
    String title;
    if (amountOff() == 0) {
      title = 'Perfect!';
    } else if (amountOff() <= 5) {
      title = 'Woah! That was close';
    } else if (amountOff() <= 10) {
      title = 'You almost had it';
    } else {
      title = 'Brah!You even trying?';
    }
    return title;
  }
}
