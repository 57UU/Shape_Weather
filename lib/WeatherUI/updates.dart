import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shape_weather/Setting/configuration.dart';
import 'package:shape_weather/WeatherUI/controls.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Setting/version.dart';

class CheckUpdates extends StatefulWidget {
  const CheckUpdates({super.key});

  @override
  State<CheckUpdates> createState() => _CheckUpdatesState();
}

class _CheckUpdatesState extends State<CheckUpdates> {
  static const String uri =
      "https://api.github.com/repos/57UU/Shape_Weather/releases/latest";
  String? latestVersion;

  @override
  void initState() {
    super.initState();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    bool isNewVersion = CURRENT_VERSION != latestVersion;
    //isNewVersion=false;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Check Update"),
      ),
      body: kIsWeb
          ? Column(
              children: [
                commonCard(
                    context: context,
                    title: "Current Version",
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Current Version $CURRENT_VERSION"),
                        Text(
                            "With Github Action, Web version is always the latest")
                      ],
                    )),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                commonCard(
                    context: context,
                    title: "Current Version",
                    child: const Text(CURRENT_VERSION)),
                commonCard(
                    context: context,
                    title: "Latest Version",
                    icon: isNewVersion && latestVersion != null
                        ? const Icon(Icons.arrow_circle_up_rounded)
                        : Container(),
                    onTap: (c) {
                      if (isNewVersion) {
                        launchUrl(Uri.parse(
                            "https://github.com/57UU/Shape_Weather/releases"));
                      }
                    },
                    child: latestVersion == null
                        ? loading()
                        : isNewVersion
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "New Version Available!",
                                    textScaler: TextScaler.linear(1.1),
                                  ),
                                  Text("Latest Version $latestVersion"),
                                  const Text("Click Here to Download")
                                ],
                              )
                            : const Text("Current Version Is Up to Date")),
                ElevatedButton(
                    onPressed: () {
                      fetch();
                    },
                    child: const Text("Check Update"))
              ],
            ),
    );
  }

  void fetch() async {
    setState(() {
      latestVersion = null;
    });
    var request = json.decode(await http.read(Uri.parse(uri)));
    setState(() {
      latestVersion = request["tag_name"];
    });
  }
}
