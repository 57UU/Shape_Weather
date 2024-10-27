import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



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

PageRoute<T> defaultRoute<T>({
  required WidgetBuilder builder,
  String? title,
  RouteSettings? settings,
  bool maintainState = true,
  bool fullscreenDialog = false,
  bool allowSnapshotting = true,
  bool barrierDismissible = false,
}) {
  return CupertinoPageRoute(builder: builder,
      title: title,
      settings: settings,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
      allowSnapshotting: allowSnapshotting,
      barrierDismissible: barrierDismissible
  );
}
void defaultPush(BuildContext context,Widget page){
  Navigator.push(context, defaultRoute(builder: (builder) {
    return page;
  }));
}