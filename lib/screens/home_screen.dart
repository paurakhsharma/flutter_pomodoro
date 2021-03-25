import 'dart:async';

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _pomodoroTime;
  Duration _time;
  Timer _timer;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final children = [
      Expanded(
        child: Container(
          constraints: BoxConstraints.expand(),
          padding: const EdgeInsets.all(28.0),
          color: Colors.orangeAccent,
          child: CircularPercentIndicator(
            radius: 300,
            percent: _pomodoroTime != null
                ? 1 -
                    (_time?.inSeconds ??
                            Duration(minutes: _pomodoroTime).inSeconds) /
                        Duration(minutes: _pomodoroTime).inSeconds
                : 0,
            lineWidth: 15,
            backgroundWidth: 20,
            progressColor: Colors.greenAccent,
            backgroundColor: Colors.white,
            center: Text(
              formatTime(_time),
              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            circularStrokeCap: CircularStrokeCap.round,
          ),
        ),
      ),
      Expanded(
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: _time == null
                    ? () {
                        _time = Duration(minutes: _pomodoroTime);
                        _timer = Timer.periodic(Duration(seconds: 1), (timer) {
                          _time = Duration(seconds: _time.inSeconds - 1);
                          if (_time.inSeconds == 0) {
                            _time = null;
                            _timer.cancel();
                          }
                          setState(() {});
                        });
                      }
                    : null,
                child: Text(
                  'START',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 40,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _time != null
                    ? () {
                        _timer?.cancel();
                        _time = null;
                        setState(() {});
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  primary: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 40,
                  ),
                ),
                child: Text(
                  'STOP',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      )
    ];
    return Scaffold(
      body: width > 800
          ? Row(
              children: children,
            )
          : Column(
              children: children,
            ),
    );
  }

  String formatTime(Duration d) {
    if (_pomodoroTime == null) return '00:00';

    if (d == null) {
      d = Duration(minutes: _pomodoroTime);
    }
    return d.toString().split('.').first.substring(2);
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      _pomodoroTime = await _showMyDialog();
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<int> _showMyDialog() async {
    int pomodoroTime;
    return showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Set Pomodoro Time'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  onChanged: (value) {
                    pomodoroTime = int.tryParse(value);
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                if (pomodoroTime == null) return;
                Navigator.of(context).pop(pomodoroTime);
              },
            ),
          ],
        );
      },
    );
  }
}
