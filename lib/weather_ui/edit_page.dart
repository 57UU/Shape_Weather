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

class RowInput extends StatefulWidget {
  final String left;
  final void Function(String s) right;
  final String defaultText;

  const RowInput(this.left, this.right, this.defaultText,{super.key});

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
      decoration: InputDecoration(labelText: widget.left),
      controller: controller,
      onChanged: (s) {
        widget.right(controller.text);
      },
    );
  }
}
