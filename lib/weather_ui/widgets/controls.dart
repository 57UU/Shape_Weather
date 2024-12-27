import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_weather_client/models/weather_forecast_data.dart';
import 'package:shape_weather/setting/configuration.dart';
import 'package:shape_weather/weather_ui/main_ui.dart';
import 'package:open_weather_client/models/weather_data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shape_weather/weather_ui/widgets/cards.dart';
import 'ui_utils.dart';

import '../../setting/weather_data.dart';

Widget titleText(String text) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
    child: Text(
      text,
      textScaler: const TextScaler.linear(1.3),
      style: const TextStyle(fontWeight: FontWeight.w800),
    ),
  );
}

const Widget empty = Text("");

class BasicCard extends StatelessWidget {
  final void Function(BuildContext context)? onTap;
  final Widget? child;

  const BasicCard({super.key, required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
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
            onTap!(context);
          },
          child: SizedBox(width: double.infinity, child: child));
    }
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
          alignment: Alignment.topLeft,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(20)),
            color: Theme.of(context).colorScheme.secondaryContainer,
            shadows: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1), //color of shadow
                spreadRadius: 0.1, //spread radius
                blurRadius: 10, // blur radius
                //offset: Offset(0, 2), // changes position of shadow
                //first parameter of offset is left-right
                //second parameter is top to down
              )
            ],
          ),
          width: double.infinity,
          child: realChild),
    );
  }
}

@Deprecated("immigrate to BasicCard")
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
          shadows: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), //color of shadow
              spreadRadius: 0.1, //spread radius
              blurRadius: 10, // blur radius
              //offset: Offset(0, 2), // changes position of shadow
              //first parameter of offset is left-right
              //second parameter is top to down
            )
          ],
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
  return BasicCard(
      onTap: onTap,
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
  final bool isFailed;

  void onTap(BuildContext context, T parameter) {}

  Widget? getIcon() {
    return null;
  }

  const NullableCard(
    this.parameter, {
    super.key,
    required this.title,
    this.isFailed = false,
  });

  @override
  Widget build(BuildContext context) {
    return commonCard(
        icon: getIcon(),
        context: context,
        title: title,
        child: AnimatedSize(
            duration: cardSizeAnimationDuration,
            curve: Curves.easeOutQuart,
            child: this.isFailed
                ? failedChild(context)
                : (parameter == null
                    ? loading()
                    : child(context, parameter as T))),
        onTap: (context) {
          if (parameter == null) {
            return;
          }
          onTap(context, parameter as T);
        });
  }

  Widget child(BuildContext context, T parameter);

  Widget failedChild(BuildContext context) {
    return const Text("Failed");
  }
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
                  final page=buildForecastPage(context, weatherData, time);
                  popupOrNavigate(context,page,useFragment: false);
                },
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Text(dateFormat.format(time)),
                        Text(
                          "${weatherData.temperature.currentTemperature}℃",
                          textScaler: const TextScaler.linear(1.2),
                        ),
                        Text(weatherData.details.first.weatherShortDescription),
                        //Text("${weatherData.temperature.tempMin}°~${weatherData.temperature.tempMax}°"),
                      ],
                    )))));
  }
}
Widget buildForecastPage(BuildContext context, WeatherData weatherData, DateTime dateTime){
  WeatherPageData weatherPageData =
  WeatherPageData(locationInfo: LocationInfo.empty)
    ..title = AppLocalizations.of(context)!.forecast;
  weatherPageData.weatherData.value = weatherData;
  weatherPageData.weatherType = WeatherType.forecast;
  var deltaTime = dateTime.difference(DateTime.now());
  var hours = deltaTime.inHours;

  return Scaffold(
    body: WeatherInterface(weatherPageData),
    appBar: AppBar(
      title: Text(
          "${hours == 0 ? AppLocalizations.of(context)!.minutes(deltaTime.inMinutes) : AppLocalizations.of(context)!.hours(hours)} ${AppLocalizations.of(context)!.later}"),
    ),
  );
}
void pushForecastPage(BuildContext context, WeatherData weatherData, DateTime dateTime) {

  Navigator.push(context, CupertinoPageRoute(builder: (context) {
    return buildForecastPage(context, weatherData, dateTime);
  }));
}

class ForecastDataListElement extends StatelessWidget {
  final WeatherData weatherData;
  static final DateFormat dateFormat = DateFormat("M-d H:mm");
  late final DateTime dateTime;

  ForecastDataListElement(this.weatherData, {super.key}) {
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
        pushForecastPage(context, weatherData, dateTime);
      },
      child: commonCard(
          context: context,
          title: dateFormat.format(dateTime),
          child: Row(
            children: [
              Text(
                "${weatherData.temperature.currentTemperature}℃",
                textScaler: const TextScaler.linear(1.2),
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
      children.add(ForecastDataListElement(element));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.forecasts),
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

EdgeInsets _settingPadding = const EdgeInsets.all(10);

class ButtonWithPadding extends StatelessWidget {
  final Function() onPressed;
  final Widget child;
  final Widget? icon;

  const ButtonWithPadding(
      {required this.child, required this.onPressed, super.key, this.icon});

  @override
  Widget build(BuildContext context) {
    Widget realChild;
    if (icon != null) {
      realChild = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Container(), child, icon!],
      );
    } else {
      realChild = child;
    }
    return Padding(
      padding: _settingPadding,
      child: ElevatedButton(
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: realChild,
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
    return LayoutBuilder(builder: (builder, constraints) {
      //var result = MediaQuery.of(context);
      var isThin =
          constraints.maxWidth < 700 && (text2.length + text.length) > 30;
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
    });
  }
}

class AqiGrid extends StatelessWidget {
  final String title;
  final Object data;

  const AqiGrid(this.title, this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
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
                  )))),
    );
  }
}

class SwitchRow extends StatefulWidget {
  final String text;
  final String valueKey;
  final String title;
  final String content;

  const SwitchRow(
      {super.key,
      required this.text,
      required this.valueKey,
      required this.title,
      required this.content});

  @override
  State<SwitchRow> createState() => _SwitchRowState();
}

class _SwitchRowState extends State<SwitchRow> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _settingPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(widget.text),
          IconButton(
              onPressed: () {
                showInfoDialog(
                    context: context,
                    title: widget.title,
                    content: widget.content);
              },
              icon: const Icon(Icons.info_outlined)),
          const Spacer(
            flex: 1,
          ),
          Switch(
              value: appSetting.value[widget.valueKey]!,
              onChanged: (value) {
                appSetting.value[widget.valueKey] = value;
                appSetting.notifyListeners();
                setState(() {});
              }),
          const Spacer(
            flex: 1,
          ),
        ],
      ),
    );
  }
}

class VerticalPadding extends StatelessWidget {
  const VerticalPadding({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(padding: EdgeInsets.symmetric(vertical: 10));
  }
}

class HorizontalPadding extends StatelessWidget {
  const HorizontalPadding({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(padding: EdgeInsets.symmetric(horizontal: 10));
  }
}
