import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:camera/camera.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'package:data_collector/background.dart';
import 'package:data_collector/session_class.dart';

class CalibrationPage extends StatefulWidget {
  final CalibrationSession session;
  final List<List<int>> list;

  final CameraDescription camera;
  const CalibrationPage({
    required this.session,
    required this.list,
    required this.camera,
    Key? key
  }) : super(key: key);

  @override
  State<CalibrationPage> createState() => _CalibrationPageState(session.screenTime, session.photoTime);
}

class _CalibrationPageState extends State<CalibrationPage> {

  bool stop = false;
  Timer? _timer;
  int _currentIndex = 0;
  int _photoIndex = 0;
  Duration timedDuration = Duration.zero;
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  int photoCount = 0;
  int listIndex = 0;
  int photoNum = 0;
  final double screenTime;
  final double photoTime;

  _CalibrationPageState(this.screenTime, this.photoTime){
    // photoNum хранить сколько фото должно быть сделано пока показывается один крестик.
    // Как только это количество будет сделано, отрисовывается новый.
    photoNum = screenTime ~/ photoTime;
  }

  String _getName(){
    String gen;
    switch(widget.session.gender){
      case Gender.male:
        gen = 'муж';
        break;
      case Gender.female:
        gen = 'жен';
        break;
    }
    String model;
    switch(widget.session.phoneModel){
      case PhoneModel.redmy:
        model = 'Redmy';
        break;
      case PhoneModel.sony:
        model = 'Sony';
        break;
      case PhoneModel.samsung:
        model = 'Samsung';
        break;
    }
    String dist;
    switch(widget.session.distance) {
      case Distance.x15:
        dist = '15см';
        break;
      case Distance.x30:
        dist = '30см';
        break;
    }
    String _mode = (_currentIndex < 6)? 'по порядку' : 'случайно';
    String _position;
    switch(widget.session.crossMarksPosition) {
      case CrossMarksPosition.center:
        _position = 'по центру';
        break;
      case CrossMarksPosition.edge:
        _position = 'по цуглам';
        break;
    }
    String xFactor;
    String yFactor;
    List<int> factors = widget.list[_currentIndex];
    switch(factors[1]) {
      case 1:
        xFactor = 'A';
        break;
      case 2:
        xFactor = 'B';
        break;
      default:
        xFactor = 'Err';
        break;
    }
    switch(factors[0]) {
      case 1:
        yFactor = '1';
        break;
      case 2:
        yFactor = '2';
        break;
      case 3:
        yFactor = '3';
        break;
      default:
        yFactor = 'Err';
        break;
    }
    String result = 'калибровка_${widget.session.number}_${gen}_${model}_${dist}_${widget.session.screenTime}_${widget.session.photoTime.toStringAsPrecision(2)}_${_position}_${_mode}_$xFactor${yFactor}_${_currentIndex}_$_photoIndex';
    return result;
  }

  void startTimer() {
    _timer?.cancel();
    _photoIndex++; // Этот счтётчик считает сколько всего было сделано фото.
    if(_currentIndex > (widget.list.length - 1)) { // Этот оператор останавливает работу функции.
      _controller.dispose();
      stop = true;
      return;
    }
    int duration = (widget.session.photoTime * 1000).round(); // Задержка в миллисекундах.
    _timer = Timer.periodic(Duration(milliseconds: duration), (timer) async{

      try {
        await _initializeControllerFuture;
        final image = await _controller.takePicture();
        await ImageGallerySaver.saveImage(
            await image.readAsBytes(),
            name: _getName()

        );
      } catch(e){}

      if (photoCount < photoNum) {
        setState(() {
          photoCount++;
        });
      } else {
        photoCount = 0;
        _currentIndex++;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
    if (widget.session.autoFocusEnable!){
      _controller.setFocusMode(FocusMode.auto);
    } else {
      _controller.setFocusMode(FocusMode.locked);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double mainWidth = MediaQuery.of(context).size.width;
    final double areaWidth = mainWidth - 24; // two indents of 12 px.
    final double areaHeight = areaWidth * 1.5;

    startTimer();
    List list = widget.list;
    print(list);
    return Scaffold(
      body: Stack(
        children: [
          if(!stop)
            Container(
              margin: const EdgeInsets.only(left: 12.0, top: 55.0, right: 12.0),
              child: Stack(
                children: [
                  if (widget.session.showBackground!)
                    Background(
                      areaWidth: areaWidth,
                      areaHeight: areaHeight
                    ),
                  Column(
                    children: [
                      Center(
                        child: SizedBox(
                          width: areaWidth,
                          height: areaHeight,
                          child: TableScreen(
                            indexes: list[_currentIndex],
                            position: widget.session.crossMarksPosition,
                            areaWidth: areaWidth,
                            areaHeight: areaHeight
                          )
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
  final CrossMarksPosition position;
  final double areaWidth;
  final double areaHeight;

  late final double xDistance;
  late final double yDistance;
  late final int xScale;
  late final int yScale;
  late final double _xDistance;
  late final double _yDistance;

  TableScreen({
    required this.indexes,
    required this.position,
    required this.areaWidth,
    required this.areaHeight,
    Key? key
  }) : super(key: key) {
    xScale = (indexes[1] - 1);
    yScale = (indexes[0] - 1);
    print("индексес ${indexes}");
    switch(position){
      case CrossMarksPosition.center:
        switch(xScale){
          case 0:
            _xDistance = (areaWidth / 4) - 10;
            break;
          case 1:
            _xDistance = (areaWidth / 4 * 3) - 10;
            break;
          default:
            _xDistance = areaWidth - 20;
        }
        switch(yScale){
          case 0:
            _yDistance = (areaHeight / 6) - 10;
            break;
          case 1:
            _yDistance = (areaHeight / 2) - 10;
            break;
          case 2:
            _yDistance = (areaHeight / 6 * 5) - 10;
            break;
          default:
            _yDistance = areaHeight - 20;
        }
        break;
      case CrossMarksPosition.edge:
        switch(xScale){
          case 0:
            _xDistance = 0;
            break;
          case 1:
            _xDistance = areaWidth - 20;
            break;
          default:
            _xDistance = areaWidth - 20;
        }
        switch(yScale){
          case 0:
            _yDistance = 0;
            break;
          case 1:
            _yDistance = (areaHeight - 20) / 2;
            break;
          case 2:
            _yDistance = areaHeight - 20;
            break;
          default:
            _yDistance = areaHeight - 20;
        }
        break;
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


