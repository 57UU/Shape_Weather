import 'dart:io';
import 'dart:ui';

import   'package:bitsdojo_window/bitsdojo_window.dart' if(dart.library.js_interop)"package:shape_weather/libs/bitsdojo_unimplemented.dart";


//import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shape_weather/libs/ensure_initialize.dart';
import 'package:shape_weather/setting/configuration.dart';
import 'package:shape_weather/weather_ui/widgets/controls.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'weather_ui/home_page.dart';

void main()async {
  //test();
  if(!kIsWeb){
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();
  }
  //call init
  await ensureInitialize();
  await loadConfig();
  startGUI();
}

void startGUI() {
  runApp( const MyApp());

  if ((!kIsWeb) && Platform.isWindows) {
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
  Locale? getLocale(){
    String? lang=appSetting.value[language_set];
    Locale? locale;
    if(lang!=null){
      var splitLang=lang.split("_");
      if(splitLang.length==1){
        locale=Locale(lang);
      }else if(splitLang.length==2){
        locale=Locale.fromSubtags(languageCode:  splitLang[0],scriptCode:  splitLang[1]);
      }else if(splitLang.length==3){
        locale=Locale.fromSubtags(languageCode:  splitLang[0],scriptCode:  splitLang[1],countryCode: splitLang[2]);
      }
    }
    debugPrint("current locale :${locale?.toLanguageTag()}");
    return locale;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {


    return ListenableBuilder(
      builder: (context, widget) {
        return MaterialApp(
          locale: getLocale(),
          onGenerateTitle: (context) => AppLocalizations.of(context)!.shapeWeather,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          title: 'Shape Weather',
          theme: ThemeData(
            brightness: Brightness.light,
            colorScheme:
                ColorScheme.fromSeed(seedColor: appSetting.value[theme_color]),
            visualDensity: VisualDensity.adaptivePlatformDensity,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
                seedColor: appSetting.value[theme_color],
                brightness: Brightness.dark),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home:const StartUp(),
        );
      },
      listenable: appSetting,
    );
  }
}

class StartUp extends StatelessWidget {
  const StartUp({super.key});

  @override
  Widget build(BuildContext context) {
    var child = OrientationBuilder(
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

    if ((!kIsWeb) && Platform.isWindows) {
      Color backgroundColor = Theme.of(context).brightness == Brightness.light
          ? Theme.of(context).colorScheme.secondaryContainer
          : Theme.of(context).colorScheme.surface;
      return Column(
        children: [
          Container(
            decoration: BoxDecoration(color: backgroundColor),
            child: WindowTitleBarBox(
              child: Row(
                children: [
                  Material(
                    color: backgroundColor,
                    child: Text(
                      "  ${AppLocalizations.of(context)!.shapeWeather}",
                    ),
                  ),
                  Expanded(child:
                       MoveWindow()
                  ),
                  const WindowButtons()
                ],
              ),
            ),
          ),
          Expanded(child: Fragment(child: Builder(
            builder: (context) {
              logicRootContext=context;
              return child;
            }
          )))
        ],
      );
      //return Window("Shape Weather", child);
    }else{
      logicRootContext=context=context;
      return child;
    }
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
            Text(AppLocalizations.of(context)!.shapeWeather),
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
  const WindowButtons({super.key});

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
