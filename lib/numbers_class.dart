import 'dart:async';

import 'package:data_collector/shared_preferences_numbers.dart';                             // Класс для асинхронной работы.

/// Класс представления данных.
class NumbersController{
  /// Поля интерфейса класса.
  late List<String> lastState;
  Stream<List<String>> get states => _ctrl.stream;

  final StreamController<List<String>> _ctrl = StreamController<List<String>>.broadcast();
  late _Proxy _px;
  final SharedPreferencesNumberDataSource _ds;

  NumbersController(this._ds) {
    _px = _Proxy(_ds);
    lastState = <String>[];
    loadAll();
  }

  void _fireEvent(List<String> updatedList) {
    lastState = updatedList;
    _ctrl.add(lastState);
  }

  Future<void> loadAll() async {
    final List<String> updatedList =  await _px.loadAll();
    _fireEvent(updatedList);
  }

  Future<void> create(String number) async {
    final List<String> updatedList = await _px.create(number);
    _fireEvent(updatedList);
  }

  void discard(){
    _ctrl.close();
  }
}

class _Proxy{

  final SharedPreferencesNumberDataSource _ds;

  _Proxy(this._ds);

  Future<List<String>> loadAll() async{
    try {
      final result = await _ds.readAll();
      print("finished loadAll");
      return result;
    } catch (e, st) {
      print("$e, $st");
      return <String>[];
    }
  }

  Future<List<String>> create(String number) async {
    try {
      await _ds.create(number);
      final result = await _ds.readAll();
      print("finished create");
      return result;
    } catch (e) {
      rethrow;
    }
  }
}

