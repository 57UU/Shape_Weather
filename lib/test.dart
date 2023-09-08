
import 'package:flutter/cupertino.dart';
import 'package:shape_weather/Setting/Configuration.dart';
import 'package:shape_weather/weatherAPI.dart';

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(child: Column(
      children: [
        CupertinoButton(child: Text("Hello"), onPressed: (){}),
        CupertinoButton(child: Text("Test Search api"), onPressed: (){
          Weather.getCitiesByName("java");
        }),
        CupertinoButton(child: Text("Load config"), onPressed: (){
          loadConfig();
        }),

      ],
    ),

    );
  }
}
