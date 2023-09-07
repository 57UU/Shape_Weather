import 'package:open_weather_client/models/weather_data.dart';
import 'package:open_weather_client/models/weather_forecast_data.dart';
import 'package:shape_weather/weatherAPI.dart';

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
}

enum WeatherType { current, forecast }

class WeatherPageData {
  WeatherType weatherType = WeatherType.current;
  WeatherData? weatherData;
  WeatherForecastData? weatherForecastData;
  LocationInfo locationInfo;
  late String title;

  WeatherPageData({required this.locationInfo}) {
    title = locationInfo.cityName;
  }
}

var weatherPages = <WeatherPageData>[];
