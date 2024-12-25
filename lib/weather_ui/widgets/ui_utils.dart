import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shape_weather/setting/configuration.dart';
import 'package:shape_weather/weather_ui/widgets/controls.dart';

Future showInfoDialog(
    {  BuildContext? context,//this is no need anymore
      String title = "",
      String content = "",
      String button = "OK"}) {
  return showDialog(
      context: logicRootContext,
      useRootNavigator: false,
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
  BuildContext? context,//no need
  String title = "",
  String content = "",
}) {
  return showDialog(
      context: logicRootContext,
      useRootNavigator: false,
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
    {BuildContext? context,//no need
      String title = "Loading",
      required Future Function() func,
      String button = "Cancel",
      void Function()? onError}) {
  ContextWrapper contextWrapper = ContextWrapper();
  var future = func().then((v)async {
    await Future.delayed(const Duration(milliseconds: 100));
    if(contextWrapper.context.mounted){
      Navigator.pop(contextWrapper.context);
    }
  }).onError((error, stackTrace) {
    //await Future.delayed(const Duration(microseconds: 5000));
    if(contextWrapper.context.mounted){
      Navigator.pop(contextWrapper.context);
    }
    if (onError != null) {
      onError();
    }
  });
  var myCancelableFuture = CancelableOperation.fromFuture(future);

  return showDialog(
      barrierDismissible: false,
      context: logicRootContext,
      useRootNavigator: false,
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

Future showLoadingDialogWithErrorString(
    {BuildContext? context,//no need
      String title = "Loading",
      required Future Function() func,
      String button = "Cancel",
      String onErrorTitle="Error",
      String onErrorButton="OK",
      String onErrorMessage="error"}) {
  bool isError=false;
  ContextWrapper contextWrapper = ContextWrapper();
  rebuildDialog(){
    if(contextWrapper.context.mounted){
      (contextWrapper.context as Element).markNeedsBuild();
    }
  }
  var future = func().then((v)async {
    await Future.delayed(const Duration(milliseconds: 100));
    if(contextWrapper.context.mounted){
      Navigator.pop(contextWrapper.context);
    }
  }).onError((error, stackTrace) {
    isError=true;
    rebuildDialog();
  });
  var myCancelableFuture = CancelableOperation.fromFuture(future);

  return showDialog(
      barrierDismissible: isError,//dialog can not be dismissed when loading TODO:bug here
      context: logicRootContext,
      useRootNavigator: false,
      builder: (context) {
        contextWrapper.context = context;
        return AlertDialog(
          title: Text(isError?onErrorTitle: title),
          content: AnimatedSize(
            duration: cardSizeAnimationDuration,
            curve: Curves.easeOutQuart,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isError?Text(onErrorMessage): const CircularProgressIndicator(),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  if(!isError){
                    myCancelableFuture.cancel();
                  }
                  Navigator.of(context).pop();
                },
                child: Text(isError?onErrorButton: button))
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