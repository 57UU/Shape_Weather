import 'package:flutter/material.dart';
import 'package:shape_weather/libs/index.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'widgets/controls.dart';

class AqiDetailPage extends StatelessWidget {
  final WeatherAQIData weatherAQIData;

  const AqiDetailPage(this.weatherAQIData, {super.key});

  static List<String>? aqiDetailRank;

  @override
  Widget build(BuildContext context) {
    aqiDetailRank ??= <String>[
      AppLocalizations.of(context)!.good,
      AppLocalizations.of(context)!.fair,
      AppLocalizations.of(context)!.moderate,
      AppLocalizations.of(context)!.poor,
      AppLocalizations.of(context)!.veryPoor
    ];

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
          title: Text(AppLocalizations.of(context)!.airQualityIndex),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: AqiGridBig("AQI", aqiDetailRank![weatherAQIData.aqi - 1]),
                )),
            Wrap(
              children: children,
            ),
            commonCard(context: context, title: AppLocalizations.of(context)!.note, child: Center(child: Column(
              children: [
                Text(AppLocalizations.of(context)!.dataUnitHint),
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
    return LayoutBuilder(
      builder: (context,constraints) {
        double width=constraints.maxWidth;
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
    );
  }
}
