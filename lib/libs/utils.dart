import 'package:async/async.dart';
import 'package:flutter/material.dart';

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

Future<bool?> showYesNoDialog({
  required BuildContext context,
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

class ContextWrapper {
  late BuildContext context;
}

Future showLoadingDialog(
    {required BuildContext context,
    String title = "Loading",
    required Future Function() func,
    String button = "Cancel",
    void Function()? onError}) {
  ContextWrapper contextWrapper = ContextWrapper();
  var future = func().then((v) {
    Future.delayed(const Duration(milliseconds: 100)).then((value) {
      if(context.mounted){
        Navigator.pop(contextWrapper.context);
      }

    });
  }).onError((error, stackTrace) {
    //await Future.delayed(const Duration(microseconds: 5000));
    if(context.mounted){
      Navigator.pop(contextWrapper.context);
    }
    if (onError != null) {
      onError();
    }
  });
  var myCancelableFuture = CancelableOperation.fromFuture(
    future,
  );

  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        contextWrapper.context = context;
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
                  myCancelableFuture.cancel();
                  Navigator.of(context).pop();
                },
                child: Text(button))
          ],
        );
      });
}

class NotCompatible extends StatelessWidget {
  const NotCompatible({super.key});

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
          textScaler: TextScaler.linear(2),
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

var weatherDescription2Icon = <String, IconData>{
  "Clear": Icons.sunny,
  "Clouds": Icons.cloud_sharp,
};

IconData getIconByString(String type) {
  var result = weatherDescription2Icon[type];
  return result ?? Icons.question_mark;
}

T getMax<T>(List<T> source, int Function(T a, T b) f) {
  //a>b->1
  int index = 0;
  for (int i = 1; i < source.length; i++) {
    if (f(source[i], source[index]) > 0) {
      index = i;
    }
  }
  return source[index];
}

T getMin<T>(List<T> source, int Function(T a, T b) f) {
  //a<b -> -1
  int index = 0;
  for (int i = 1; i < source.length; i++) {
    if (f(source[i], source[index]) < 0) {
      index = i;
    }
  }
  return source[index];
}
double parseDouble(dynamic num_like){
  switch(num_like){
    case double num:
      return num;
    case String num:
      return double.parse(num);
    case int num:
      return num.toDouble();
  }
  throw Exception("can not parse $num_like");
}
void popContext(BuildContext context){
  if(context.mounted){
    Navigator.of(context).pop();
  }
}