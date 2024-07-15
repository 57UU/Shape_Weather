import 'dart:async';

import 'package:shape_weather/libs/version.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../setting/configuration.dart';

Future<void> ensureInitialize()async{
  preferences  = await SharedPreferences.getInstance();
  initVersion();
  weatherPages.addListener(() {
    saveConfig();
  });
  appSetting.addListener(() {
    saveAppSetting();
  });

}