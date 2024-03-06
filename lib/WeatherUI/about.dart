
import 'package:flutter/material.dart';
import 'package:shape_weather/WeatherUI/controls.dart';
import 'package:url_launcher/url_launcher.dart';


class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About"),),
      body: ListView(
        children: [
          commonCard(context: context, title: "About", child: const Center(
            child: Column(
              children: [
                Text("This is a cross-platform software made with flutter"),
                Text("Click to access github repo")
              ],
            ),
          ),onTap: (con){
            launchUrl(Uri.parse("https://github.com/57UU/Shape_Weather"));
          }),
          //commonCard(context: context, title: "Limited", child: const Center(child: Text("Web version may can not locate due to CORS"),)),
          commonCard(context: context, title: "Weather Provider", child: const Center(child: Text("Open Weather"),)),
          commonCard(context: context, title: "IP Locating Provider", child: const Center(child: Text("Alapi(Web)\nBaidu Map(other platform)"),)),
        ],
      ),
    );
  }
}
