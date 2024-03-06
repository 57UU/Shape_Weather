import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Setting/configuration.dart';
import '../Setting/setting.dart';
import 'controls.dart';
import 'search.dart';
import 'welcome.dart';
import 'main_ui.dart';

class HomePage extends StatefulWidget {
  final Orientation orientation;

  const HomePage(this.orientation, {super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  String title = "Welcome to Shape Weather";

  final PageController pageController = PageController();
  late int currentPage;

  @override
  void initState() {
    super.initState();
    currentPage = pageController.initialPage;
    if (weatherPages.value.isNotEmpty) {
      title = weatherPages.value.first.title;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (weatherPages.value.isEmpty) {
      title = "Welcome to Shape Weather";
    } else {
      if (currentPage > weatherPages.value.length - 1) {
        currentPage = weatherPages.value.length - 1;
      }
      title = weatherPages.value[currentPage].title;
    }

    var pages = <Widget>[];

    for (WeatherPageData weatherPageData in weatherPages.value) {
      pages.add(WeatherInterface(weatherPageData));
    }
/*    if (weatherPages.isEmpty) {
      return const Welcome();
    }*/
    bool isLandscape = widget.orientation == Orientation.landscape;
    if (weatherPages.value.length == 1) {
      title = weatherPages.value.first.title;
    }
    var mainWidget = Scaffold(
/*      drawer: Drawer(
        child: LocationChoose(widget.orientation,pageController),
      ),*/
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              isLandscape
                  ? const Icon(Icons.cloud_queue)
                  : IconButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (builder) {
                          return LocationChoose(
                              widget.orientation, pageController);
                        }));
                      },
                      icon: const Icon(Icons.map)),
              AnimatedSwitcher(
                  switchInCurve: Curves.easeIn,
                  switchOutCurve: Curves.easeOut,
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    title,
                    key: ValueKey<String>(title),
                  )),
              IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (builder) {
                      return const Setting();
                    }));
                  },
                  icon: const Icon(Icons.settings))
            ],
          ),
        ),
        body: weatherPages.value.isEmpty
            ? Builder(builder: (context) {
                return const Welcome();
              })
            : PageView(
                controller: pageController,
                onPageChanged: (int num) {
                  currentPage = num;
                  setState(() {});
                },
                children: pages,
              ));

    var width = MediaQuery.of(context).size.width;

    if (isLandscape) {
      var locationChooseWidth = width * 2 / 5;
      double widthMax = 350;
      if (locationChooseWidth > widthMax) {
        locationChooseWidth = widthMax;
      }
      return Row(
        children: [
          SizedBox(
              width: locationChooseWidth,
              child: Fragment(
                child: LocationChoose(widget.orientation, pageController),
              )),
          SizedBox(width: width - locationChooseWidth, child: mainWidget)
        ],
      );
    } else {
      return mainWidget;
    }

    //return MyWidget();
  }
}
