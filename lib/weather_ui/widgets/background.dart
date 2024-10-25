import 'package:flutter/material.dart';
import 'package:open_weather_client/models/weather_data.dart';

class AnimatedGradient extends StatefulWidget {
  const AnimatedGradient({super.key});

  @override
  State<AnimatedGradient> createState() => _AnimatedGradientState();
}

class _AnimatedGradientState extends State<AnimatedGradient> {
  List<Color> colorList = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow
  ];
  List<Alignment> alignmentList = [
    Alignment.bottomLeft,
    Alignment.bottomRight,
    Alignment.topRight,
    Alignment.topLeft,
  ];
  int index = 0;
  Color bottomColor = Colors.red;
  Color topColor = Colors.yellow;
  Alignment begin = Alignment.bottomLeft;
  Alignment end = Alignment.topRight;

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 30), () {
      setState(() {
        bottomColor = Colors.blue;
      });
    });
    return
        Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(seconds: 2),
              onEnd: () {
                setState(() {
                  index = index + 1;
                  // animate the color
                  bottomColor = colorList[index % colorList.length];
                  topColor = colorList[(index + 1) % colorList.length];
                  //// animate the alignment
                   begin = alignmentList[index % alignmentList.length];
                   end = alignmentList[(index + 2) % alignmentList.length];
                });
              },
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: begin, end: end, colors: [bottomColor, topColor])),
            ),

          ],
        );
  }
}
Widget autoBackground(WeatherData weatherData){

  var id=weatherData.details.first.id;
  var index=weatherData.details.first.id/100;
  if(index==2){
    return const WeatherThunderStorm();
  }else if(index==3){//light rain
    return const WeatherRain();
  }else if(index==5){//rain
    return const WeatherRain();
  }else if(index==6){//snow
    return const WeatherSnow();
  }else if(index==7){//atmosphere

  }else if(id==800){//clear
    return const WeatherClear();
  }else if(id/10==80){//clouds
    return const WeatherClouds();
  }
  return const AnimatedGradient();
}
class WeatherClear extends StatelessWidget {
  const WeatherClear({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
class WeatherRain extends StatelessWidget {
  const WeatherRain({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
class WeatherClouds extends StatelessWidget {
  const WeatherClouds({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
class WeatherThunderStorm extends StatelessWidget {
  const WeatherThunderStorm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
class WeatherSnow extends StatelessWidget {
  const WeatherSnow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}




