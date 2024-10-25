import 'package:flutter/material.dart';
import 'package:shape_weather/setting/configuration.dart';
import 'package:shape_weather/libs/weather_api.dart';
import 'package:shape_weather/libs/utils.dart';

import 'package:shape_weather/weather_ui/widgets/background.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../setting/weather_data.dart';
import 'widgets/cards.dart';

class WeatherInterface extends StatefulWidget {
  final WeatherPageData weatherPageData;

  const WeatherInterface(this.weatherPageData, {super.key});

  @override
  State<WeatherInterface> createState() => _WeatherInterfaceState();
}

class _WeatherInterfaceState extends State<WeatherInterface>
    with AutomaticKeepAliveClientMixin {
  bool onError = false;
  Widget? cachedBackground;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      child: ListenableBuilder(
        builder: (context, child) {
          return appSetting.value[enable_dynamic_background] ?? true
              ? Stack(
                  children: [
                    cachedBackground=cachedBackground??background(),
                    foreground(),
                  ],
                )
              : foreground();
        },
        listenable: appSetting,
      ),
      onRefresh: () async {
        if (widget.weatherPageData.weatherType == WeatherType.current) {
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
          child: Text(AppLocalizations.of(context)!.tap2Reload),
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
                    widget.weatherPageData.weatherForecastData.value,
                    title: AppLocalizations.of(context)!.forecastGraph,
                  )
                : Container(),
            (widget.weatherPageData.weatherType == WeatherType.current)
                ? ForecastCard(
                    widget.weatherPageData.weatherForecastData.value,
                    title: AppLocalizations.of(context)!.forecasts,
                  )
                : Container(),
            (widget.weatherPageData.weatherType == WeatherType.current)
                ? AqiDetail(widget.weatherPageData.weatherAqiData.value)
                : Container(),

            WindCard(widget.weatherPageData.weatherData.value!),
            Details(widget.weatherPageData.weatherData.value!),
            WeatherIcon(widget.weatherPageData.weatherData.value!),
            TimeCard(
              widget.weatherPageData.weatherData.value,
              title: AppLocalizations.of(context)!.time,
            ),
            (widget.weatherPageData.weatherType == WeatherType.current)
                ? LocationDetail(widget.weatherPageData.weatherData.value!)
                : Container(),
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
      if (context.mounted) {
        showInfoDialog(
            context: context,
            title: AppLocalizations.of(context)!.error,
            content: e.toString());
      }

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
  bool get wantKeepAlive => true;
}
