import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shape_weather/libs/index.dart';
import 'package:shape_weather/weather_ui/widgets/controls.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../libs/version.dart';

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
            title: AppLocalizations.of(context)!.currentVersion,
            child: Center(child: Text("${AppLocalizations.of(context)!.currentVersion} $currentVersion")),
          ),
          kIsWeb?commonCard(
              context: context,
              title: "Web Mode",
              icon: const Text("Tap to Get More Info"),
              child: const Center(child: Text(isRunningWithWasm?"WebAssembly":"JavaScript")),
              onTap: (context){
                showInfoDialog(
                    context: context,
                    title: "Web Mode",
                    content: "There are two kinds of web modes, one is webassembly, and another is javascript.\nWebassembly usually comes with better performance, but it need a compatible browser and a customized server.\nHowever, the server of Github Pages can not be customized.");
              }
          ):Container()
        ],
      ),
    );
  }
}
