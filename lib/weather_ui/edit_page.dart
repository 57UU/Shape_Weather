// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../setting/configuration.dart';
import '../setting/weather_data.dart';
import 'widgets/controls.dart';

class EditPage extends StatefulWidget {
  final WeatherPageData weatherPageData;

  const EditPage(this.weatherPageData, {super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.edit),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: ListView(
          children: [
            RowInput(AppLocalizations.of(context)!.cityName, (s) {
              widget.weatherPageData.locationInfo.cityName = s;
              weatherPages.notifyListeners();
            },widget.weatherPageData.locationInfo.cityName),
            commonCard(context: context,title:AppLocalizations.of(context)!.note ,child: Text(AppLocalizations.of(context)!.changesNeedRestarting2Apply)),
          ],


        ),
      ),
    );
  }
}
Future popupEditPageDialog(BuildContext context,WeatherPageData weatherPageData){
  String modifiedName=weatherPageData.locationInfo.cityName;
  return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.edit),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RowInput(AppLocalizations.of(context)!.cityName, (s){modifiedName=s;}, modifiedName),
              const VerticalPadding(),
              Row(children: [
                  const Icon(Icons.info_outline_rounded),
                  const HorizontalPadding(),
                  Expanded(child: Text(AppLocalizations.of(context)!.changesNeedRestarting2Apply))
                ],
              )
            ],
          ),
          actions: [
            TextButton(
                onPressed: (){Navigator.of(context).pop();},
                child: Text(AppLocalizations.of(context)!.cancel)
            ),
            TextButton(
                onPressed: (){
                  weatherPageData.locationInfo.cityName = modifiedName;
                  weatherPages.notifyListeners();
                  Navigator.of(context).pop();
                  },
                child: Text(AppLocalizations.of(context)!.edit)
            ),
          ],
        );
      }
  );
}
class RowInput extends StatefulWidget {
  final String hint;
  final void Function(String s) onChanged;
  final String defaultText;

  const RowInput(this.hint, this.onChanged, this.defaultText,{super.key});

  @override
  State<RowInput> createState() => _RowInputState();
}

class _RowInputState extends State<RowInput> {

  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.defaultText);
  }


  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(labelText: widget.hint),
      controller: controller,
      onChanged: (s) {
        widget.onChanged(controller.text);
      },
    );
  }
}
