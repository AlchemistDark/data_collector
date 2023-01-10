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

  int number = 0;
  double screenTime = 2.0;
  double photoTime = 0.25;

  List<List<int>> _generateList(){
    List<List<int>> result = [];
    for (int i = 1; i < 9; i++) {
      for (int l = 1; l < 16; l++) {
        result.add([i, l]);
      }
    }
    result.shuffle();
    print(result);
    return result;
  }

  void _onNumberChanged(String newText){
    number = int.parse(newText);
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
    Session session = Session(number, screenTime, photoTime);
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
      body:  Column(
        children: [
          const Text("Номер"),
          TextFormField(
            initialValue: "Вводить сюда",
            keyboardType: TextInputType.number,
            onChanged: (newText)=>_onNumberChanged(newText),
            onFieldSubmitted: (newText)=>_onNumberChanged(newText)
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