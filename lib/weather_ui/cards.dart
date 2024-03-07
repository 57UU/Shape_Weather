
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_weather_client/models/weather_data.dart';
import 'package:open_weather_client/models/weather_forecast_data.dart';

import 'package:shape_weather/libs/utils.dart';
import 'package:shape_weather/setting/weather_data.dart';
import 'package:shape_weather/weather_ui/aqi_detail_page.dart';
import 'package:shape_weather/weather_ui/edit_page.dart';
import 'package:shape_weather/libs/weather_api.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'controls.dart';

class Overview extends StatelessWidget {
  final WeatherData data;

  const Overview(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      return Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 90),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 100, 0, 50),
                  child: Stack(alignment: Alignment.center, children: [
                    Text(data.temperature.currentTemperature.toString(),
                        textScaler: const TextScaler.linear(4),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                    Positioned(
                        right: constrains.maxWidth / 2 - 100,
                        top: 10,
                        child: const Text(
                          "℃",
                          textScaler: TextScaler.linear(1.5),
                        ))
                  ]),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Opacity(
                    opacity: 0.8,
                    child: OutlinedButton(
                      child: Text(data.details.first.weatherShortDescription),
                      onPressed: () {
                        showInfoDialog(
                            context: context,
                            title: "Weather Description",
                            content: data.details.first.weatherLongDescription);
                      },
                    ),
                  ),
                  const Text("  "),
                  Opacity(
                    opacity: 0.8,
                    child: OutlinedButton(
                      child: Text("Feels like ${data.temperature.feelsLike}°"),
                      onPressed: () {
                        showInfoDialog(
                            context: context,
                            title: "Temperature",
                            content:
                                "Feels like ${data.temperature.feelsLike}\n"
                                "Min ${data.temperature.tempMin}\n"
                                "Max ${data.temperature.tempMax}\n");
                      },
                    ),
                  )
                ],
              )
            ],
          ));
    });
  }
}

class OverviewCard extends StatelessWidget {
  const OverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class WindCard extends StatelessWidget {
  final WeatherData weatherData;

  const WindCard(this.weatherData, {super.key});

  @override
  Widget build(BuildContext context) {
    return basicCard(
      child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  titleText("Wind"),
                  Text("Speed ${weatherData.wind.speed}m/s"),
                  Text("Direction ${weatherData.wind.deg}°"),
                  Text("Gust ${weatherData.wind.gust ?? " N/A "}"),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: Transform.rotate(
                  angle: weatherData.wind.deg / 180 * pi,
                  child: const Text(
                    "↑",
                    textScaler: TextScaler.linear(2.3),
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              )
            ],
          )),
      context: context,
    );
  }
}

class ForecastCard extends NullableCard<WeatherForecastData> {
  ForecastCard(super.parameter, {super.key, super.title = "Forecast"});
  @override
  void onTap(BuildContext context, WeatherForecastData parameter) {
    Navigator.push(context, MaterialPageRoute(builder: (builder) {
      return Forecasts(parameter);
    }));
  }

  @override
  Widget child(BuildContext context, WeatherForecastData parameter) {
    var children = <Widget>[];
    for (var element in parameter.forecastData) {
      children.add(ForecastDataGrid(element));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: children,
      ),
    );
  }
}

class TimeCard extends NullableCard<WeatherData> {
  const TimeCard(super.parameter, {super.key, super.title = "Time"});
  @override
  Widget? getIcon() {
    // TODO: implement getIcon
    return const Icon(Icons.watch_later_outlined);
  }

  @override
  Widget child(BuildContext context, WeatherData parameter) {
    var time = DateTime.fromMillisecondsSinceEpoch(parameter.date * 1000);
    DateFormat formatter = DateFormat('y-M-d H:m:s');
    return Text("Time at ${formatter.format(time)}");
  }
}

class Details extends StatelessWidget {
  final WeatherData weatherData;

  const Details(this.weatherData, {super.key});

  @override
  Widget build(BuildContext context) {
    return commonCard(
        context: context,
        title: "Details",
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Pressure ${weatherData.temperature.pressure}hPa"),
            Text("Humidity ${weatherData.temperature.humidity}%"),
          ],
        ));
  }
}

class WeatherIcon extends StatelessWidget {
  final WeatherData weatherData;

  const WeatherIcon(this.weatherData, {super.key});

  @override
  Widget build(BuildContext context) {
    return commonCard(
      context: context,
      title: "Icon",
      child: null,
      icon: Image.network(
          "https://openweathermap.org/img/wn/${weatherData.details.first.icon}.png"),
    );
  }
}

class LocationDetail extends StatelessWidget {
  final WeatherData weatherData;

  const LocationDetail(this.weatherData, {super.key});

  @override
  Widget build(BuildContext context) {
    return commonCard(
        context: context,
        title: "Location",
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                "Latitude ${weatherData.coordinates == null ? 'Unknown' : weatherData.coordinates!.lat}"),
            Text(
                "Latitude ${weatherData.coordinates == null ? 'Unknown' : weatherData.coordinates!.lon}"),
          ],
        ));
  }
}

class AqiDetail extends NullableCard<WeatherAQIData> {
  const AqiDetail(
    super.parameter, {
    super.key,
    super.title = "AQI",
  });

  @override
  void onTap(BuildContext context, WeatherAQIData parameter) {
    Navigator.of(context).push(MaterialPageRoute(builder: (builder) {
      return AqiDetailPage(parameter);
    }));
  }

  static var aqiDetailRank = <String>[
    "Good",
    "Fair",
    "Moderate",
    "Poor",
    "Very Poor"
  ];

  @override
  Widget child(BuildContext context, WeatherAQIData parameter) {
    var orientation = MediaQuery.of(context).orientation;
    var children = orientation == Orientation.portrait
        ? <Widget>[
            AqiGrid("AQI", aqiDetailRank[parameter.aqi - 1]),
            AqiGrid("O₃", parameter.o3),
            AqiGrid("SO₂", parameter.so2),
            AqiGrid("PM₂.₅", parameter.pm2_5),
            AqiGrid("PM₁₀", parameter.pm10),
          ]
        : <Widget>[
            AqiGrid("AQI", aqiDetailRank[parameter.aqi - 1]),
            AqiGrid("PM₂.₅", parameter.pm2_5),
            AqiGrid("PM₁₀", parameter.pm10),
            AqiGrid("CO", parameter.co),
            AqiGrid("NO", parameter.no),
            AqiGrid("NO₂", parameter.no2),
            AqiGrid("O₃", parameter.o3),
            AqiGrid("SO₂", parameter.so2),
            AqiGrid("NH₃", parameter.nh3),
          ];

    return Wrap(
      spacing: 1,
      runSpacing: 1,
      children: children,
    );
  }
}

class ForecastGraphCard extends NullableCard<WeatherForecastData> {
  static final DateFormat dateFormatDay = DateFormat("M/d");
  static final DateFormat dateFormatTime = DateFormat("H:mm");

  ForecastGraphCard(super.parameter,
      {super.key, super.title = "Forecast Graph"}) {
  }
  @override
  void onTap(BuildContext context, WeatherForecastData parameter) {
    Navigator.push(context, MaterialPageRoute(builder: (builder) {
      return Forecasts(parameter);
    }));
  }

  @override
  Widget child(BuildContext context, WeatherForecastData parameter) {
    final today = DateTime.now();

    var tempMax = getMax(
            parameter.forecastData,
            (a, b) => a.temperature.currentTemperature
                .compareTo(b.temperature.currentTemperature))
        .temperature
        .currentTemperature;
    var tempMin = getMin(
            parameter.forecastData,
            (a, b) => a.temperature.currentTemperature
                .compareTo(b.temperature.currentTemperature))
        .temperature
        .currentTemperature;
    Widget child = SfCartesianChart(
      primaryXAxis: const CategoryAxis(
        labelIntersectAction: AxisLabelIntersectAction.rotate45,
        //dateFormat: dateFormat,
        majorGridLines: MajorGridLines(width: 1),
      ),
      primaryYAxis: NumericAxis(
          minimum: tempMin,
          maximum: tempMax + 1,
          //axisLine: const AxisLine(width: 10),
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          labelFormat: '{value}℃',
          majorTickLines: const MajorTickLines(size: 0)),
      series: <CartesianSeries>[
        // Renders spline chart
        SplineSeries<WeatherData, String>(
          dataSource: parameter.forecastData,
          xValueMapper: (var data, _) {
            var time = (DateTime.fromMillisecondsSinceEpoch(data.date * 1000));
            if (time.month == today.month && time.day == today.day) {
              return "Today-${dateFormatTime.format(time)}";
            }
            return "${dateFormatDay.format(time)}-${dateFormatTime.format(time)}";
          },
          yValueMapper: (var data, _) => data.temperature.currentTemperature,
          name: "Expected",
        ),
      ],
    );
/*    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: child
    );*/
    return child;
  }
}

class EditCard extends StatelessWidget {
  final WeatherPageData weatherPageData;

  const EditCard(this.weatherPageData, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextButton(
          child: const Text("Edit"),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (builder) {
              return EditPage(weatherPageData);
            }));
          },
        ),
      ),
    );
  }
}
