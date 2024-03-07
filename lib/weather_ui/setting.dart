import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shape_weather/Setting/configuration.dart';
import 'package:shape_weather/weather_ui/updates.dart';
import 'package:shape_weather/Libs/utils.dart';
import 'package:shape_weather/weather_ui/about.dart';
import 'package:shape_weather/weather_ui/controls.dart';
import 'package:shape_weather/weather_ui/introduce.dart';
import 'package:shape_weather/weather_ui/test.dart';
import 'package:url_launcher/url_launcher.dart';

import 'theme_color_page.dart';

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
              appSetting.value.clear();
              weatherPages.notifyListeners();
              appSetting.notifyListeners();
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
              return const CheckUpdates();
            }));
          },
          child: const Text("Check Update")),
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
        title: const Text("setting"),
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
