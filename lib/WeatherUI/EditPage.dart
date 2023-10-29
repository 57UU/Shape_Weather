import 'package:flutter/material.dart';

import '../Setting/Configuration.dart';
import 'Control.dart';

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
        title: const Text("Edit"),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: ListView(
          children: [
            RowInput("City Name", (s) {
              widget.weatherPageData.locationInfo.cityName = s;
              weatherPages.notifyListeners();
            },widget.weatherPageData.locationInfo.cityName),
            commonCard(context: context,title:"Note" ,child: const Text("Some changes may need restarting to be applied")),
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
    // TODO: implement initState
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
