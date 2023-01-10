import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:data_collector/session_class.dart';

class SecondPage extends StatefulWidget {
  final Session session;
  final List<List<int>> list;

  const SecondPage({
    required this.session,
    required this.list,
    Key? key
  }) : super(key: key);

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  bool stop = false;

  Timer? _timer; // the timer that controls to increment the counter once a second
  int _currentIndex = 0; // how many seconds have been counted so far, initialises to zero
  Duration timedDuration = Duration.zero; // the duration of the timer so far, initialises to zero
  // final lapTimes = <Duration>[]; // can you figure out how to add a lap timer?



  void startTimer() {
    _timer?.cancel();
    if(_currentIndex == 120) {
      stop = true;
      return;
    }
    int duration = (widget.session.screenTime * 1000).round();
    print("duration $duration");
    _timer = Timer.periodic(Duration(milliseconds: duration), (timer) { // callback
      setState(() {
        _currentIndex++; // every second, increment the counted seconds
        print(_currentIndex); // print out how many seconds have been counted so far
        //timedDuration = Duration(seconds: _countedSeconds); // update the total duration of the stopwatch so far
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    startTimer();
    List list = widget.list;
    return Scaffold(
      body: Stack(
        children: [
          if(!stop)
          TableScreen(list[_currentIndex]),
          if(stop)
          const Center(
            child: Text(
              'Конец!',
              style: TextStyle(fontSize: 30),
            )
          )
        ],
      )
    );
  }
}


class TableScreen extends StatelessWidget {
  final List<int> indexes;

  const TableScreen(this.indexes, {Key? key}) : super(key: key);

  Widget table(List<int> indexes){
    return Text('');
  }

  @override
  Widget build(BuildContext context) {
    return
      Column(
      children: rows(indexes),
    );
  }

  List<Widget> rows(List<int> localIndexes){
    List<Widget> result = [];
    for (int i = 1; i < 16; i++) {
      bool isContent = (i == localIndexes[1]);
      result.add(
        Expanded(
          child: Row(
            children: cells(isContent, localIndexes)
          )
        )
      );
    }
    return result;
  }

  List<Widget> cells(bool isContent, List<int> localIndexes){
    List<Widget> result = [];
    for (int i = 1; i < 9; i++){
      bool localIsContent = ((i == localIndexes[0]) && isContent);
      result.add(Cell(localIsContent));
    }
    return result;
  }


}

class Cell extends StatelessWidget {

  bool isContent;

  Cell(this.isContent, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          if(isContent)
          Center(
            child: CustomPaint(
              size: const Size(14, 14),
              painter: CrossPainter()
            )
          )
        ]
      ),
    );
  }




}


class CrossPainter extends CustomPainter{

  @override
  void paint(Canvas canvas, Size size){

    final line = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawLine(
      const Offset(0.0, 7.0),
      const Offset(14.0, 7.0),
      line
    );
    canvas.drawLine(
      const Offset(7.0, 0.0),
      const Offset(7.0, 14.0),
      line
    );
  }

  @override
  bool shouldRepaint(CustomPainter old){
    return false;
  }
}


