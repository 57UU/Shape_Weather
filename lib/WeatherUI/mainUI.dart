import 'package:flutter/material.dart';
import 'package:shape_weather/Setting/Configuration.dart';
import 'package:shape_weather/weatherAPI.dart';
import 'package:shape_weather/Utils.dart';

import 'package:shape_weather/WeatherUI/Background.dart';
import 'Cards.dart';

class WeatherInterface extends StatefulWidget {
  final WeatherPageData weatherPageData;

  const WeatherInterface(this.weatherPageData, {super.key});

  @override
  State<WeatherInterface> createState() => _WeatherInterfaceState();
}

class _WeatherInterfaceState extends State<WeatherInterface>
    with AutomaticKeepAliveClientMixin {
  bool onError = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      child: ListenableBuilder(
        builder: (context, child) {
          return appSetting.value[enable_dynamic_backgorund]??true
              ? Stack(
                  children: [
                    background(),
                    foreground(),
                  ],
                )
              : foreground();
        },
        listenable: appSetting,
      ),
      onRefresh: () async {
        if(widget.weatherPageData.weatherType == WeatherType.current){
          await getAllDataForce();
        }
        
      },
    );
  }

  Widget background() {
    if (Theme.of(context).colorScheme.brightness == Brightness.dark) {
      return const Opacity(opacity: 0.3, child: AnimatedGradient());
    }
    return const AnimatedGradient();
  }

  Widget foreground() {
    if (onError) {
      return Center(
        child: TextButton(
          onPressed: getWeatherData,
          child: const Text("Tap to Reload"),
        ),
      );
    }

    if (widget.weatherPageData.weatherData.value == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      //var children=<Widget>[];
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            //LocationView(weatherData: weatherData!),
            Overview(widget.weatherPageData.weatherData.value!),

            (widget.weatherPageData.weatherType == WeatherType.current)
                ? ForecastGraphCard(
                    widget.weatherPageData.weatherForecastData.value)
                : const Text(
                    "",
                    textScaleFactor: 0,
                  ),
            (widget.weatherPageData.weatherType == WeatherType.current)
                ? ForecastCard(widget.weatherPageData.weatherForecastData.value)
                : const Text(
                    "",
                    textScaleFactor: 0,
                  ),
            (widget.weatherPageData.weatherType == WeatherType.current)
                ? AqiDetail(widget.weatherPageData.weatherAqiData.value)
                : const Text(
                    "",
                    textScaleFactor: 0,
                  ),
            
            WindCard(widget.weatherPageData.weatherData.value!),
            Details(widget.weatherPageData.weatherData.value!),
            WeatherIcon(widget.weatherPageData.weatherData.value!),
            TimeCard(widget.weatherPageData.weatherData.value),
            LocationDetail(widget.weatherPageData.weatherData.value!),
            EditCard(widget.weatherPageData),

            //AnimatedWeatherCard(),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getAllData();
  }

  Future getAllData() async {
    if (widget.weatherPageData.weatherType == WeatherType.current) {
      var list = <Future<dynamic>>[];
      if (widget.weatherPageData.weatherData.value == null) {
        list.add(getWeatherData());
      }
      if (widget.weatherPageData.weatherForecastData.value == null) {
        list.add(getWeatherForecastData());
      }
      if (widget.weatherPageData.weatherAqiData.value == null) {
        list.add(getWeatherAQIData());
      }
      await Future.wait(list);
    }
  }

  Future getAllDataForce() async {
    await Future.wait(
        [getWeatherData(), getWeatherForecastData(), getWeatherAQIData()]);
  }

  Future getWeatherData() async {
    setState(() {
      onError = false;
    });
    try {
      var data = await Weather.getWeather(widget.weatherPageData.locationInfo);
      widget.weatherPageData.weatherData.value = data;

      setState(() {
        widget.weatherPageData.weatherData.value = data;
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
    setState(() {
      widget.weatherPageData.weatherForecastData.value = data2;
    });
  }

  Future getWeatherAQIData() async {
    var data3 = await Weather.getCityAIQ(widget.weatherPageData.locationInfo);
    setState(() {
      widget.weatherPageData.weatherAqiData.value = data3;
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
