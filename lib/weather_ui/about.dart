import 'dart:io';
import 'package:shape_weather/libs/EnvironmentInfo/native.dart' if(dart.library.js_interop)'package:shape_weather/libs/EnvironmentInfo/web.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shape_weather/libs/index.dart';
import 'package:shape_weather/weather_ui/test.dart';
import 'package:shape_weather/weather_ui/widgets/controls.dart';
import 'package:shape_weather/weather_ui/widgets/ui_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    const isRunningWithWasm = bool.fromEnvironment('dart.tool.dart2wasm');
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.about),
      ),
      body: ListView(
        children: [
          commonCard(
              context: context,
              icon: const Icon(Icons.open_in_new),
              title: AppLocalizations.of(context)!.about,
              child: Center(
                child: Column(
                  children: [
                    Text(AppLocalizations.of(context)!.selfIntroduce),
                    Text(AppLocalizations.of(context)!.click2AccessGithubRepo)
                  ],
                ),
              ),
              onTap: (con) {
                launchUrl(Uri.parse("https://github.com/57UU/Shape_Weather"));
              }),
          //commonCard(context: context, title: "Limited", child: const Center(child: Text("Web version may can not locate due to CORS"),)),
          commonCard(
              context: context,
              title: AppLocalizations.of(context)!.weatherProvider,
              child: const Center(
                child: Text("Open Weather"),
              )),
          commonCard(
              context: context,
              title: AppLocalizations.of(context)!.ipLocateProvider,
              child: const Center(
                child: Text("Alapi(Web)\nBaidu Map(other platform)"),
              )),
          commonCard(
              context: context,
              title: AppLocalizations.of(context)!.testPage,
              child: const Center(child: Text("Navigate to Test Page")),
              icon: const Icon(Icons.category_outlined),
              onTap: (context){defaultPush(context,Test());}
          ),
          commonCard(
            context: context,
            title: AppLocalizations.of(context)!.currentVersion,
            child: Center(child: Text("${AppLocalizations.of(context)!.currentVersion} $currentVersion")),
            onTap: (context)async{
              PackageInfo packageInfo = await PackageInfo.fromPlatform();
              var appName=packageInfo.appName;
              var buildNumber=packageInfo.buildNumber;
              var version=packageInfo.version;
              var signature=packageInfo.buildSignature;
              var installerStore=packageInfo.installerStore;
              var packageName=packageInfo.packageName;

              var dartVersion="Unknown";
              var system="Unknown";
              List<String> env;
              var exe="Unknown";
              var systemVersion="Unknown";
              var environmentText="---Environment---\n${getEnvironmentInfo()}";


              String content=
                  "---APP---\n"
                  "AppName: $appName\n"
                  "BuildNumber: $buildNumber\n"
                  "Version: $version\n"
                  "Signature: $signature\n"
                  "Installer: $installerStore\n"
                  "PackageName: $packageName\n"
                  "$environmentText"
                  "---FLAG---\n"
                  "Web: $kIsWeb\n"
                  "WASM: $kIsWasm\n"
              ;
              await showInfoDialog(title: AppLocalizations.of(context)!.details,content:content);
            }
          ),

          kIsWeb?commonCard(
              context: context,
              title: AppLocalizations.of(context)!.webMode,
              icon: Text(AppLocalizations.of(context)!.tap2GetMoreInfo),
              child: const Center(child: Text(isRunningWithWasm?"WebAssembly":"JavaScript")),
              onTap: (context){
                showInfoDialog(
                    context: context,
                    title: AppLocalizations.of(context)!.webMode,
                    content: AppLocalizations.of(context)!.webModeIntroduce);
              }
          ):Container(),
        ],
      ),
    );
  }
}
