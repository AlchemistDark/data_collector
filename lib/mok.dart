import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp( // a material app is the root of any Flutter app
      title: 'Stopwatch',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Stopwatch'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Timer? _timer; // the timer that controls to increment the counter once a second
  int _countedSeconds = 0; // how many seconds have been counted so far, initialises to zero
  Duration timedDuration = Duration.zero; // the duration of the timer so far, initialises to zero
  bool _timerRunning = false; // the state of whether the timer is running or not
  // final lapTimes = <Duration>[]; // can you figure out how to add a lap timer?

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void startTimer() {
    _timerRunning = true; // set the timer state to running
    _timer?.cancel(); // if there's a timer running already, cancel it
    _countedSeconds = 0; // restart the timer
    _timer = Timer.periodic(Duration(seconds: 1), (timer) { // callback
      setState(() {
        _countedSeconds++; // every second, increment the counted seconds
        print(_countedSeconds); // print out how many seconds have been counted so far
        timedDuration = Duration(seconds: _countedSeconds); // update the total duration of the stopwatch so far
      });
    });
  }

  void stopTimer() { // stop the timer
    _timerRunning = false; // set the state of the timer running to false
    _timer?.cancel(); // cancel the running timer, so the callback stops firing
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Stack(
          fit: StackFit.loose,
          alignment: Alignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: AspectRatio(
                child: CircularProgressIndicator(
                  // backgroundColor: Colors.black,
                  strokeWidth: 20,
                  // Below, we work out the progress for the circular progress indicator
                  // We do so by getting the total amount of seconds so far, and then
                  // we use the .remainder function to get only the seconds component of the
                  // current minute being counted. We then divide it by 60 to work out how far
                  // through the progress should be (so, 30 would be 0.5, or 50% of a minute)
                  value: _countedSeconds.remainder(60) / 60,
                ),
                aspectRatio: 1,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  timedDuration.inMinutes.toString(),
                  style: Theme.of(context).textTheme.headline1!.copyWith(
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Text(
                  ":",
                  style: Theme.of(context).textTheme.headline2,
                ),
                Text(
                  timedDuration.inSeconds.remainder(60).toString().padLeft(2, '0'),
                  style: Theme.of(context).textTheme.headline1,
                ),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_timerRunning) {
            setState(() {
              stopTimer();
            });
          } else {
            setState(() {
              startTimer();
            });
          }
        },
        // onPressed: _incrementCounter,
        child: Icon(_timerRunning ? Icons.pause : Icons.play_arrow),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
