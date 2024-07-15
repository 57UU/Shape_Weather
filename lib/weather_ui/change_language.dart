

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../setting/configuration.dart';
class ChangeLanguagePage extends StatefulWidget {
  const ChangeLanguagePage({super.key});

  @override
  State<ChangeLanguagePage> createState() => _ChangeLanguagePageState();
}

class _ChangeLanguagePageState extends State<ChangeLanguagePage> {
  late List<Locale> locales=AppLocalizations.supportedLocales;
  String? selected;
  @override
  void initState() {
    selected=preferences!.getString(language_set);
    super.initState();
  }
  void onValueChanged(String? v){
    setState(() {
      selected=v;
    });
    appSetting.value[language_set]=selected;
    appSetting.notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    var children=<Widget>[];
    children.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: RadioButton(index: null, selected: selected, onChanged: onValueChanged, text: AppLocalizations.of(context)!.followSystem,),
    ));
    for(var i in locales){
      children.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RadioButton(index: i.toString(), selected: selected, onChanged: onValueChanged, text: i.toLanguageTag(),),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.modifyLanguage),),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          ),
        ),
      ),
    );
  }
}
class RadioButton extends StatelessWidget {
  final String? selected;
  final String? index;
  final String text;
  final void Function(String? v) onChanged;
  const RadioButton({super.key,required this.selected, required this.index, required this.text, required this.onChanged,});

  @override
  Widget build(BuildContext context) {
    onPress(){onChanged(index);}
    Widget child=Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(text,textScaler: const TextScaler.linear(1.1),),
        ),
        AnimatedOpacity(opacity: selected==index?1:0, duration: const Duration(milliseconds: 150),child: const Icon(Icons.check),)
      ],
    );
      return OutlinedButton(onPressed: onPress, child: child);

  }
}

