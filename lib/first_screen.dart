import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:data_collector/buttons.dart';
import 'package:data_collector/session_class.dart';
import 'package:data_collector/calibration_screen.dart';
import 'package:data_collector/collection_screen.dart';

class FirstPage extends StatefulWidget {
  final CameraDescription camera;
  const FirstPage({Key? key, required this.camera}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {

  AppMode appMode = AppMode.calibration;
  String number = "0";
  Gender gender = Gender.male;
  PhoneModel model = PhoneModel.redmy;
  Distance distance = Distance.x15;
  MatrixSize matrixSize = MatrixSize.x5x7;
  CrossMarksPosition crossMarksPosition = CrossMarksPosition.center;
  double screenTime = 2.0;
  double photoTime = 0.75;
  bool? showBackground = false;
  bool? autoFocusEnable = false;

  List<List<int>> _generateListForCollectionScreen(){
    int _wight;
    int _height;
    switch (matrixSize) {
      case MatrixSize.x5x7:
        _wight = 6;
        _height = 8;
        break;
      case MatrixSize.x7x10:
        _wight = 8;
        _height = 11;
        break;
      case MatrixSize.x9x13:
        _wight = 10;
        _height = 14;
        break;
    }
    List<List<int>> result = [];
    for (int i = 1; i < _wight; i++) {
      for (int l = 1; l < _height; l++) {
        result.add([i, l]);
      }
    }
    result.shuffle();
    return result;
  }

  List<List<int>> _generateListForCalibrationScreen(){
    List<List<int>> temp = [[1, 1], [1, 2], [2, 1], [2, 2], [3, 1], [3, 2]];
    List<List<int>> result = [[1, 1], [1, 2], [2, 1], [2, 2], [3, 1], [3, 2]];
    temp.shuffle();
    result.addAll(temp);
    return result;
  }

  void _onNumberChanged(String newText){
    number = newText;
  }

  void _screenTimeUp(){
    //if(screenTime < 3.0) {
      screenTime = screenTime + 0.5;
      setState(() {});
    //}
  }

  void _screenTimeDown(){
    if(screenTime > 0.5) {
      screenTime = screenTime - 0.5;
      setState(() {});
    }
  }
  void _photoTimeUp(){
    if(photoTime < screenTime) {
      photoTime = photoTime + 0.05;
      setState(() {});
    }
  }
  void _photoTimeDown(){
    if(photoTime > 0.1) {
      photoTime = photoTime - 0.05;
      setState(() {});
    }
  }

  void _startUp(){
    switch(appMode) {
      case AppMode.calibration:
        _calibration();
        break;
      case AppMode.collection:
        _collection();
        break;
    }
  }

  void _collection(){
    CollectionSession session = CollectionSession(number, gender, model, distance, matrixSize, screenTime, photoTime, showBackground, autoFocusEnable);
    List<List<int>> list = _generateListForCollectionScreen();
    Navigator.push(
      context, MaterialPageRoute(
        builder: (context) {
          return CollectionPage(session: session, list: list, camera: widget.camera,);
        }
      )
    );
  }

  void _calibration(){
    CalibrationSession session = CalibrationSession(number, gender, model, distance, crossMarksPosition, screenTime, photoTime, showBackground, autoFocusEnable);
    List<List<int>> list = _generateListForCalibrationScreen();
    Navigator.push(
      context, MaterialPageRoute(
        builder: (context) {
          return CalibrationPage(session: session, list: list, camera: widget.camera,);
        }
      )
    );
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Введите настройки"),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Column(
            children: [
              const Text("Режим"),
              ListTile(
                title: const Text('Каллиброка'),
                leading: Radio<AppMode>(
                  value: AppMode.calibration,
                  groupValue: appMode,
                  onChanged: (AppMode? value) {
                    setState(() {
                      appMode = value!;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Сбор данных'),
                leading: Radio<AppMode>(
                  value: AppMode.collection,
                  groupValue: appMode,
                  onChanged: (AppMode? value) {
                    setState(() {
                      appMode = value!;
                    });
                  },
                ),
              ),
              const Text("Номер"),
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (newText)=>_onNumberChanged(newText),
                onSubmitted: (newText)=>_onNumberChanged(newText),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Вводить сюда",
                ),
              ),
              const Text("Пол"),
              ListTile(
                title: const Text('Мужской'),
                leading: Radio<Gender>(
                  value: Gender.male,
                  groupValue: gender,
                  onChanged: (Gender? value) {
                    setState(() {
                      gender = value!;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Женский'),
                leading: Radio<Gender>(
                  value: Gender.female,
                  groupValue: gender,
                  onChanged: (Gender? value) {
                    setState(() {
                      gender = value!;
                    });
                  },
                ),
              ),
              const Text("Модель смартфона"),
              ListTile(
                title: const Text('Redmy'),
                leading: Radio<PhoneModel>(
                  value: PhoneModel.redmy,
                  groupValue: model,
                  onChanged: (PhoneModel? value) {
                    setState(() {
                      model = value!;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Sony'),
                leading: Radio<PhoneModel>(
                  value: PhoneModel.sony,
                  groupValue: model,
                  onChanged: (PhoneModel? value) {
                    setState(() {
                      model = value!;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Samsung'),
                leading: Radio<PhoneModel>(
                  value: PhoneModel.samsung,
                  groupValue: model,
                  onChanged: (PhoneModel? value) {
                    setState(() {
                      model = value!;
                    });
                  },
                ),
              ),
              const Text("Расстояние"),
              ListTile(
                title: const Text('15 см'),
                leading: Radio<Distance>(
                  value: Distance.x15,
                  groupValue: distance,
                  onChanged: (Distance? value) {
                    setState(() {
                      distance = value!;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('30 см'),
                leading: Radio<Distance>(
                  value: Distance.x30,
                  groupValue: distance,
                  onChanged: (Distance? value) {
                    setState(() {
                      distance = value!;
                    });
                  },
                ),
              ),
              const Text("Время между крестиками"),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '$screenTime',
                      textAlign: TextAlign.center
                    )
                  ),
                  AnimatedButton(
                    icon: const Icon(Icons.add),
                    onPressed: (){
                      setState((){_screenTimeUp();});
                    }
                  ),
                  AnimatedButton(
                    icon: const Icon(Icons.remove),
                    onPressed: (){setState((){_screenTimeDown();});}
                  )
                ]
              ),
              const Text("Время"),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      photoTime.toStringAsPrecision(2),
                      textAlign: TextAlign.center
                    )
                  ),
                  AnimatedButton(
                    icon: const Icon(Icons.add),
                    onPressed: (){setState((){_photoTimeUp();});}
                  ),
                  AnimatedButton(
                    icon: const Icon(Icons.remove),
                    onPressed: (){setState((){_photoTimeDown();});}
                  )
                ]
              ),
              if(appMode == AppMode.collection)
                const Text("Размер сетки"),
              if(appMode == AppMode.collection)
                ListTile(
                  title: const Text('5 x 7'),
                  leading: Radio<MatrixSize>(
                    value: MatrixSize.x5x7,
                    groupValue: matrixSize,
                    onChanged: (MatrixSize? value) {
                      setState(() {
                        matrixSize = value!;
                      });
                    },
                  ),
                ),
              if(appMode == AppMode.collection)
                ListTile(
                  title: const Text('7 x 10'),
                  leading: Radio<MatrixSize>(
                    value: MatrixSize.x7x10,
                    groupValue: matrixSize,
                    onChanged: (MatrixSize? value) {
                      setState(() {
                        matrixSize = value!;
                      });
                    },
                  ),
                ),
              if(appMode == AppMode.collection)
                ListTile(
                  title: const Text('9 x 13'),
                  leading: Radio<MatrixSize>(
                    value: MatrixSize.x9x13,
                    groupValue: matrixSize,
                    onChanged: (MatrixSize? value) {
                      setState(() {
                        matrixSize = value!;
                      });
                    },
                  ),
                ),
              if(appMode == AppMode.calibration)
                const Text("Положение крестиков"),
              if(appMode == AppMode.calibration)
                ListTile(
                  title: const Text('По центру'),
                  leading: Radio<CrossMarksPosition>(
                    value: CrossMarksPosition.center,
                    groupValue: crossMarksPosition,
                    onChanged: (CrossMarksPosition? value) {
                      setState(() {
                        crossMarksPosition = value!;
                      });
                    },
                  ),
                ),
              if(appMode == AppMode.calibration)
                ListTile(
                  title: const Text('По углам'),
                  leading: Radio<CrossMarksPosition>(
                    value: CrossMarksPosition.edge,
                    groupValue: crossMarksPosition,
                    onChanged: (CrossMarksPosition? value) {
                      setState(() {
                        crossMarksPosition = value!;
                      });
                    },
                  ),
                ),

              CheckboxListTile(
                title: const Text("Показывать фон?"),
                value: showBackground,
                onChanged: (newValue) {
                  setState(() {
                    showBackground = newValue;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
              ),
              CheckboxListTile(
                title: const Text("Использовать автофокус?"),
                value: autoFocusEnable,
                onChanged: (newValue) {
                  setState(() {
                    autoFocusEnable = newValue;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
              )
            ]
          )
        ]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startUp,
        tooltip: 'Start',
        child: const Text("Начать"),
      ),
    );
  }
}