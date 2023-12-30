import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shape_weather/Setting/Configuration.dart';
import 'package:shape_weather/Utils.dart';
import 'package:shape_weather/WeatherUI/About.dart';
import 'package:shape_weather/WeatherUI/Control.dart';
import 'package:shape_weather/WeatherUI/Introduce.dart';
import 'package:shape_weather/test.dart';
import 'package:url_launcher/url_launcher.dart';

import '../WeatherUI/ThemeColorPage.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    var children = <Widget>[
      const SwitchRow(
          text: "Enable Dynamic Background",
          valueKey: enable_dynamic_backgorund,
          title: "Dynamic Background",
          content:
              "This feature improves visual effects\nbut also significantly reduce battery life"),
      ButtonWithPadding(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (builder) {
              return const ChangeThemeColorPage();
            }));
          },
          child: const Text("Change Theme Color")),

/*          ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (builder) {
                  return Scaffold(appBar: AppBar(title: const Text("Re-order"),),body: const Reorder(),);
                }));
              },
              child: const Text("Change Order")),*/

      ButtonWithPadding(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (builder) {
              return const Introduce();
            }));
          },
          child: const Text("User's Guide")),
      ButtonWithPadding(
          onPressed: () async {
            var flag = await showYesNoDialog(
                context: context, content: "Are you sure?", title: "Warning");
            if (flag == true) {
              weatherPages.value.clear();
              weatherPages.notifyListeners();
            }
          },
          child: const Text(
            "Clear All Data",
            style: TextStyle(color: Colors.red),
          )),
      kIsWeb
          ? ButtonWithPadding(
              onPressed: () async {
                await launchUrl(Uri.parse(
                    "https://github.com/57UU/Shape_Weather/releases"));
              },
              child: const Text("Download Native Edition"))
          : Container(),
      ButtonWithPadding(
          onPressed: () async {
            await launchUrl(Uri.parse("https://github.com/57UU/Shape_Weather"));
          },
          child: const Text("Open Github Repo")),
      ButtonWithPadding(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (builder) {
              return const About();
            }));
          },
          child: const Text("About")),
/*      ButtonWithPadding(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (builder) {
              return const Test();
            }));
          },
          child: const Text("Test")),*/
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Setting"),
      ),
      body: ListView.builder(
          itemCount: children.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: children[index],
            );
          }),
    );
  }
}
