import 'package:open_weather_client/models/weather_data.dart';
import 'package:open_weather_client/models/weather_forecast_data.dart';
import 'package:shape_weather/weatherAPI.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
const String _key="config";
Future saveConfig()async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var list=<String>[];
  for(var i in weatherPages){
    list.add("${i.locationInfo.lon}/${i.locationInfo.lat}/${i.locationInfo.cityName}");
  }
  prefs.setStringList(_key, list);

}
Future<String> loadConfig()async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var list=prefs.getStringList(_key);
  if(list==null){
    return "Error";
  }
  weatherPages.clear();

  for(String i in list){
    var splited=i.split("/");
    late LocationInfo locationInfo=LocationInfo(splited[2]);
    locationInfo.lon=double.parse(splited[0]) ;
    locationInfo.lat=double.parse(splited[1]);
    weatherPages.add(WeatherPageData(locationInfo: locationInfo));
  }
  return "Done";

}