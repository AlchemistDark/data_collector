import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Background extends StatelessWidget {

  final double areaWidth;
  final double areaHeight;

  const Background({
    required this.areaWidth,
    required this.areaHeight,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
        break;
      default:
        _xDistance = (xDistance * xScale);
    }
    switch(yScale){
      case 0:
        _yDistance = 0;
        break;
      default:
        _yDistance = (yDistance * yScale);
    }
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


