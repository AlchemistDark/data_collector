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
    if(_currentIndex > 69) {
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
    final double distance = areaWidth / 6;
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
                        child: TableScreen(list[_currentIndex], distance)
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
  final double distance;

  late final int xScale;
  late final int yScale;
  late final double xDistance;
  late final double yDistance;

  TableScreen(
    this.indexes,
    this.distance,
    {Key? key}
  ) : super(key: key) {
    xScale = (indexes[0] - 1);
    yScale = (indexes[1] - 1);
    switch(xScale){
      case 0:
        xDistance = 0;
        break;
      case 6:
        xDistance = (distance * xScale - 14);
        break;
      default:
        xDistance = (distance * xScale - 7);
    }
    switch(yScale){
      case 0:
        yDistance = 0;
        break;
      case 9:
        yDistance = (distance * yScale - 14);
        break;
      default:
        yDistance = (distance * yScale - 7);
    }
  }

  Widget table(List<int> indexes){
    return Text('');
  }

  @override
  Widget build(BuildContext context) {
    return Container (
      margin: EdgeInsets.only(left: xDistance, top: yDistance),
      child: CustomPaint(
        size: const Size(14, 14),
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


