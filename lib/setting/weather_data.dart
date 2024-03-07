import 'package:flutter/cupertino.dart';
import 'package:open_weather_client/models/weather_data.dart';
import 'package:open_weather_client/models/weather_forecast_data.dart';

import '../Libs/weather_api.dart';

class LocationInfo {
  static final LocationInfo empty = LocationInfo("null");

  LocationInfo(this.cityName);

  static LocationInfo formCityData(CityLocationData citiesData) {
    LocationInfo locationInfo=LocationInfo(citiesData.name);
    locationInfo.lon = citiesData.lon;
    locationInfo.lat=citiesData.lat;
    return locationInfo;
  }

  late String cityName;
  double lon=-1000;
  double lat=-1000;

  @override
  bool operator ==(Object other) {
    if(other is LocationInfo){
      bool flag1=cityName==other.cityName && (lon-other.lon).abs()<0.1 &&(lat-other.lat).abs()<0.1;
      return flag1;

    }
    return false;
  }



}

enum WeatherType { current, forecast }

class WeatherPageData {
  WeatherType weatherType = WeatherType.current;
  ValueNotifier<WeatherData?> weatherData=ValueNotifier(null);
  ValueNotifier< WeatherForecastData?> weatherForecastData=ValueNotifier(null);
  ValueNotifier< WeatherAQIData?> weatherAqiData=ValueNotifier(null);
  LocationInfo locationInfo;
  late String title;

  WeatherPageData({required this.locationInfo}) {
    title = locationInfo.cityName;
  }


  @override
  bool operator ==(Object other) {
    if(other is WeatherPageData){
      return locationInfo == other.locationInfo;
    }
    return false;

  }


}