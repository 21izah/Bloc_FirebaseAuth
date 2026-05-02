import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:izahs/themes/dark_mode.dart';
import 'package:izahs/themes/light_mode.dart';

class ThemeCubit extends Cubit<ThemeData> {
  bool _isDarkMode = false;
  ThemeCubit() : super(lightMode);

  bool get isDarkMode => _isDarkMode;

  Future<void> loadIsDarkModeState() async {
    var box = Hive.box('settingsBox');
    _isDarkMode = box.get('isDarkMode', defaultValue: false);
    emit(_isDarkMode ? darkMode : lightMode);
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    var box = Hive.box('settingsBox');
    box.put('isDarkMode', _isDarkMode);
    debugPrint("isDarkMode value: ${box.get("isDarkMode")}");
    emit(_isDarkMode ? darkMode : lightMode);
  }
}
