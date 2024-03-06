
import 'package:flutter/material.dart';
import 'package:shape_weather/WeatherUI/controls.dart';

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
Future<bool?> showYesNoDialog(
    {required BuildContext context,
      String title = "",
      String content = "",
      }) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text("Yes")),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text("No"))
          ],
        );
      });
}

class ContextWarpper {
  late BuildContext context;
}

Future showLoadingDialog(
    {required BuildContext context,
    String title = "Loading",
    required Future Function() func,
    String button = "Cancel",
    void Function()? onError}) {

  ContextWarpper contextWarpper = ContextWarpper();
  func().then((v) {
    Future.delayed(const Duration(milliseconds: 100)).then((value) {
      Navigator.pop(contextWarpper.context);
    });
  }).onError((error, stackTrace) {
    Navigator.pop(contextWarpper.context);
    if(onError!=null){
      onError();
    }
  });
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        contextWarpper.context = context;
        return AlertDialog(
          title: Text(title),
          content: const Padding(
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

var weatherDescription2Icon=<String,IconData>{
  "Clear":Icons.sunny,
  "Clouds":Icons.cloud_sharp,

};
IconData getIconByString(String type){
  var result=weatherDescription2Icon[type];
  return result ?? Icons.question_mark;
}

T getMax<T>(List<T> source,int Function(T a,T b) f){//a>b->1
  int index=0;
  for(int i=1;i<source.length;i++){
    if(f(source[i],source[index])>0){
      index=i;
    }
  }
  return source[index];
}

T getMin<T>(List<T> source,int Function(T a,T b) f){//a<b -> -1
  int index=0;
  for(int i=1;i<source.length;i++){
    if(f(source[i],source[index])<0){
      index=i;
    }
  }
  return source[index];
}