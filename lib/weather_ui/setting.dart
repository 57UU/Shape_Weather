// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shape_weather/setting/configuration.dart';
import 'package:shape_weather/weather_ui/change_language.dart';
import 'package:shape_weather/weather_ui/updates.dart';
import 'package:shape_weather/libs/utils.dart';
import 'package:shape_weather/weather_ui/about.dart';
import 'package:shape_weather/weather_ui/widgets/controls.dart';
import 'package:shape_weather/weather_ui/introduce.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'theme_color_page.dart';
import 'widgets/index.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {


  @override
  Widget build(BuildContext context) {
    var children = <Widget>[
      SwitchRow(
          text: AppLocalizations.of(context)!.enableDynamicBackground,
          valueKey: enable_dynamic_background,
          title: AppLocalizations.of(context)!.dynamicBackground,
          content: AppLocalizations.of(context)!.dynamicBackgroundIntroduce),
      ButtonWithPadding(
          onPressed: () {
            Navigator.push(context, defaultRoute(builder: (builder) {
              return const ChangeThemeColorPage();
            }));
          },
          icon: const Icon(Icons.color_lens),
          child: Text(AppLocalizations.of(context)!.changeThemeColor)),
      ButtonWithPadding(
          onPressed: () {
            Navigator.push(context, defaultRoute(builder: (builder) {
              return const ChangeLanguagePage();
            }));
          },
          icon: const Icon(Icons.language),
          child: Text(AppLocalizations.of(context)!.modifyLanguage)),

/*          ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(getRoute(builder: (builder) {
                  return Scaffold(appBar: AppBar(title: const Text("Re-order"),),body: const Reorder(),);
                }));
              },
              child: const Text("Change Order")),*/

      ButtonWithPadding(
          onPressed: () {
            Navigator.push(context, defaultRoute(builder: (builder) {
              return const Introduce();
            }));
          },
          icon: const Icon(Icons.book),
          child: Text(AppLocalizations.of(context)!.userGuidance)),
      ButtonWithPadding(
          onPressed: () async {
            var flag = await showYesNoDialog(
                context: context,
                content: AppLocalizations.of(context)!.areYouSure,
                title: AppLocalizations.of(context)!.warning);
            if (flag == true) {
              weatherPages.value.clear();
              appSetting.value.clear();
              weatherPages.notifyListeners();
              appSetting.notifyListeners();
              loadConfig();
            }
          },
          icon: const Icon(Icons.delete_forever),
          child: Text(
            AppLocalizations.of(context)!.clearAllData,
            style: const TextStyle(color: Colors.red),
          )),
      kIsWeb
          ? ButtonWithPadding(
        onPressed: () async {
          await launchUrl(Uri.parse(
              "https://github.com/57UU/Shape_Weather/releases"));
        },
        icon: const Icon(Icons.open_in_new),
        child: Text(AppLocalizations.of(context)!.downloadNativeEdition),)
          : Container(),
      ButtonWithPadding(
          onPressed: () async {
            await launchUrl(Uri.parse("https://github.com/57UU/Shape_Weather"));
          },
          icon: const Icon(Icons.open_in_new),
          child: Text(AppLocalizations.of(context)!.openGithubRepo)),
      ButtonWithPadding(
          onPressed: () {
            Navigator.push(context, defaultRoute(builder: (builder) {
              return const CheckUpdates();
            }));
          },
          icon: const Icon(Icons.arrow_circle_up),
          child: Text(AppLocalizations.of(context)!.checkUpdate)),
      ButtonWithPadding(
          onPressed: () {
            Navigator.push(context, defaultRoute(builder: (builder) {
              return const About();
            }));
          },
          icon: const Icon(Icons.info_outline_rounded),
          child: Text(AppLocalizations.of(context)!.about)),

/*      ButtonWithPadding(
          onPressed: () {
            Navigator.push(context, getRoute(builder: (builder) {
              return const Test();
            }));
          },
          child: const Text("Test")),*/
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.setting),
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
