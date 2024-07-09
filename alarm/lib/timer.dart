import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async' as async;
import 'lists.dart';

Lists list = Lists();
List<DropdownMenuItem<int>> getDropDownItems(int max) {
  List<DropdownMenuItem<int>> dropDownItems = [];
  for (int i = 0; i < max; i++) {
    var newItem = DropdownMenuItem(
      child: Text(i.toString()),
      value: i,
    );
    dropDownItems.add(newItem);
  }
  return dropDownItems;
}

class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  int dropDownValue = list.hour.first as int;
  int dropDownMinuteValue = list.minutes.first as int;
  int dropDownSecondsValue = list.seconds.first as int;
  async.Timer? timer;
  bool isRunning = false;
  final player = AudioPlayer();

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    if (!isRunning) {
      timer = async.Timer.periodic(Duration(seconds: 1), (async.Timer timer) {
        setState(() {
          if (dropDownSecondsValue > 0) {
            dropDownSecondsValue--;
          } else if (dropDownMinuteValue > 0) {
            dropDownMinuteValue--;
            dropDownSecondsValue = 59;
          } else if (dropDownValue > 0) {
            dropDownValue--;
            dropDownMinuteValue = 59;
            dropDownSecondsValue = 59;
          } else {
            timer.cancel();
            isRunning = false;
            playRingtone();
          }
        });
      });
      isRunning = true;
    }
  }

  void playRingtone() async {
    bool isDialogShowing = true;

    final player = AudioPlayer();

    Future<void> repeatRingtone() async {
      try {
        await player.play(AssetSource('assets/sound/TF013.WAV'));
        await Future.delayed(Duration(seconds: 2));
        if (isDialogShowing) {
          repeatRingtone();
        }
      } catch (e) {
        print('Error playing sound: $e');
      }
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Timer'),
          content: Text('Time is up!'),
          actions: [
            TextButton(
              onPressed: () {
                isDialogShowing = false;
                player.stop();
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );

    repeatRingtone();
  }

  void pauseTimer() {
    if (isRunning) {
      timer?.cancel();
      isRunning = false;
    }
  }

  void resetTimer() {
    timer?.cancel();
    setState(() {
      dropDownValue = list.hour.first as int;
      dropDownMinuteValue = list.minutes.first as int;
      dropDownSecondsValue = list.seconds.first as int;
      isRunning = false;
    });
  }

  Widget getColumn(int maxIndex, String text, int dropdownvalue,
      ValueChanged<int?> onChanged) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),
        ),
        DropdownButton<int>(
          menuMaxHeight: 100.0,
          elevation: 0,
          value: dropdownvalue,
          items: getDropDownItems(maxIndex),
          onChanged: onChanged,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            'Timer',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w200),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${dropDownValue.toString()} : '),
              SizedBox(width: 5.0),
              Text('${dropDownMinuteValue.toString()} : '),
              SizedBox(width: 5.0),
              Text(dropDownSecondsValue.toString()),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              getColumn(99, 'Hours', dropDownValue, (value) {
                setState(() {
                  dropDownValue = value ?? dropDownValue;
                });
              }),
              getColumn(60, 'Minutes', dropDownMinuteValue, (value) {
                setState(() {
                  dropDownMinuteValue = value ?? dropDownMinuteValue;
                });
              }),
              getColumn(60, 'Seconds', dropDownSecondsValue, (value) {
                setState(() {
                  dropDownSecondsValue = value ?? dropDownSecondsValue;
                });
              }),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: startTimer,
                icon: Icon(Icons.play_arrow),
              ),
              IconButton(
                onPressed: pauseTimer,
                icon: Icon(Icons.pause),
              ),
              IconButton(
                onPressed: resetTimer,
                icon: Icon(Icons.restart_alt_sharp),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
