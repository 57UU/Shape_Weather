import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shape_weather/WeatherUI/Control.dart';
import 'package:shape_weather/main.dart';
import 'package:shape_weather/test.dart';
import 'package:url_launcher/url_launcher.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Setting"),
      ),
      body: ListView(
        children: [
          ElevatedButton(onPressed: ()async{
            await launchUrl(Uri.parse("https://github.com/57UU/Shape_Weather") );
          }, child: const Text("Open Github Repo")),
          ElevatedButton(onPressed: (){
            clearWeatherPages();
          }, child: Text("Clear All Data")),
          ElevatedButton(onPressed: (){
            Navigator.push(context, CupertinoPageRoute(builder: (builder){
              return Test();
            }));
          }, child: Text("Test"))
        ],
      ),
    );
  }
}
