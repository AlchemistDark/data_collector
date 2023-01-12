import 'package:shared_preferences/shared_preferences.dart';         // Библиотека, обеспечивающая хранение списка задач на устройтсве.

const _numberListId = "numberListId";

class SharedPreferencesNumberDataSource{

  final SharedPreferences _data;
  List<String> tasksCache = <String>[];

  SharedPreferencesNumberDataSource(this._data);

  Future<List<String>> readAll() async {
    final strList = _data.getStringList(_numberListId) ?? [];
    tasksCache = strList;
    return strList;
  }

  Future<void> create(String newTask) async {
    tasksCache.add(newTask);
    writeToStorage();
  }

  void writeToStorage(){
    _data.setStringList(_numberListId, tasksCache);
  }
}