import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_weather_client/models/weather_forecast_data.dart';
import 'package:shape_weather/Setting/Configuration.dart';
import 'package:shape_weather/WeatherUI//mainUI.dart';
import 'package:open_weather_client/models/weather_data.dart';

Widget titleText(String text) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
    child: Text(
      text,
      textScaleFactor: 1.3,
      style: const TextStyle(fontWeight: FontWeight.w800),
    ),
  );
}

const Widget empty = Text("");

Widget basicCard(
    {required BuildContext context,
    required Widget? child,
    void Function(BuildContext context)? onTap}) {
  Widget? realChild;
  if (onTap == null) {
    realChild = child;
  } else {
    realChild = InkWell(
        highlightColor: Colors.transparent,
        // 透明色
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        onTap: () {
          onTap(context);
        },
        child: child);
  }
  return Padding(
    padding: const EdgeInsets.all(10),
    child: Container(
        alignment: Alignment.topLeft,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.circular(20)),
          color: Theme.of(context).colorScheme.secondaryContainer,
        ),
        width: double.infinity,
        child: realChild),
  );
}

Widget commonCard(
    {required BuildContext context,
    required String title,
    required Widget? child,
    Widget? icon,
    void Function(BuildContext context)? onTap}) {
  return basicCard(
      onTap: onTap,
      context: context,
      child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [titleText(title), icon ?? empty],
              ),
              child ?? Container()
            ],
          )));
}

abstract class NullableCard<T> extends StatelessWidget {
  final T? parameter;
  final String title;
  late final Widget? icon;
  late final void Function(BuildContext context, T parameter)? onTap;

  NullableCard(
    this.parameter, {
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return commonCard(
        icon: icon,
        context: context,
        title: title,
        child: parameter == null ? loading() : child(context, parameter as T),
        onTap: (context) {
          if (onTap == null || parameter == null) {
            return;
          }
          onTap!(context, parameter as T);
        });
  }

  Widget child(BuildContext context, T parameter);
}

Widget loading() {
  return const Padding(
      padding: EdgeInsets.all(5),
      child: Center(
        child: CircularProgressIndicator(),
      ));
}

class ForecastDataGrid extends StatelessWidget {
  final WeatherData weatherData;
  static final DateFormat dateFormat = DateFormat("M-d H:mm");

  const ForecastDataGrid(this.weatherData, {super.key});

  @override
  Widget build(BuildContext context) {
    var time = DateTime.fromMillisecondsSinceEpoch(weatherData.date * 1000);

    return Padding(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: DecoratedBox(
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusDirectional.circular(20)),
              color: Theme.of(context).colorScheme.onSecondary,
            ),
            child: InkWell(
                onTap: () {
                  pushForecastPage(context, weatherData);
                },
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Text(dateFormat.format(time)),
                        Text(
                          "${weatherData.temperature.currentTemperature}℃",
                          textScaleFactor: 1.2,
                        ),
                        Text(weatherData.details.first.weatherShortDescription),
                        //Text("${weatherData.temperature.tempMin}°~${weatherData.temperature.tempMax}°"),
                      ],
                    )))));
  }
}

void pushForecastPage(BuildContext context, WeatherData weatherData) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    WeatherPageData weatherPageData =
        WeatherPageData(locationInfo: LocationInfo.empty)..title = "Forecast";
    weatherPageData.weatherData.value = weatherData;
    weatherPageData.weatherType = WeatherType.forecast;
    return Scaffold(
      body: WeatherInterface(weatherPageData),
      appBar: AppBar(
        title: const Text("Forecast"),
      ),
    );
  }));
}

class ForecastDataList extends StatelessWidget {
  final WeatherData weatherData;
  static final DateFormat dateFormat = DateFormat("M-d H:mm");
  late final DateTime dateTime;

  ForecastDataList(this.weatherData, {super.key}) {
    dateTime = DateTime.fromMillisecondsSinceEpoch(weatherData.date * 1000);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      // 透明色
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      onTap: () {
        pushForecastPage(context, weatherData);
      },
      child: commonCard(
          context: context,
          title: dateFormat.format(dateTime),
          child: Row(
            children: [
              Text(
                "${weatherData.temperature.currentTemperature}℃",
                textScaleFactor: 1.2,
              ),
              const Spacer(),
              Text(weatherData.details.first.weatherShortDescription),
            ],
          )),
    );
  }
}

class Forecasts extends StatelessWidget {
  final WeatherForecastData weatherForecastData;

  const Forecasts(this.weatherForecastData, {super.key});

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];
    for (var element in weatherForecastData.forecastData) {
      children.add(ForecastDataList(element));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forecasts"),
      ),
      body: ListView(
        children: children,
      ),
    );
  }
}

class CommonCardWithVariableOnClick<T> extends StatelessWidget {
  final String title;
  final Widget? child;
  final Widget? icon;
  final T parameter;
  final void Function(BuildContext, T) onTap;

  const CommonCardWithVariableOnClick(
      {super.key,
      required this.title,
      required this.parameter,
      required this.onTap,
      this.child,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return commonCard(
        context: context,
        title: title,
        child: child,
        icon: icon,
        onTap: (context) {
          onTap(context, parameter);
        });
  }
}

class Fragment extends StatelessWidget {
  final Widget child;
  final String root;

  const Fragment({required this.child, this.root = "/", super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: root,
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
/*        switch (settings.name) {
          case '/':
            builder = (context) => child;
            break;
        }*/
        builder = (context) => child;
        return MaterialPageRoute(builder: builder);
      },
    );
  }
}

class ButtonWithPadding extends StatelessWidget {
  final Function() onPressed;
  final Widget child;

  const ButtonWithPadding(
      {required this.child, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ElevatedButton(
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: child,
          )),
    );
  }
}

Widget textTitle(String text) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
    child: Text(
      "——   $text   ——",
      style: const TextStyle(
          fontWeight: FontWeight.bold, fontSize: 25, color: Colors.greenAccent),
    ),
  );
}

class TextRow extends StatelessWidget {
  final String text;
  final Widget child;
  final String text2;

  const TextRow(this.text, this.child, this.text2, {super.key});

  @override
  Widget build(BuildContext context) {
    var result = MediaQuery.of(context);
    var isThin = result.size.width < 700 && (text2.length + text.length) > 30;
    return isThin
        ? Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text(text), child, Text(text2)],
            ),
        )
        : Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text(text), child, Text(text2)],
            ),
          );
  }
}
