import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shape_weather/Setting/Configuration.dart';
import 'package:shape_weather/WeatherUI/About.dart';
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
        title: const Text("Setting"),
      ),
      body: ListView(
        children: [
          ElevatedButton(
              onPressed: () async {
                await launchUrl(
                    Uri.parse("https://github.com/57UU/Shape_Weather"));
              },
              child: const Text("Open Github Repo")),
/*          ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (builder) {
                  return Scaffold(appBar: AppBar(title: const Text("Re-order"),),body: const Reorder(),);
                }));
              },
              child: const Text("Change Order")),*/
          ElevatedButton(
              onPressed: () {
                weatherPages.value.clear();
                weatherPages.notifyListeners();
              },
              child: const Text("Clear All Data")),
          ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (builder){
              return const About();
            }));
          }, child: const Text("About")),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context, CupertinoPageRoute(builder: (builder) {
                  return Test();
                }));
              },
              child: const Text("Test"))
        ],
      ),
    );
  }
}
