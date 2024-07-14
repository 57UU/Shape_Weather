import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shape_weather/weather_ui/widgets/controls.dart';
import 'package:shape_weather/weather_ui/introduce.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
            child: Text(
              AppLocalizations.of(context)!.noCityYet,
              textAlign: TextAlign.center,
            ),
          ),
          Text(AppLocalizations.of(context)!.clickTopLeftButtonToAdd),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(AppLocalizations.of(context)!.orReadIntroduce),
          ),
          OutlinedButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (builder){
              return const Introduce();
            }));
          }, child:  Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(AppLocalizations.of(context)!.userGuidance),
          )),
          kIsWeb? commonCard(context: context, title: AppLocalizations.of(context)!.note, child: Center(child: Column(
            children: [
              Text(AppLocalizations.of(context)!.currentPlatformIsWeb),
              Text(AppLocalizations.of(context)!.lowPerformanceAndBugs),
            ],
          ),)):Container(),
        ],
      ),
    );
  }
}
