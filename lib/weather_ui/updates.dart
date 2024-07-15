import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shape_weather/weather_ui/widgets/controls.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../libs/version.dart';

class CheckUpdates extends StatefulWidget {
  const CheckUpdates({super.key});

  @override
  State<CheckUpdates> createState() => _CheckUpdatesState();
}

class _CheckUpdatesState extends State<CheckUpdates> {
  static const String uri =
      "https://api.github.com/repos/57UU/Shape_Weather/releases/latest";
  String? latestVersion;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    bool isNewVersion =
        currentVersion != latestVersion && currentVersion != "$latestVersion.0";
    //isNewVersion=false;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.checkUpdate),
      ),
      body: kIsWeb
          ? Column(
              children: [
                commonCard(
                    context: context,
                    title: AppLocalizations.of(context)!.currentVersion,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "${AppLocalizations.of(context)!.currentVersion} $currentVersion"),
                        Text(AppLocalizations.of(context)!.webIsLatest)
                      ],
                    )),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                commonCard(
                    context: context,
                    title: AppLocalizations.of(context)!.currentVersion,
                    child: Text(currentVersion)),
                commonCard(
                    context: context,
                    title: AppLocalizations.of(context)!.latestVersion,
                    icon: isNewVersion && latestVersion != null
                        ? const Icon(Icons.open_in_new)
                        : Container(),
                    onTap: (c) {
                      if (isNewVersion) {
                        launchUrl(Uri.parse(
                            "https://github.com/57UU/Shape_Weather/releases/latest"));
                      }
                    },
                    child: isError
                        ? Text(AppLocalizations.of(context)!.failedToLoad)
                        : latestVersion == null
                            ? loading()
                            : isNewVersion
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!
                                            .newVersionAvailable,
                                        textScaler:
                                            const TextScaler.linear(1.1),
                                      ),
                                      Text(
                                          "${AppLocalizations.of(context)!.latestVersion} $latestVersion"),
                                      Text(AppLocalizations.of(context)!
                                          .clickHere2Download),
                                    ],
                                  )
                                : Text(AppLocalizations.of(context)!
                                    .currentVersionIsUpToDate)),
                commonCard(
                    context: context,
                    title: AppLocalizations.of(context)!.allReleases,
                    child: Text(AppLocalizations.of(context)!.click2Check),
                    onTap: (c) {
                      launchUrl(Uri.parse(
                          "https://github.com/57UU/Shape_Weather/releases"));
                    },
                    icon: const Icon(Icons.open_in_new)),
                ElevatedButton(
                    onPressed: () {
                      fetch();
                    },
                    child: Text(AppLocalizations.of(context)!.checkUpdate))
              ],
            ),
    );
  }

  void fetch() async {
    setState(() {
      isError = false;
      latestVersion = null;
    });
    try {
      var request = json.decode(await http.read(Uri.parse(uri)));
      setState(() {
        latestVersion = request["tag_name"];
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      setState(() {
        isError = true;
      });
    }
  }
}
