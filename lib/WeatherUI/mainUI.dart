import 'package:flutter/material.dart';
import 'package:open_weather_client/widgets/modules/location_view_widget.dart';
import 'package:shape_weather/Setting/Configuration.dart';
import 'package:shape_weather/weatherAPI.dart';
import 'package:shape_weather/Utils.dart';
import 'package:open_weather_client/models/weather_data.dart';
import 'package:open_weather_client/models/weather_forecast_data.dart';

import 'package:shape_weather/WeatherUI/Background.dart';
import 'Cards.dart';
import 'Control.dart';

class WeatherInterface extends StatefulWidget {
  final WeatherPageData weatherPageData;

  const WeatherInterface(this.weatherPageData, {super.key});

  @override
  State<WeatherInterface> createState() => _WeatherInterfaceState();
}

class _WeatherInterfaceState extends State<WeatherInterface>
    with AutomaticKeepAliveClientMixin {
  WeatherData? weatherData;
  WeatherForecastData? weatherForecastData;
  bool onError = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      child: Stack(
        children: [
          background(),
          foreground(),
        ],
      ),
      onRefresh: () async {
        await getAllData();
      },
    );
  }

  Widget background() {
    if (Theme.of(context).colorScheme.brightness == Brightness.dark) {
      return Opacity(opacity: 0.3, child: const AnimatedGradient());
    }
    return const AnimatedGradient();
  }

  Widget foreground() {
    if (onError) {
      return Center(
        child: TextButton(
          onPressed: getWeatherData,
          child: Text("Tap to Reload"),
        ),
      );
    }

    if (weatherData == null) {
      return Center(child: CircularProgressIndicator());
    } else {
      return ListView(
        children: [
          //LocationView(weatherData: weatherData!),
          Overview(weatherData!),

          (widget.weatherPageData.weatherType == WeatherType.current)
              ? ForecastCard(weatherForecastData)
              : const Text(
                  "",
                  textScaleFactor: 0,
                ),
          WindCard(weatherData!),
          Details(weatherData!),
          WeatherIcon(weatherData!),
          TimeCard(weatherData),
          LocationDetail(weatherData!),

          //AnimatedWeatherCard(),
        ],
      );
    }
  }

  @override
  void initState() {
    weatherData = widget.weatherPageData.weatherData;
    weatherForecastData= widget.weatherPageData.weatherForecastData;
    super.initState();
    getAllData();
  }

  Future getAllData() async {
    if (widget.weatherPageData.weatherType == WeatherType.current) {
      var list=<Future<dynamic>>[];
      if(widget.weatherPageData.weatherData==null){
        list.add(getWeatherData());
      }
      if(widget.weatherPageData.weatherForecastData==null){
        list.add(getWeatherForecastData());
      }

      await Future.wait(list);
    }
  }

  Future getWeatherData() async {
    setState(() {
      onError = false;
    });
    try {
      var data = await Weather.getWeather(widget.weatherPageData.locationInfo);
      widget.weatherPageData.weatherData = data;

      setState(() {
        weatherData = data;
        onError = false;
      });
    } catch (e) {
      showInfoDialog(context: context, title: "Error", content: e.toString());
      setState(() {
        onError = true;
      });
    }
  }

  Future getWeatherForecastData() async {
    var data2 =
        await Weather.getWeatherForecast(widget.weatherPageData.locationInfo);
    widget.weatherPageData.weatherForecastData = data2;
    setState(() {
      weatherForecastData = data2;
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
