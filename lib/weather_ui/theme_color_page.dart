import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:shape_weather/setting/configuration.dart';
import 'package:shape_weather/weather_ui/widgets/controls.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class ChangeThemeColorPage extends StatefulWidget {
  const ChangeThemeColorPage({super.key});

  @override
  State<ChangeThemeColorPage> createState() => _ChangeThemeColorPageState();
}

class _ChangeThemeColorPageState extends State<ChangeThemeColorPage> {
  Color pickerColor = (appSetting.value[theme_color]);
  ColorScheme? colorScheme;

  @override
  void initState() {
    super.initState();
  }

  void changeColor(Color color) {
    setState(() {
      pickerColor = color;
      colorScheme = ColorScheme.fromSeed(
          seedColor: pickerColor, brightness: Theme.of(context).brightness);
    });
  }

  @override
  Widget build(BuildContext context) {
    colorScheme ??= ColorScheme.fromSeed(
        seedColor: pickerColor, brightness: Theme.of(context).brightness);
    return Theme(
      data: ThemeData(
          colorScheme: colorScheme, brightness: Theme.of(context).brightness),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              color: Theme.of(context).colorScheme.onSecondary,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: Text(
              AppLocalizations.of(context)!.modifyThemeColor,
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onSecondary),
            ),
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                commonCard(
                    context: context,
                    child: Text(
                        AppLocalizations.of(context)!.customizedColorIsGeneratedByColorSeed),
                    title: AppLocalizations.of(context)!.tips,
                    icon: const Icon(Icons.warning_amber)),
                Expanded(
                    child: MultiColorPicker(
                  initColor: pickerColor,
                  onColorChanged: changeColor,
                )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () {
                        changeColor(Colors.deepPurple);
                      },
                      child: Text(AppLocalizations.of(context)!.reset2Default)),
                )
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.check),
            onPressed: () {
              appSetting.value[theme_color] = pickerColor;
              appSetting.notifyListeners();
              Navigator.of(context).pop();
            },
          ),
        );
      }),
    );
  }
}

class MultiColorPicker extends StatefulWidget {
  final Color initColor;
  final void Function(Color color) onColorChanged;

  const MultiColorPicker(
      {super.key, required this.onColorChanged, required this.initColor});

  @override
  State<MultiColorPicker> createState() => _MultiColorPickerState();
}

class _MultiColorPickerState extends State<MultiColorPicker>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      initialIndex: 0,
      length: 3,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabBar(
        tabs: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Text(AppLocalizations.of(context)!.block),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Text(AppLocalizations.of(context)!.material),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Text(AppLocalizations.of(context)!.advanced),
          )
        ],
        controller: tabController,
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlockPicker(
                useInShowDialog: false,
                pickerColor: widget.initColor,
                onColorChanged: widget.onColorChanged,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: MaterialPicker(
                pickerColor: widget.initColor,
                onColorChanged: widget.onColorChanged,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ColorPicker(
              pickerColor: widget.initColor,
              onColorChanged: widget.onColorChanged,
            ),
          ),
        ],
      ),
    );
  }
}
