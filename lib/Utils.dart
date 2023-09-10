import 'package:flutter/material.dart';
import 'package:shape_weather/WeatherUI/Control.dart';

Future showInfoDialog(
    {required BuildContext context,
    String title = "",
    String content = "",
    String button = "OK"}) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(button))
          ],
        );
      });
}

class ContextWarpper{
  late BuildContext context;
}

Future showLoadingDialog(
    {required BuildContext context,
      String title = "Loading",
      required Future Function() func,
      String button = "Cancel"}) {
  ContextWarpper contextWarpper=ContextWarpper();
  func().then((v){
    Future.delayed(const Duration(milliseconds: 100)).then((value)  {
      Navigator.pop(contextWarpper.context);
    });

  });
  return showDialog(
    barrierDismissible: false,
      context: context,
      builder: (context) {
      contextWarpper.context=context;
        return AlertDialog(
          title: Text(title),
          content:  const Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  //Navigator.of(context).pop();
                },
                child: Text(button))
          ],
        );
      });
}


class NotCampatible extends StatelessWidget {
  const NotCampatible({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("不兼容"),
      ),
      body: const Center(
        child: Text(
          "由于webview兼容性\n目前仅支持Android&ios",
          textAlign: TextAlign.center,
          textScaleFactor: 2,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.arrow_back),
      ),
    );
  }
}
