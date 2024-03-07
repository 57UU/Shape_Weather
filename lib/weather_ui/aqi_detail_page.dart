import 'package:flutter/material.dart';
import 'package:shape_weather/libs/weather_api.dart';

import 'controls.dart';

class AqiDetailPage extends StatelessWidget {
  final WeatherAQIData weatherAQIData;

  const AqiDetailPage(this.weatherAQIData, {super.key});

  static var AQI_DETAIL = <String>[
    "Good",
    "Fair",
    "Moderate",
    "Poor",
    "Very Poor"
  ];

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[
      AqiGridBig("CO", weatherAQIData.co),
      AqiGridBig("NO", weatherAQIData.no),
      AqiGridBig("NO₂", weatherAQIData.no2),
      AqiGridBig("O₃", weatherAQIData.o3),
      AqiGridBig("SO₂", weatherAQIData.so2),
      AqiGridBig("PM₂.₅", weatherAQIData.pm2_5),
      AqiGridBig("PM₁₀", weatherAQIData.pm10),
      AqiGridBig("NH₃", weatherAQIData.nh3),
    ];
    return Scaffold(
        appBar: AppBar(
          title: const Text("Air Quality Index"),
        ),
        body: Column(
          children: [
            SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: AqiGridBig("AQI", AQI_DETAIL[weatherAQIData.aqi - 1]),
                )),
            Wrap(
              children: children,
            ),
            commonCard(context: context, title: "Note", child: const Center(child: Column(
              children: [
                Text("All the data are based on unit μg/m³"),
              ],
            ),))
          ],
        ));
  }
}

class AqiGridBig extends StatelessWidget {
  final String title;
  final Object data;

  const AqiGridBig(this.title, this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width / 2 - 20,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
        child: DecoratedBox(
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusDirectional.circular(20)),
              color: Theme.of(context).colorScheme.onSecondary,
            ),
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text(
                      title,
                      textScaler: const TextScaler.linear(1.2),
                    ),
                    Text(data.toString()),
                  ],
                ))),
      ),
    );
  }
}
