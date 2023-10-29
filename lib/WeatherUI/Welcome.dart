import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shape_weather/WeatherUI/Control.dart';
import 'package:shape_weather/WeatherUI/Introduce.dart';


class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 50, 0, 20),
            child: Text(
              "It seems that you haven't added a city yet",
              textAlign: TextAlign.center,
            ),
          ),
          const Text("Click the top left button to add one"),
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text("Or, read the introduce"),
          ),
          OutlinedButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (builder){
              return const Introduce();
            }));
          }, child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("User's Guide"),
          )),
          kIsWeb? commonCard(context: context, title: "Note", child: const Center(child: Column(
            children: [
              Text("Current Platform is Web"),
              Text("With Low Performance and Some Bugs"),
            ],
          ),)):Container(),
        ],
      ),
    );
  }
}
