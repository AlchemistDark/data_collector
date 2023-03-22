import 'package:data_collector/position_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:data_collector/background.dart';
import 'package:data_collector/position_controller.dart';
import 'package:data_collector/position_marker_widget.dart';

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:camera/camera.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'package:data_collector/background.dart';
import 'package:data_collector/session_class.dart';

class DemoPage extends StatefulWidget {
  final DemoSession session;

  final CameraDescription camera;
  const DemoPage({
    required this.session,
    required this.camera,
    Key? key
  }) : super(key: key);

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {

  bool startCountdownBeforePhotoCycle = false;
  int countdownBeforePhotoCycle = 30;
  bool pausePhotoCycle = true;

 Future<void>awaitSetState()async{
    Duration duration = const Duration(milliseconds: 100);
    await Future.delayed(duration, () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final double mainWidth = MediaQuery.of(context).size.width;
    final double areaWidth = mainWidth - 24; // two indents of 12 px.
    final double areaHeight = areaWidth * 1.5;
    final double backgroundPictureSize = areaWidth / 2;
    const double focusMarkerSize = 20;
    final ScreenController pageController = ScreenController(
      widget.session,
      backgroundPictureSize,
      focusMarkerSize,
      widget.camera
    );

    // startTimer();
    // List list = widget.list;


    return StreamBuilder<ScreenState>(
      initialData: pageController.screenState,
      stream: pageController.positionState,
      builder: (context, snapshot) {
        ScreenState state = snapshot.data!;
        double leftPudding = pageController.focusMarkerPaddingList[state.frameNumber][0];
        double topPudding = pageController.focusMarkerPaddingList[state.frameNumber][1];
        bool isStop = state.isStop;
        return Scaffold(
          body: Stack(
            children: [
              if(!isStop)
                Container(
                  margin: const EdgeInsets.only(
                    left: 12.0, top: 55.0, right: 12.0),
                    child: Stack(
                      children: [
                        if (widget.session.showBackground!)
                          Background(
                            areaWidth: areaWidth,
                            areaHeight: areaHeight
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: leftPudding,
                              top: topPudding
                            ),
                            child: SizedBox(
                              width: focusMarkerSize,
                              height: focusMarkerSize,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(focusMarkerSize / 2),
                                    color: Colors.black
                                  ),
                                )
                             )
                          ),
                          Column(
                            children: [
                              Center(
                                child: SizedBox(
                                  width: areaWidth,
                                  height: areaHeight,
                                  child: const SizedBox(
                                    width: 100,
                                    height: 100,
                                  ),
                                  // child: TableScreen(
                                  //   list[_currentIndex],
                                  //   getXDistance(),
                                  //   getYDistance()
                                  // )
                                )
                              ),
                              Expanded(
                                child: SizedBox(
                                  width: areaWidth,
                                  child: Center(
                                    child: PositionIndicator(
                                      controller: pageController,
                                      gradientBorderColor1: const Color(0xFF2C2F37),
                                      gradientBorderColor2: const Color(0xFF3C3E47),
                                      gradientFillColor1: const Color(0xFF464851),
                                      gradientFillColor2: const Color(0xFF282B33),
                                      separatorColor: const Color(0xFF50B498),
                                      width: 26,
                                      height: 53,
                                    )
                                  ),
                                )
                              )
                            ]
                          )
                      ]
                    )
                ),
                if(state.timerCount != 0)
                  Center(
                    child: Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height / 2,
                      width: MediaQuery.of(context).size.width / 2,
                      color: Colors.white12.withOpacity(0.5),
                      child: Text('${state.timerCount}'),
                    )
                  ),
                if(isStop)
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
    );
  }
}