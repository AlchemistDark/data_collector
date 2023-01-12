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
    if(_currentIndex > (widget.list.length - 1)) {
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
    final double mainWidth = MediaQuery.of(context).size.width;
    final double areaWidth = mainWidth - 24; // two indents of 12 px.
    final double areaHeight = areaWidth * 1.5;
    //final double distance = areaWidth / 6;

    double getXDistance(){
      int _matrixSize;
      switch (widget.session.size) {
        case MatrixSize.x5x7:
          _matrixSize = 4;
          break;
        case MatrixSize.x7x10:
          _matrixSize = 6;
          break;
        case MatrixSize.x9x13:
          _matrixSize = 8;
          break;
      }
      double result = ((areaWidth - 20) / _matrixSize);
      return result;
    }

    double getYDistance(){
      int _matrixSize;
      switch (widget.session.size) {
        case MatrixSize.x5x7:
          _matrixSize = 6;
          break;
        case MatrixSize.x7x10:
          _matrixSize = 9;
          break;
        case MatrixSize.x9x13:
          _matrixSize = 12;
          break;
      }
      double result = ((areaHeight - 20) / _matrixSize);
      print("result $result");
      return result;
    }


    startTimer();
    List list = widget.list;
    return Scaffold(
      body: Stack(
        children: [
          if(!stop)
          Container(
            margin: const EdgeInsets.only(left: 12.0, top: 55.0, right: 12.0),
            //color: Colors.red,
            child: Stack(
              children: [
                if (widget.session.showBackground!)
                Column(
                  children: [
                    Center(
                      child: SizedBox(
                        width: areaWidth,
                        height: areaHeight,
                        child: Column(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      color: Colors.tealAccent
                                    )
                                  ),
                                  Expanded(
                                    child: Container(
                                      color: Colors.limeAccent
                                    )
                                  )
                                ]
                              )
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      color: Colors.limeAccent
                                    )
                                  ),
                                  Expanded(
                                    child: Container(
                                      color: Colors.tealAccent
                                    )
                                  )
                                ]
                              )
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      color: Colors.tealAccent
                                    )
                                  ),
                                  Expanded(
                                    child: Container(
                                      color: Colors.limeAccent
                                    )
                                  )
                                ]
                              )
                            ),
                          ]
                        )
                      )
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.green,
                      )
                    ),
                  ]
                ),
                Column(
                  children: [
                    Center(
                      child: SizedBox(
                        width: areaWidth,
                        height: areaHeight,
                        child: TableScreen(list[_currentIndex], getXDistance(), getYDistance())
                      )
                    ),
                    Expanded(
                      child: Container(
                        width: areaWidth,
                      )
                    )
                  ]
                )
              ]
            )
          ),
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
  final double xDistance;
  final double yDistance;

  late final int xScale;
  late final int yScale;
  late final double _xDistance;
  late final double _yDistance;

  TableScreen(
    this.indexes,
    this.xDistance,
    this.yDistance,
    {Key? key}
  ) : super(key: key) {
    xScale = (indexes[0] - 1);
    yScale = (indexes[1] - 1);
    switch(xScale){
      case 0:
        _xDistance = 0;
        print('xScale $xScale');
        break;
      default:
        _xDistance = (xDistance * xScale);
        print('xScale $xScale');
    }
    switch(yScale){
      case 0:
        _yDistance = 0;
        break;
      default:
        _yDistance = (yDistance * yScale);
    }
  }

  Widget table(List<int> indexes){
    return Text('');
  }

  @override
  Widget build(BuildContext context) {
    return Container (
      margin: EdgeInsets.only(left: _xDistance, top: _yDistance),
      child: CustomPaint(
        size: const Size(20, 20),
        painter: CrossPainter()
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
      ..strokeWidth = 2.0;
    canvas.drawLine(
      const Offset(0.0, 10.0),
      const Offset(20.0, 10.0),
      line
    );
    canvas.drawLine(
      const Offset(10.0, 0.0),
      const Offset(10.0, 20.0),
      line
    );
  }

  @override
  bool shouldRepaint(CustomPainter old){
    return false;
  }
}


