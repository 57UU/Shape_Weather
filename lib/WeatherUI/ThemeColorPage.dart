import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:shape_weather/Setting/Configuration.dart';
import 'package:shape_weather/WeatherUI/Control.dart';

class ChangeThemeColorPage extends StatefulWidget {
  const ChangeThemeColorPage({super.key});

  @override
  State<ChangeThemeColorPage> createState() => _ChangeThemeColorPageState();
}

class _ChangeThemeColorPageState extends State<ChangeThemeColorPage> {
  Color pickerColor = (appSetting.value[theme_color]);

  //Color currentColor = (appSetting.value[theme_color]);
  void changeColor(Color color) {
    setState(() {
      pickerColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modify Theme Color"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              commonCard(
                  context: context,
                  child: const Text(
                      "Customized Color is only available in light mode"),
                  title: 'Attention',
                  icon: const Icon(Icons.warning_amber)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: BlockPicker(
                  pickerColor: pickerColor,
                  onColorChanged: changeColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialPicker(
                  pickerColor: pickerColor,
                  onColorChanged: changeColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ColorPicker(
                  pickerColor: pickerColor,
                  onColorChanged: changeColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () {
                      pickerColor = Colors.deepPurple;
                    },
                    child: const Text("Reset to Default")),
              )
            ],
          ),
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
  }
}
