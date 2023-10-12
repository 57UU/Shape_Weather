import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:shape_weather/Setting/Configuration.dart';

import 'WeatherUI/Homepage.dart';

void main() {
  //test();
  runApp(const MyApp());
  weatherPages.addListener(() {
    saveConfig();
  });
  if (Platform.isWindows) {
    doWhenWindowReady(() {
      final win = appWindow;
      const initialSize = Size(800, 720);
      win.minSize = const Size(400, 500);
      win.size = initialSize;
      win.alignment = Alignment.center;
      win.title = "Shape Weather Desktop";
      win.show();
    });
  }
}

GlobalKey<HomePageState> _globalKey = GlobalKey<HomePageState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shape Weather',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      home: const StartUp(),
    );
  }
}

class StartUp extends StatelessWidget {
  const StartUp({super.key});

  @override
  Widget build(BuildContext context) {
    var child = FutureBuilder<String>(
      future: loadConfig(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // 请求已结束
        if (snapshot.connectionState == ConnectionState.done) {
          return OrientationBuilder(
            builder: (context, orientation) {
              return ValueListenableBuilder(
                builder: (context, v, child) {
                  if (MediaQuery.of(context).size.width < 400) {
                    orientation = Orientation.portrait;
                  }
                  return HomePage(
                    orientation,
                    key: _globalKey,
                  );
                },
                valueListenable: weatherPages,
              );
            },
          );
        } else {
          // 请求未结束，显示loading
          return const CircularProgressIndicator();
        }
      },
    );
    if (Platform.isWindows) {
      return Column(
        children: [
          Container(
            decoration:
                BoxDecoration(color: Theme.of(context).colorScheme.surface),
            child: WindowTitleBarBox(
              child: Row(
                children: [
                  const Material(child: Text("  Shape Weather")),
                  Expanded(child: MoveWindow()),
                  const WindowButtons()
                ],
              ),
            ),
          ),
          Expanded(child: child)
        ],
      );
      //return Window("Shape Weather", child);
    }

    return child;
  }
}

class Window extends StatelessWidget {
  final String title;
  final Widget child;

  const Window(this.title, this.child, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Text(title),
        flexibleSpace: Row(
          children: [
            const Text("Shape Weather"),
            Expanded(child: MoveWindow()),
            const WindowButtons()
          ],
        ),
      ),
      body: child,
    );
  }
}

final buttonColors = WindowButtonColors(
  iconNormal: const Color(0xFF8C8C8C),
  mouseOver: const Color(0x813B3B3C),
  mouseDown: const Color(0xFF3B3B3C),
  iconMouseOver: Colors.white,
  //iconMouseDown: const Color(0xFFFFD500),
);

final closeButtonColors = WindowButtonColors(
    mouseOver: const Color(0xFFD32F2F),
    mouseDown: const Color(0xFFB71C1C),
    iconNormal: const Color(0xFF8C8C8C),
    iconMouseOver: Colors.white);

class WindowButtons extends StatelessWidget {
  const WindowButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(colors: buttonColors),
        MaximizeWindowButton(colors: buttonColors),
        CloseWindowButton(colors: closeButtonColors),
      ],
    );
  }
}
