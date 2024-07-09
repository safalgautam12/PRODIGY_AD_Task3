import 'package:flutter/material.dart';
import 'lists.dart';
import 'timer.dart';
import 'dart:async' as async;

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

class AlarmPage extends StatefulWidget {
  const AlarmPage({super.key});

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alarm'),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          navigationBarTheme: NavigationBarThemeData(
            indicatorColor: Colors.blueGrey,
          ),
        ),
        child: NavigationBar(
          onDestinationSelected: (int value) {
            setState(() {
              currentIndex = value;
            });
          },
          indicatorColor: Colors.teal.shade200,
          selectedIndex: currentIndex,
          destinations: <Widget>[
            NavigationDestination(
              icon: Icon(
                Icons.alarm,
              ),
              label: 'alarm',
            ),
            NavigationDestination(
                icon: ImageIcon(
                  AssetImage('assets/icons/timer.png'),
                ),
                label: 'stopWatch'),
            NavigationDestination(icon: Icon(Icons.timer), label: 'timer'),
          ],
        ),
      ),
      body: _getBodyForIndex(currentIndex, Theme.of(context)),
    );
  }
}

Widget _getBodyForIndex(int currentIndex, ThemeData theme) {
  switch (currentIndex) {
    case 0:
      return alarm();
    case 1:
      return stopWatchPage();
    case 2:
      return TimerPage();
    default:
      return alarm();
  }
}

Widget alarm() {
  return Center(
    child: Text('Alarm'),
  );
}

class StopWatchPage extends StatefulWidget {
  @override
  _StopWatchPageState createState() => _StopWatchPageState();
}

class _StopWatchPageState extends State<StopWatchPage> {
  async.Timer? timer;
  int milliseconds = 0;
  bool isRunning = false;
  List<String> lapTimes = [];

  void startStopwatch() {
    if (!isRunning) {
      timer = async.Timer.periodic(Duration(milliseconds: 10), (async.Timer timer) {
        setState(() {
          milliseconds += 10;
        });
      });
      isRunning = true;
    }
  }

  void stopStopwatch() {
    if (isRunning) {
      setState(() {
        lapTimes.add(formatTime(milliseconds));
        timer?.cancel();
        isRunning = false;
      });
    }
  }

  void resetStopwatch() {
    timer?.cancel();
    setState(() {
      milliseconds = 0;
      isRunning = false;
      lapTimes.clear();
    });
  }

  String formatTime(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();// to remove floating point value
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();

    int displayMilliseconds = hundreds % 100;
    int displaySeconds = seconds % 60;
    int displayMinutes = minutes % 60;

    return '${displayMinutes.toString().padLeft(2, '0')}:${displaySeconds.toString().padLeft(2, '0')}:${displayMilliseconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Stopwatch',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w200),
          ),
          Text(
            formatTime(milliseconds),
            style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: startStopwatch,
                icon: Icon(Icons.play_arrow),
              ),
              IconButton(
                onPressed: stopStopwatch,
                icon: Icon(Icons.pause),
              ),
              IconButton(
                onPressed: resetStopwatch,
                icon: Icon(Icons.restart_alt_sharp),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: lapTimes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Lap ${index + 1}'),
                  subtitle: Text(lapTimes[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget stopWatchPage() {
  return StopWatchPage();
}
