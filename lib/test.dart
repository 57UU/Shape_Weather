
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shape_weather/Setting/Configuration.dart';
import 'package:shape_weather/weatherAPI.dart';

import 'WeatherUI/Control.dart';

class Test extends StatelessWidget {

  const Test({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(body: Column(
      children: [
        CupertinoButton(child: Text("Hello"), onPressed: (){}),
        CupertinoButton(child: Text("Test Search api"), onPressed: (){
          Weather.getCitiesByName("java");
        }),
        CupertinoButton(child: Text("Load config"), onPressed: (){
          loadConfig();
        }),
        const AnimatedWeatherCard(),

      ],
    ),

    );
  }
}


class AnimatedWeatherCard extends StatefulWidget {
  const AnimatedWeatherCard({super.key});

  @override
  State<AnimatedWeatherCard> createState() => _AnimatedWeatherCardState();
}

class _AnimatedWeatherCardState extends State<AnimatedWeatherCard> {
  bool isTimeOut = false;

  @override
  Widget build(BuildContext context) {
    countdown();
    return Padding(
      padding: EdgeInsets.all(10),
      child: AnimatedContainer(
          alignment: Alignment.topLeft,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(20)),
            color: Theme.of(context).colorScheme.secondaryContainer,
          ),
          width: double.infinity,
          duration: Duration(seconds: 1),
          curve: Curves.ease,
          child: Padding(
              padding: EdgeInsetsDirectional.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  titleText("title"),
                  isTimeOut ? Text("data") : loading(),
                ],
              ))),
    );
  }

  Future countdown() async {
    await Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isTimeOut = true;
      });
    });
  }
}