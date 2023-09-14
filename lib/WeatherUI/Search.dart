import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_weather_client/models/weather_data.dart';
import 'package:open_weather_client/models/weather_forecast_data.dart';
import 'package:reorderables/reorderables.dart';
import 'package:shape_weather/Utils.dart';
import 'package:shape_weather/WeatherUI/Control.dart';
import 'package:shape_weather/main.dart';
import 'package:shape_weather/weatherAPI.dart';

import '../Setting/Configuration.dart';

class LocationChoose extends StatefulWidget {
  final PageController pageController;
  final Orientation orientation;

  const LocationChoose(this.orientation, this.pageController, {super.key});

  @override
  State<LocationChoose> createState() => _LocationChooseState();
}

class _LocationChooseState extends State<LocationChoose> {
  bool isDelete = false;

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      var row = weatherPages.value.removeAt(oldIndex);
      weatherPages.value.insert(newIndex, row);
    });
    weatherPages.notifyListeners();
  }

  @override
  void activate() {
    super.activate();
    isDelete = false;
  }


  Widget buildChild(BuildContext context) {
    var children = <Widget>[];
    var header = LayoutBuilder(builder: (context, constraints) {
      return Row(
        children: [
          SizedBox(
            width: constraints.maxWidth / 2,
            child: commonCard(
                context: context,
                title: "ADD",
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.add,
                      color: Colors.blueAccent,
                    ),
                  ],
                ),
                onTap: (context) async {
                  await Navigator.push(context,
                      CupertinoPageRoute(builder: (builder) {
                    return const LocationSearch();
                  }));
                  setState(() {});
                }),
          ),
          SizedBox(
            width: constraints.maxWidth / 2,
            child: commonCard(
                onTap: (context) {
                  setState(() {
                    if(weatherPages.value.isEmpty){
                      isDelete = false;
                      return;
                    }
                    isDelete = !isDelete;
                  });
                },
                context: context,
                title: isDelete ? "Cancel" : "Delete",
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      isDelete ? Icons.subdirectory_arrow_left : Icons.delete,
                      color: Colors.red,
                    )
                  ],
                )),
          ),
        ],
      );
    });
    for (int i = 0; i < weatherPages.value.length; i++) {
      children.add(Container(
        key: ObjectKey(weatherPages.value[i]),
        child: commonCard(
            context: context,
            title: weatherPages.value[i].title,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ValueListenableBuilder<WeatherData?>(
                  builder: (context, value, child) {
                    return weatherPages.value[i].weatherData.value == null
                        ? const Text("Unknown")
                        : Text(
                            "${weatherPages.value[i].weatherData.value!.temperature.currentTemperature}℃");
                  },
                  valueListenable: weatherPages.value[i].weatherData,
                ),
                isDelete
                    ? const Text(
                        "✖",
                        style: TextStyle(color: Colors.red),
                      )
                    : ValueListenableBuilder<WeatherData?>(
                        builder: (context, value, child) {
                          return weatherPages.value[i].weatherData.value == null
                              ? const Text("Weather")
                              : Text(weatherPages.value[i].weatherData.value!
                                  .details.first.weatherShortDescription);
                        },
                        valueListenable: weatherPages.value[i].weatherData,
                      ),
              ],
            ),
            onTap: (context) {
              if (isDelete) {
                setState(() {
                  weatherPages.value.remove(weatherPages.value[i]);
                  weatherPages.notifyListeners();
                });
              } else {
                if (widget.orientation == Orientation.landscape) {
                  widget.pageController.animateToPage(i,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.fastEaseInToSlowEaseOut);
                } else {
                  widget.pageController.jumpToPage(i);
                  Navigator.pop(context);
                }
              }
              if(weatherPages.value.isEmpty){
                isDelete = false;
              }
            }),
      ));
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text("Map"),
        ),
        body: ReorderableColumn(
            buildDraggableFeedback: (context, constraints, child) {
              return ConstrainedBox(
                  constraints: constraints,
                  child: Material(
                    color: Colors.transparent,
                    child: child,
                  ));
            },
            header: header,
            crossAxisAlignment: CrossAxisAlignment.start,
            onReorder: _onReorder,
            children: children));
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: weatherPages,
        builder: (context, b, c) {
          return buildChild(context);
        });
  }
}
//-----------------------------------------------------------

class LocationSearch extends StatefulWidget {
  const LocationSearch({super.key});

  @override
  State<LocationSearch> createState() => _LocationSearchState();
}

class _LocationSearchState extends State<LocationSearch> {
  SearchController controller = SearchController();

  void addLocation(LocationInfo locationInfo) {
    var page = WeatherPageData(locationInfo: locationInfo);
    if (weatherPages.value.contains(page)) {
      return;
    }
    weatherPages.value.add(page);
    weatherPages.notifyListeners();
  }

  @override
  void initState() {
    super.initState();
    _increase();
  }

  @override
  void dispose() {
    super.dispose();
    isDispose = true;
  }

  double count = 0;
  final double countMax = 1;
  bool _isFetched = false;
  bool isDispose = false;

  Future _increase() async {
    while (true) {
      if (isDispose) {
        return;
      }
      await Future.delayed(const Duration(milliseconds: 250));

      if (count >= countMax) {
        if (!_isFetched) {
          setState(() {});
          _isFetched = true;
        }

        continue;
      }
      count += 0.5;
    }
  }

  String prevStr = "";

  @override
  Widget build(BuildContext context) {
    controller.addListener(() {
      if (controller.text == "") {
        return;
      }
      if (prevStr == controller.text) {
        return;
      } else {
        prevStr = controller.text;
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
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: SearchBar(
                  controller: controller,
                  padding: const MaterialStatePropertyAll<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 16.0)),
                  leading: const Icon(Icons.search),
                  trailing: [
                    IconButton(
                      onPressed: () async {
                        late CityLocationData location;
                        await showLoadingDialog(
                            context: context,
                            func: () async {
                              location = await Weather.getCityByIP();
                            },
                            onError: () {
                              showInfoDialog(
                                  context: context,
                                  title: "Error",
                                  content:
                                      "Can not locate\nPs:Web version is not supported now");
                            });

                        setState(() {
                          addLocation(LocationInfo.formCityData(location));
                        });

                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.gps_fixed_rounded),
                    )
                  ], //const Icon(Icons.gps_fixed_rounded)
                ),
              ),
            ),
            controller.text == ""
                ? empty
                : FutureBuilder(
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
                          var cities =
                              (snapshot.data as List<CityLocationData>);
                          var children = <Widget>[];
                          for (var i in cities) {
                            late String text;
                            if (i.state == "") {
                              text = "Country : ${i.country}";
                            } else {
                              text = "${i.country},${i.state}";
                            }
                            children.add(CommonCardWithVariableOnClick(
                                icon: const Icon(Icons.add),
                                title: i.name,
                                parameter: i,
                                onTap: (BuildContext context,
                                    CityLocationData citiesData) {
                                  setState(() {
                                    addLocation(
                                        LocationInfo.formCityData(citiesData));
                                  });
                                  Navigator.pop(context);
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                      child: Text(
                                        text,
                                        textAlign: TextAlign.start,
                                        textScaleFactor: 1.1,
                                      ),
                                    ),
                                    Text(
                                        "Latitude ${i.lat.toStringAsFixed(2)} & Longitude ${i.lon.toStringAsFixed(2)}"),
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
    try {
      var result1 = await Weather.getCitiesByName(cityName);
      if (result1.isNotEmpty) {
        return result1;
      }
    } catch (e) {
      debugPrint(
          "get locations failed,use another method ,reason${e.toString()}");
    }

    var result2 = await Weather.getWeather(LocationInfo(cityName));
    return [
      CityLocationData()
        ..lon = result2.coordinates!.lon
        ..lat = result2.coordinates!.lat
        ..name = result2.name!
    ];
  }
}
