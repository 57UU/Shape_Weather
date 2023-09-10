import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:shape_weather/Setting/Configuration.dart';
import 'package:shape_weather/Languages.dart';
import 'package:open_weather_client/enums/languages.dart';
import 'package:open_weather_client/open_weather.dart';
import 'package:http/http.dart' as http;

class Weather {
  static Languages language = Languages.ENGLISH;
  static const String _key_openweather = r"4712166053f9a5ae4cf514b908becdf0";
  static const String _key_baidu=r"7cXDqK09x3CPtwYPFA8982VGzAknbNxe";

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
/*    HttpClient httpClient =HttpClient();
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(uri));
    HttpClientResponse response = await request.close();
    String responseBody = await response.transform(utf8.decoder).join();
    httpClient.close();
    return responseBody;*/
/*    var response = await http.get((Uri.parse(uri)));
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');*/

    return (await http.read(Uri.parse(uri)));
  }
  static Future<CityLocationData> getCityByIP()async{
    var result=jsonDecode(await request("https://api.map.baidu.com/location/ip?coor=bd09ll&ak=$_key_baidu"));
    var content=result["content"];
    var detail=content["address_detail"];
    CityLocationData cityLocationData=CityLocationData()..name=detail["city"]..state=detail["province"]..country="China";
    cityLocationData.lat=double.parse(content["point"]["y"]);
    cityLocationData.lon=double.parse(content["point"]["x"]);
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
}

class CityLocationData {
  String name="Unknown";
  double lat=double.nan;
  double lon=double.nan;
  String country = "Unknown";
  String state = "";
}
