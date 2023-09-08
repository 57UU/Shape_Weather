import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_weather_client/models/weather_data.dart';
import 'package:open_weather_client/widgets/modules/location_view_widget.dart';
import 'package:shape_weather/WeatherUI/Control.dart';
import 'package:shape_weather/main.dart';
import 'package:shape_weather/weatherAPI.dart';

import '../Setting/Configuration.dart';

class LocationChoose extends StatefulWidget {
  final PageController pageController;

  const LocationChoose(this.pageController, {super.key});

  @override
  State<LocationChoose> createState() => _LocationChooseState();
}

class _LocationChooseState extends State<LocationChoose> {
  @override
  Widget build(BuildContext context) {
    var children = <Widget>[
      commonCard(
          context: context,
          title: "ADD",
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.add),
            ],
          ),
          onTap: (context) async {
            await Navigator.push(context, CupertinoPageRoute(builder: (builder) {
              return LocationSearch();
            }));
            setState(() {

            });
          })
    ];
    for (int i = 0; i < weatherPages.length; i++) {
      children.add(commonCard(
          context: context,
          title: weatherPages[i].title,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              weatherPages[i].weatherData == null
                  ? const Text("Unknown")
                  : Text(
                      "${weatherPages[i].weatherData!.temperature.currentTemperature}℃"),
              weatherPages[i].weatherData == null
                  ? const Text("Weather")
                  : Text(weatherPages[i]
                      .weatherData!
                      .details
                      .first
                      .weatherShortDescription),
            ],
          ),
          onTap: (context) {
            widget.pageController.jumpToPage(i);
            Navigator.pop(context);
          }));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map"),
      ),
      body: ListView(
        children: children,
      ),
    );
  }
}

class LocationSearch extends StatefulWidget {
  const LocationSearch({super.key});

  @override
  State<LocationSearch> createState() => _LocationSearchState();
}

class _LocationSearchState extends State<LocationSearch> {
  SearchController controller = SearchController();

  @override
  void initState() {
    super.initState();
    _increase();
  }

  int count = 0;
  final int countMax = 1;
  bool _isFetched = false;
  bool isDispose = false;

  Future _increase() async {
    while (true) {
      if (isDispose) {
        return;
      }
      await Future.delayed(const Duration(seconds: 1));

      if (count >= countMax) {
        if (!_isFetched) {
          setState(() {});
          _isFetched = true;
        }

        continue;
      }
      count++;
    }
  }

  @override
  Widget build(BuildContext context) {
    controller.addListener(() {
      if (controller.text == "") {
        return;
      }
      _isFetched = false;

      count = 0;
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(11, 11, 11, 20),
              child: SearchBar(
                controller: controller,
                padding: const MaterialStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 16.0)),
                leading: const Icon(Icons.search),
              ),
            ),
            FutureBuilder(
              future: searchProvider(controller.text),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                // 请求已结束
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    // 请求失败，显示错误
                    return const Text(
                      "Can not fetch data",
                      textAlign: TextAlign.center,
                    );
                  } else {
                    // 请求成功，显示数据
                    var cities = (snapshot.data as List<CityLocationData>);
                    var children = <Widget>[];
                    for (var i in cities) {
                      late String text;
                      if(i.state==""){
                        text="Country : ${i.country}";
                      }else{
                        text="${i.country},${i.state}";
                      }
                      children.add(CommonCardWithVariableOnClick(
                          icon: const Icon(Icons.add),
                          title: i.name,
                          parameter: i,
                          onTap: (BuildContext context, CityLocationData citiesData) {
                            setState(() {
                              updateWeatherPages(WeatherPageData(
                                  locationInfo:
                                      LocationInfo.formCityData(citiesData)));
                            });
                            Navigator.pop(context);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                child: Text(
                                  text,
                                  textAlign: TextAlign.start,
                                  textScaleFactor: 1.1,
                                ),
                              ),
                              Text("Latitude ${i.lat.toStringAsFixed(2)} & Longitude ${i.lon.toStringAsFixed(2)}"),
                            ],
                          )));
                    }
                    return Column(
                      children: children,
                    );
                  }
                } else {
                  // 请求未结束，显示loading
                  return const Padding(
                    padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Future<List<CityLocationData>> searchProvider(String cityName) async {
    if (cityName == "") {
      return [];
    }
    //await Future.delayed(Duration(seconds: 1));
    try{
      var result1=await Weather.getCitiesByName(cityName);
      if(result1.length!=0){
        return result1;
      }
    }catch(e){}

    var result2=await Weather.getWeather(LocationInfo(cityName));
    return [CityLocationData()..lon=result2.coordinates!.lon
      ..lat=result2.coordinates!.lat..name=result2.name!];

  }
}
