import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:data_collector/shared_preferences_numbers.dart';
import 'package:data_collector/first_screen.dart';

void main() async {
  // final SharedPreferences shp = await SharedPreferences.getInstance();
  // final SharedPreferencesNumberDataSource dataSource = SharedPreferencesNumberDataSource(shp);
  //runApp(MyApp(dataSource));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  //final SharedPreferencesNumberDataSource dataSource;

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data Collector',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FirstPage(),
    );
  }
}
