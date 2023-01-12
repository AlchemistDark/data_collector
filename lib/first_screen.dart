import 'package:data_collector/numbers_class.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:data_collector/buttons.dart';
import 'package:data_collector/session_class.dart';
import 'package:data_collector/second_screen.dart';

class FirstPage extends StatefulWidget {

  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {

  late NumbersController stream;

  String number = "0";
  Gender gender = Gender.male;
  PhoneModel model = PhoneModel.redmy;
  Distance distance = Distance.x15;
  MatrixSize matrixSize = MatrixSize.x5x7;
  double screenTime = 2.0;
  double photoTime = 0.25;
  bool? showBackground = false;

  List<List<int>> _generateList(){
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
    print(result);
    return result;
  }

  void _onNumberChanged(String newText){
    number = newText;
    print(number);
  }

  void _screenTimeUp(){
    if(screenTime < 3.0) {
      screenTime = screenTime + 0.5;
      setState(() {});
    }
  }

  void _screenTimeDown(){
    if(screenTime > 0.5) {
      screenTime = screenTime - 0.5;
      setState(() {});
    }
  }
  void _photoTimeUp(){
    if(photoTime < 0.25) {
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
    //strList.add();

    //widget.data.setStringList(_listOfNumbers)
    Session session = Session(number, gender, model, distance, matrixSize, screenTime, photoTime, showBackground);
    print("Дебаг ${session.number} ${session.gender} ${session.phoneModel}");
    List<List<int>> list = _generateList();
    Navigator.push(
      context, MaterialPageRoute(
        builder: (context) {
          return SecondPage(session: session, list: list);
        }
      )
    );
  }

  @override
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
              const Text("Номер"),
              TextFormField(
                initialValue: "Вводить сюда",
                keyboardType: TextInputType.number,
                onChanged: (newText)=>_onNumberChanged(newText),
                onFieldSubmitted: (newText)=>_onNumberChanged(newText)
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
                onPressed: (){setState((){_screenTimeUp(); print("$screenTime");});}
              ),
              AnimatedButton(
                icon: const Icon(Icons.remove),
                onPressed: (){setState((){_screenTimeDown(); print("$screenTime");});}
              )
            ]
          ),
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
                onPressed: (){setState((){_photoTimeUp(); print("$photoTime");});}
              ),
              AnimatedButton(
                icon: const Icon(Icons.remove),
                onPressed: (){setState((){_photoTimeDown(); print("$photoTime");});}
              )
            ]
          ),
          const Text("Размер сетки"),
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
          CheckboxListTile(
            title: const Text("Показывать фон?"),
            value: showBackground,
            onChanged: (newValue) {
              setState(() {
                showBackground = newValue;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
          )
        ]
      )]),
      floatingActionButton: FloatingActionButton(
        onPressed: _startUp,
        tooltip: 'Start',
        child: const Text("Начать"),
      ),
    );
  }
}