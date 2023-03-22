import 'dart:async';
import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:data_collector/session_class.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

/// Контроллер для датчика наклона.

class ScreenController{

  final DemoSession session;
  final double backgroundPictureSize;
  final double focusMarkerSize;
  final CameraDescription camera;

  double tilt = -1;
  double distance = -1;
  int timerCount = 30;
  int frameNumber = 0;
  bool isStop = false;
  ScreenState screenState = ScreenState(-1, -1, 30, 0, false);

  int photoIndex = 1;

  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  late final List<List<double>> focusMarkerPaddingList;

  Stream<ScreenState> get positionState => _tiltStateCtrl.stream;
  final StreamController<ScreenState> _tiltStateCtrl = StreamController<ScreenState>.broadcast();

  ScreenController(
    this.session,
    this.backgroundPictureSize,
    this.focusMarkerSize,
    this.camera
  ){
    startPositionChange();
    focusMarkerPaddingList = getFocusMarkerPaddingList(backgroundPictureSize, focusMarkerSize);

    _controller = CameraController(camera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
    if (session.autoFocusEnable!){
      _controller.setFocusMode(FocusMode.auto);
    } else {
      _controller.setFocusMode(FocusMode.locked);
    }
  }

  String _getName(){
    String gen;
    switch(session.gender){
      case Gender.male:
        gen = 'муж';
        break;
      case Gender.female:
        gen = 'жен';
        break;
    }
    String model;
    switch(session.phoneModel){
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
    //   String dist;
    //   switch(widget.session.distance) {
    //     case Distance.x15:
    //       dist = '15см';
    //       break;
    //     case Distance.x30:
    //       dist = '30см';
    //       break;
    //   }
    String result = 'демо_${session.number}_${gen}_${model}_$photoIndex';
    return result;
  }

  Future<void> makePhoto() async{
    try {
      print('страт фото $photoIndex');
      await _initializeControllerFuture;
      final image = await _controller.takePicture();
      await ImageGallerySaver.saveImage(
        await image.readAsBytes(),
        name: _getName()
      );
      photoIndex++;
      print('конец фото $photoIndex');
    } catch(e){
      print('ошибка фото $photoIndex');
    }
  }

  Future<void> frameNumberUp(List list) async{
    print('запуск 2');
    Duration duration = const Duration(milliseconds: 100);
    for (int i = frameNumber; i < list.length; i++) {
      if (screenState.timerCount == 0) {
        frameNumber = i;
        await Future.delayed(duration, () {
          createNewFrameNumber(frameNumber);
          if (focusMarkerPaddingList[frameNumber][2] == 1){
            makePhoto();
          }
        });
      }
    }
    // isStop = true;
    // screenState = ScreenState(tilt, distance, 0, frameNumber, true);
    await Future.delayed(const Duration(milliseconds: 2000), () {
      stopApp();
    });
  }

  Future<void> countdown() async {
    Duration duration = const Duration(milliseconds: 1000);
    for (int i = 30; i >= 0; i--) {
      if (screenState.distance == 0 && screenState.tilt == 0) {
        await Future.delayed(duration, () {
          createNewTimerCount(i);
        });
      } else {
        await Future.delayed(duration, () {
          createNewTimerCount(30);
        });
      }
    }
    print('смена кадра');
    frameNumberUp(focusMarkerPaddingList);
  }

  Future<void> startPositionChange() async {
    Duration duration = const Duration(milliseconds: 100);
    for (int i = 270; i >= 0; i--) {
      await Future.delayed(duration, () {
        createNewTilt(i);
        if (screenState.tilt == 0 && screenState.distance == 0) {
          countdown();
        }
      });
    }
    for (int i = 270; i >= 0; i--) {
      await Future.delayed(duration, () {
        createNewDistance(i);
        if (screenState.tilt == 0 && screenState.distance == 0) {
          countdown();
        }
      });
    }
  }

  void stopApp (){
    isStop = true;
    screenState = ScreenState(tilt, distance, 0, frameNumber, true);
    _tiltStateCtrl.add(screenState);
    _controller.dispose();
    print("остановка");
  }

  void createNewFrameNumber (int number){
    screenState = ScreenState(0, 0, 0, number, false);
    _tiltStateCtrl.add(screenState);
    print("номер $number");
  }

  void createNewTimerCount (int count){
    screenState = ScreenState(0, 0, count, frameNumber, false);
    _tiltStateCtrl.add(screenState);
    print("счётчик $count");
  }

  void createNewTilt (int degreeCount){
    tilt = math.sin(math.pi / 180 * degreeCount);//((math.pi / 2 * 3) - (math.pi / 90 * degreeCount));
    screenState = ScreenState(tilt, distance, 30, frameNumber, false);
    _tiltStateCtrl.add(screenState);
    print("угол $tilt");
  }

  void createNewDistance (int distanceValue){
    distance = math.sin(math.pi / 180 * distanceValue);//((math.pi / 2 * 3) - (math.pi / 90 * distanceValue));
    screenState = ScreenState(tilt, distance, 30, frameNumber, false);
    _tiltStateCtrl.add(screenState);
    print("расстояние $distance");
  }

  List<List<double>> getFocusMarkerPaddingList(backgroundPictureSize, focusMarkerSize) {
    List<List<double>> result = [];

      /// Первое число - горизонтальный отступ, второе - вертикальный отступ,
      /// третье - если 1, то с этой позиции надо делать фото, если 0 - не надо.

    // 1. Начало.
    for (int i = 1; i < 8; i++){
      result.add([0, 0, 0]);
    }
    result.add([0, 0, 1]);
    for (int i = 1; i < 8; i++){
      result.add([0, 0, 0]);
    }
    // Путь от 1 к 2.
    for (int i = 1; i < 31; i++){
      result.add([
        (backgroundPictureSize - focusMarkerSize) / 30 * i,
        (backgroundPictureSize - focusMarkerSize) / 30 * i,
        0
      ]);
    }
    // 2. Правый нижний угол верхнего левого квадрата
    for (int i = 1; i < 8; i++){
      result.add([(backgroundPictureSize - focusMarkerSize), (backgroundPictureSize - focusMarkerSize), 0]);
    }
    result.add([(backgroundPictureSize - focusMarkerSize), (backgroundPictureSize - focusMarkerSize), 1]);
    for (int i = 1; i < 8; i++){
      result.add([(backgroundPictureSize - focusMarkerSize), (backgroundPictureSize - focusMarkerSize), 0]);
    }
    // Путь от 2 к 3.
    for (int i = 1; i < 31; i++){
      result.add([
        (backgroundPictureSize - focusMarkerSize),
        ((backgroundPictureSize - focusMarkerSize) + (focusMarkerSize / 30 * i)),
        0
      ]);
    }
    // 3. Правый верхний угол среднего левого квадрата
    for (int i = 1; i < 8; i++){
      result.add([(backgroundPictureSize - focusMarkerSize), (backgroundPictureSize), 0]);
    }
    result.add([(backgroundPictureSize - focusMarkerSize), (backgroundPictureSize), 1]);
    for (int i = 1; i < 8; i++){
      result.add([(backgroundPictureSize - focusMarkerSize), (backgroundPictureSize), 0]);
    }
    // Путь от 3 к 4.
    for (int i = 1; i < 31; i++){
      result.add([
        ((backgroundPictureSize - focusMarkerSize) - ((backgroundPictureSize - focusMarkerSize) / 30 * i)),
        (backgroundPictureSize + (backgroundPictureSize - focusMarkerSize) / 60 * i),
        0
      ]);
    }
    // 4. Середина левой грани среднего левого квадрата
    for (int i = 1; i < 8; i++){
      result.add([0, (backgroundPictureSize + (backgroundPictureSize - focusMarkerSize) / 2), 0]);
    }
    result.add([0, (backgroundPictureSize + (backgroundPictureSize - focusMarkerSize) / 2), 1]);
    for (int i = 1; i < 8; i++){
      result.add([0, (backgroundPictureSize + (backgroundPictureSize - focusMarkerSize) / 2), 0]);
    }
    // Путь от 4 к 5.
    for (int i = 1; i < 31; i++){
      result.add([
        (backgroundPictureSize - focusMarkerSize) / 30 * i,
        ((backgroundPictureSize + (backgroundPictureSize - focusMarkerSize) / 2) + ((backgroundPictureSize - focusMarkerSize) / 60 * i)),
        0
      ]);
    }
    // 5. Правый нижний угол среднего левого квадрата
    for (int i = 1; i < 8; i++){
      result.add([(backgroundPictureSize - focusMarkerSize), (backgroundPictureSize * 2 - focusMarkerSize), 0]);
    }
    result.add([(backgroundPictureSize - focusMarkerSize), (backgroundPictureSize * 2 - focusMarkerSize), 1]);
    for (int i = 1; i < 8; i++){
      result.add([(backgroundPictureSize - focusMarkerSize), (backgroundPictureSize * 2 - focusMarkerSize), 0]);
    }
    // Путь от 5 к 6.
    for (int i = 1; i < 31; i++){
      result.add([
        (backgroundPictureSize - focusMarkerSize),
        ((backgroundPictureSize * 2 - focusMarkerSize) + (focusMarkerSize / 30 * i)),
        0
      ]);
    }
    // 6. Правый верхний угол левого нижнего квадрата
    for (int i = 1; i < 8; i++){
      result.add([(backgroundPictureSize - focusMarkerSize), (backgroundPictureSize * 2), 0]);
    }
    result.add([(backgroundPictureSize - focusMarkerSize), (backgroundPictureSize * 2), 1]);
    for (int i = 1; i < 8; i++){
      result.add([(backgroundPictureSize - focusMarkerSize), (backgroundPictureSize * 2), 0]);
    }
    // Путь от 6 к 7.
    for (int i = 1; i < 31; i++){
      result.add([
        ((backgroundPictureSize - focusMarkerSize) - ((backgroundPictureSize - focusMarkerSize) / 30 * i)),
        ((backgroundPictureSize * 2) + (backgroundPictureSize - focusMarkerSize) / 30 * i),
        0
      ]);
    }
    // 7. Левый нижний угол левого нижнего квадрата
    for (int i = 1; i < 8; i++){
      result.add([0, (backgroundPictureSize * 3 - focusMarkerSize), 0]);
    }
    result.add([0, (backgroundPictureSize * 3 - focusMarkerSize), 1]);
    for (int i = 1; i < 8; i++){
      result.add([0, (backgroundPictureSize * 3 - focusMarkerSize), 0]);
    }
    // Путь от 7 к 8.
    for (int i = 1; i < 31; i++){
      result.add([
        ((backgroundPictureSize * 2 - focusMarkerSize) / 30 * i),
        (backgroundPictureSize * 3 - focusMarkerSize),
        0
      ]);
    }
    // 8. Правый нижний угол правого нижнего квадрата
    for (int i = 1; i < 8; i++){
      result.add([(backgroundPictureSize * 2 - focusMarkerSize), (backgroundPictureSize * 3 - focusMarkerSize), 0]);
    }
    result.add([(backgroundPictureSize * 2 - focusMarkerSize), (backgroundPictureSize * 3 - focusMarkerSize), 1]);
    for (int i = 1; i < 8; i++){
      result.add([(backgroundPictureSize * 2 - focusMarkerSize), (backgroundPictureSize * 3 - focusMarkerSize), 0]);
    }
    // Путь от 8 к 9.
    for (int i = 1; i < 31; i++){
      result.add([
        ((backgroundPictureSize * 2 - focusMarkerSize) - ((backgroundPictureSize - focusMarkerSize) / 30 * i)),
        ((backgroundPictureSize * 3 - focusMarkerSize) - ((backgroundPictureSize - focusMarkerSize) / 30 * i)),
        0
      ]);
    }
    // 9. Левый верхний угол правого нижнего квадрата
    for (int i = 1; i < 8; i++){
      result.add([backgroundPictureSize, (backgroundPictureSize * 2), 0]);
    }
    result.add([backgroundPictureSize, (backgroundPictureSize * 2), 1]);
    for (int i = 1; i < 8; i++){
      result.add([backgroundPictureSize, (backgroundPictureSize * 2), 0]);
    }
    // Путь от 9 к 10.
    for (int i = 1; i < 31; i++){
      result.add([
        backgroundPictureSize,
        ((backgroundPictureSize * 2) - (focusMarkerSize / 30 * i)),
        0
      ]);
    }
    // 10. Левый нижний угол правого среднего квадрата
    for (int i = 1; i < 8; i++){
      result.add([backgroundPictureSize, (backgroundPictureSize * 2 - focusMarkerSize), 0]);
    }
    result.add([backgroundPictureSize, (backgroundPictureSize * 2 - focusMarkerSize), 1]);
    for (int i = 1; i < 8; i++){
      result.add([backgroundPictureSize, (backgroundPictureSize * 2 - focusMarkerSize), 0]);
    }
    // Путь от 10 к 11.
    for (int i = 1; i < 31; i++){
      result.add([
        (backgroundPictureSize + ((backgroundPictureSize - focusMarkerSize) / 30 * i)),
        ((backgroundPictureSize * 2 - focusMarkerSize) - ((backgroundPictureSize - focusMarkerSize) / 60 * i)),
        0
      ]);
    }
    // 11. Середина правой грани правого среднего квадрата
    for (int i = 1; i < 8; i++){
      result.add([(backgroundPictureSize * 2 - focusMarkerSize), (backgroundPictureSize + (backgroundPictureSize - focusMarkerSize) / 2), 0]);
    }
    result.add([(backgroundPictureSize * 2 - focusMarkerSize), (backgroundPictureSize + (backgroundPictureSize - focusMarkerSize) / 2), 1]);
    for (int i = 1; i < 8; i++){
      result.add([(backgroundPictureSize * 2 - focusMarkerSize), (backgroundPictureSize + (backgroundPictureSize - focusMarkerSize) / 2), 0]);
    }
    // Путь от 11 к 12.
    for (int i = 1; i < 31; i++){
      result.add([
        ((backgroundPictureSize * 2 - focusMarkerSize) - ((backgroundPictureSize - focusMarkerSize) / 30 * i)),
        ((backgroundPictureSize + (backgroundPictureSize - focusMarkerSize) / 2) - ((backgroundPictureSize - focusMarkerSize) / 60 * i)),
        0
      ]);
    }
    // 12. Левый верхний угол правого среднего квадрата
    for (int i = 1; i < 8; i++){
      result.add([backgroundPictureSize, backgroundPictureSize, 0]);
    }
    result.add([backgroundPictureSize, backgroundPictureSize, 1]);
    for (int i = 1; i < 8; i++){
      result.add([backgroundPictureSize, backgroundPictureSize, 0]);
    }
    // Путь от 12 к 13.
    for (int i = 1; i < 31; i++){
      result.add([
        backgroundPictureSize,
        (backgroundPictureSize - (focusMarkerSize / 30 * i)),
        0
      ]);
    }
    // 13. Левый нижний угол правого верхнего квадрата
    for (int i = 1; i < 8; i++){
      result.add([backgroundPictureSize, (backgroundPictureSize - focusMarkerSize), 0]);
    }
    result.add([backgroundPictureSize, (backgroundPictureSize - focusMarkerSize), 1]);
    for (int i = 1; i < 8; i++){
      result.add([backgroundPictureSize, (backgroundPictureSize - focusMarkerSize), 0]);
    }
    // Путь от 13 к 14.
    for (int i = 1; i < 31; i++){
      result.add([
        (backgroundPictureSize + ((backgroundPictureSize - focusMarkerSize) / 30 * i)),
        ((backgroundPictureSize - focusMarkerSize) - ((backgroundPictureSize - focusMarkerSize) / 30 * i)),
        0
      ]);
    }
    // 14. Правый верхний угол правого верхнего квадрата
    for (int i = 1; i < 8; i++){
      result.add([(backgroundPictureSize * 2 - focusMarkerSize), 0, 0]);
    }
    result.add([(backgroundPictureSize * 2 - focusMarkerSize), 0, 1]);
    for (int i = 1; i < 8; i++){
      result.add([(backgroundPictureSize * 2 - focusMarkerSize), 0, 0]);
    }
    return result;
  }

}

class ScreenState{
  final double tilt;
  final double distance;
  final int timerCount;
  final int frameNumber;
  final bool isStop;

  ScreenState(this.tilt, this.distance, this.timerCount, this.frameNumber, this.isStop);
}
