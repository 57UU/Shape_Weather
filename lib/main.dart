import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shape_weather/Setting/Configuration.dart';
import 'package:shape_weather/Setting/Setting.dart';
import 'package:shape_weather/WeatherUI/Search.dart';
import 'package:shape_weather/WeatherUI/Welcome.dart';

import 'WeatherUI/Control.dart';
import 'WeatherUI/mainUI.dart';

void main() {
  //test();
  runApp(const MyApp());
}

GlobalKey<_HomePageState> _globalKey = GlobalKey<_HomePageState>();

void updateWeatherPages(WeatherPageData weatherPageData) {
  _globalKey.currentState?.setState(() {
    weatherPages.add(weatherPageData);
  });
  //weatherPages.add(weatherPageData);
  saveConfig();
}

void clearWeatherPages() {
  _globalKey.currentState?.setState(() {
    weatherPages.clear();
  });
  //weatherPages.add(weatherPageData);
  saveConfig();
}

void deleteWeatherPageData(WeatherPageData weatherPageData) {
  _globalKey.currentState?.setState(() {
    weatherPages.remove(weatherPageData);
  });
  //weatherPages.add(weatherPageData);
  saveConfig();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shape Weather',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      home: FutureBuilder<String>(
        future: loadConfig(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // 请求已结束
          if (snapshot.connectionState == ConnectionState.done) {

              return OrientationBuilder(
                builder: (context, orientation) {
                  return HomePage(
                    orientation,
                    key: _globalKey,
                  );
                },
              );



          } else {
            // 请求未结束，显示loading
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final Orientation orientation;

  const HomePage(this.orientation, {super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String title;

  final PageController pageController = PageController();

  @override
  void initState() {
    super.initState();

/*    for (var i in ["chengdu", "guangdong", "shuangliu"]) {
      weatherPages.add(WeatherPageData(locationInfo: LocationInfo(i)));
    }*/
    if (!weatherPages.isEmpty) {
      title = weatherPages.first.title;
    }
  }

  @override
  Widget build(BuildContext context) {
    var pages = <Widget>[];

    for (WeatherPageData weatherPageData in weatherPages) {
      pages.add(WeatherInterface(weatherPageData));
    }
    if (weatherPages.isEmpty) {
      return const Welcome();
    }
    bool isLandscape=widget.orientation==Orientation.landscape;
    if (weatherPages.length == 1) {
      title = weatherPages.first.title;
    }
    var mainWidget=Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              isLandscape?empty: IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (builder) {
                          return LocationChoose(widget.orientation,pageController);
                        }));
                  },
                  icon: const Icon(Icons.map)),
              Text(title),
              IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (builder) {
                          return Setting();
                        }));
                  },
                  icon: const Icon(Icons.settings))
            ],
          ),
        ),
        body: PageView(
          controller: pageController,
          onPageChanged: (int num) {
            setState(() {
              title = weatherPages[num].title;
            });
          },
          children: pages,
        ));
    if(isLandscape){
      var width =MediaQuery.of(context).size.width;
      var locationChooseWidth=width*2/5;
      double widthMax=350;
      if(locationChooseWidth>widthMax){
        locationChooseWidth=widthMax;
      }
      return Row(children: [

        SizedBox(width:locationChooseWidth,child: LocationChoose(widget.orientation,pageController)),
        SizedBox(width: width-locationChooseWidth,child: mainWidget)
      ],);
    }else{
      return mainWidget;
    }


    //return MyWidget();

  }
}
