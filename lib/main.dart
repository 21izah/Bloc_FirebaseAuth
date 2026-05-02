import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:izahs/app.dart';
import 'package:izahs/config/firebase_options.dart';

import 'themes/theme_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('settingsBox');

  final themeCubit = ThemeCubit();
  await themeCubit.loadIsDarkModeState();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp(themeCubit: themeCubit));
}
