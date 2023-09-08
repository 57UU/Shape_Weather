import 'package:flutter/material.dart';
import 'package:shape_weather/Setting/Configuration.dart';
import 'package:shape_weather/Setting/Setting.dart';
import 'package:shape_weather/WeatherUI/Search.dart';
import 'package:shape_weather/WeatherUI/Welcome.dart';

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

void deleteWeatherPageData(WeatherPageData weatherPageData) {}

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
            if (snapshot.hasError) {
              // 请求失败，显示错误
              return HomePage(key: _globalKey,);
            } else {
              // 请求成功，显示数据
              return HomePage(key: _globalKey,);
            }
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
  const HomePage({super.key});

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
    if (weatherPages.isEmpty) {
      return const Welcome();
    }
    if (weatherPages.length == 1) {
      title = weatherPages.first.title;
    }
    var pages = <Widget>[];

    for (WeatherPageData weatherPageData in weatherPages) {
      pages.add(WeatherInterface(weatherPageData));
    }

    //return MyWidget();
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (builder) {
                      return LocationChoose(pageController);
                    }));
                  },
                  icon: const Icon(Icons.map)),
              Text(title),
              IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (builder) {
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
  }
}
