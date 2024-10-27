import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'weather_data.dart';

ValueNotifier<List<WeatherPageData>> weatherPages = ValueNotifier([]);
ValueNotifier<Map<String, dynamic>> appSetting = ValueNotifier({});

bool isFirstTime = true;

const String _isFirstTime = "is_1st_time";
const String _key = "config";
const String enable_dynamic_background = "enable_dynamic_background";
const String theme_color = "theme_color";
const String language_set="language_set";
late SharedPreferences preferences;

Future<void> saveConfig() async {
  var list = <String>[];
  for (var i in weatherPages.value) {
    list.add(
        "${i.locationInfo.lon}/${i.locationInfo.lat}/${i.locationInfo.cityName}");
  }
  preferences.setStringList(_key, list);
}

Future<void> saveAppSetting() async {
  preferences.setBool(enable_dynamic_background, appSetting.value[enable_dynamic_background]!);
  preferences.setInt(theme_color, appSetting.value[theme_color]!.value);
  var lang=appSetting.value[language_set];
  if(lang==null){
    preferences.remove(language_set);
  }else{
    preferences.setString(language_set, appSetting.value[language_set]);
  }

}

Future<void> loadConfig() async {
  var list = preferences.getStringList(_key);
  isFirstTime = preferences.getBool(_isFirstTime) ?? true;
  list ??= [];
  weatherPages.value.clear();

  for (String i in list) {
    var split = i.split("/");
    late LocationInfo locationInfo = LocationInfo(split[2]);
    locationInfo.lon = double.parse(split[0]);
    locationInfo.lat = double.parse(split[1]);
    weatherPages.value.add(WeatherPageData(locationInfo: locationInfo));
  }
  appSetting.value[enable_dynamic_background] =
      preferences.getBool(enable_dynamic_background) ?? true;
  int? color = preferences.getInt(theme_color);
  if (color == null) {
    appSetting.value[theme_color] = Colors.deepPurple;
  } else {
    appSetting.value[theme_color] = Color(color);
  }
  appSetting.value[language_set]=preferences.getString(language_set);
}

Future notFirstTime() async {
  var list = <String>[];
  for (var i in weatherPages.value) {
    list.add(
        "${i.locationInfo.lon}/${i.locationInfo.lat}/${i.locationInfo.cityName}");
  }
  preferences.setStringList(_key, list);
}
Duration cardSizeAnimationDuration = const Duration(milliseconds: 300);
late BuildContext logicRootContext;