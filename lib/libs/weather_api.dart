import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:shape_weather/Setting/configuration.dart';
import 'package:shape_weather/Libs/languages.dart';
import 'package:open_weather_client/enums/languages.dart';
import 'package:open_weather_client/open_weather.dart';
import 'package:http/http.dart' as http;

class Weather {

  static Languages language = Languages.ENGLISH;
  static const String _key_openweather = r"4712166053f9a5ae4cf514b908becdf0";
  static const String _key_baidu= r"7cXDqK09x3CPtwYPFA8982VGzAknbNxe";
  static const String _Key_alapi=r"ocqZ7AsFpWBXE6WciY4X";

  static OpenWeather openWeather = OpenWeather(apiKey: _key_openweather);

  static Future<WeatherData> getWeather(LocationInfo info) async {
    if (info.lat < -200 && info.lon < -200) {
      return await openWeather
          .currentWeatherByCityName(
        cityName: info.cityName,
        weatherUnits: WeatherUnits.METRIC,
      )
          .catchError((err) {
        print(err);
      });
    }
    return await openWeather
        .currentWeatherByLocation(
      weatherUnits: WeatherUnits.METRIC,
      longitude: info.lon,
      latitude: info.lat,
    )
        .catchError((err) {
      print(err);
    });
  }

  static Future<WeatherForecastData> getWeatherForecast(
      LocationInfo info) async {
    if (info.lat < -200 && info.lon < -200) {
      return await openWeather
          .fiveDaysWeatherForecastByCityName(
              cityName: info.cityName,
              weatherUnits: WeatherUnits.METRIC,
              language: Languages.ENGLISH)
          .catchError((err) => print(err));
    }
    return await openWeather
        .fiveDaysWeatherForecastByLocation(
            weatherUnits: WeatherUnits.METRIC,
            language: Languages.ENGLISH,
            latitude: info.lat,
            longitude: info.lon)
        .catchError((err) => print(err));
  }

  static Future<String> request(String uri) async {
    return (await http.read(Uri.parse(uri)));
  }
  static Future<String> getWeather_httpget(LocationInfo info)async{
    var result=await request("https://api.openweathermap.org/data/3.0/onecall?lat=${info.lat}&lon=${info.lon}&appid=$_key_openweather");
    return result;
  }
  static Future<CityLocationData> getCityByIP_Baidu()async{
    var result=jsonDecode(await request("https://api.map.baidu.com/location/ip?coor=bd09ll&ak=$_key_baidu"));
    var content=result["content"];
    var detail=content["address_detail"];
    CityLocationData cityLocationData=CityLocationData()..name=detail["city"]..state=detail["province"]..country="China";
    cityLocationData.lat=double.parse(content["point"]["y"]);
    cityLocationData.lon=double.parse(content["point"]["x"]);
    return cityLocationData;
  }
  static Future<CityLocationData> getCityByIP_Alapi()async{
    var result=jsonDecode(await request("https://v2.alapi.cn/api/ip?token=$_Key_alapi"));
    var data=result["data"];
    var detail=data["ad_info"];
    CityLocationData cityLocationData=CityLocationData()
      ..name=detail["district"]==""?detail["city"]:detail["district"]
      ..state=detail["province"]..country=detail["nation"];
    cityLocationData.lat=(data["location"]["lat"]);
    cityLocationData.lon=(data["location"]["lng"]);
    return cityLocationData;
  }

  static Future<List<CityLocationData>> getCitiesByName(String cityName) async {
    var response = await request(
        "https://api.openweathermap.org/geo/1.0/direct?q=$cityName&limit=5&appid=$_key_openweather");
    var result = jsonDecode(response);
    var cities = <CityLocationData>[];

    for (var i in result) {
/*      String lon=(i["lon"])as String;
      String lat=(i["lat"])as String;*/
      var data=
      CityLocationData()
        ..name = i["name"]!
        ..lat =i["lat"]
        ..lon = i["lon"]
        ..country = i["country"]!;
      if (i.containsKey("state")) {
        data.state = i["state"]!;
      }
      cities.add(data);
    }

    return cities;
  }
  static Future<WeatherAQIData> getCityAIQ(LocationInfo info)async{

    var response=await request("https://api.openweathermap.org/data/2.5/air_pollution?lat=${info.lat}&lon=${info.lon}&appid=$_key_openweather");
    var result = jsonDecode(response);
    var dict=result["list"][0];
    var components=dict["components"];
    var cityAQIData=WeatherAQIData()
      ..aqi=dict["main"]["aqi"]
      ..co=components["co"].toDouble()
      ..no=components["no"].toDouble()
      ..no2=components["no2"].toDouble()
      ..o3=components["o3"].toDouble()
      ..so2=components["so2"].toDouble()
      ..pm2_5=components["pm2_5"].toDouble()
      ..pm10=components["pm10"].toDouble()
      ..nh3=components["nh3"].toDouble();

    return cityAQIData;
  }
}
class WeatherAQIData{
  int aqi=-1;
  double co=-1;
  double no=-1;
  double no2=-1;
  double o3=-1;
  double so2=-1;
  double pm2_5=-1;
  double pm10=-1;
  double nh3=-1;

}

class CityLocationData {
  String name="Unknown";
  double lat=double.nan;
  double lon=double.nan;
  String country = "Unknown";
  String state = "";
}
