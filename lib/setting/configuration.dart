import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_weather_client/models/weather_data.dart';
import 'package:open_weather_client/models/weather_forecast_data.dart';
import 'package:shape_weather/Libs/weather_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'weather_data.dart';



ValueNotifier<List<WeatherPageData>> weatherPages = ValueNotifier([]);
ValueNotifier<Map<String,dynamic>> appSetting = ValueNotifier({});

bool isFirstTime=true;

const String _isFirstTime="is_1st_time";
const String _key="config";
const String enable_dynamic_backgorund="enable_dynamic_background";
const String theme_color="theme_color";

Future saveConfig()async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var list=<String>[];
  for(var i in weatherPages.value){
    list.add("${i.locationInfo.lon}/${i.locationInfo.lat}/${i.locationInfo.cityName}");
  }
  prefs.setStringList(_key, list);
}
Future saveAppSetting()async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool(enable_dynamic_backgorund, appSetting.value[enable_dynamic_backgorund]!);
  prefs.setInt(theme_color, appSetting.value[theme_color]!.value);
}
Future<String> loadConfig()async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var list=prefs.getStringList(_key);
  isFirstTime=prefs.getBool(_isFirstTime)??true;
  list ??= [];
  weatherPages.value.clear();

  for(String i in list){
    var splited=i.split("/");
    late LocationInfo locationInfo=LocationInfo(splited[2]);
    locationInfo.lon=double.parse(splited[0]) ;
    locationInfo.lat=double.parse(splited[1]);
    weatherPages.value.add(WeatherPageData(locationInfo: locationInfo));
  }
  appSetting.value[enable_dynamic_backgorund]=prefs.getBool(enable_dynamic_backgorund)??true;
  int? color=prefs.getInt(theme_color);
  if(color==null){
    appSetting.value[theme_color]= Colors.deepPurple;
  }else{
    appSetting.value[theme_color]= Color(color);
  }
  
  return "Done";

}

Future notFirstTime()async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var list=<String>[];
  for(var i in weatherPages.value){
    list.add("${i.locationInfo.lon}/${i.locationInfo.lat}/${i.locationInfo.cityName}");
  }
  prefs.setStringList(_key, list);

}



