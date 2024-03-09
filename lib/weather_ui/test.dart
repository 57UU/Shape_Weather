import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';
import 'package:shape_weather/setting/configuration.dart';
import 'package:shape_weather/libs/weather_api.dart';

import 'widgets/controls.dart';

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CupertinoButton(child: const Text("Hello"), onPressed: () {}),
          CupertinoButton(
              child: const Text("Test open_weatherV3 api"),
              onPressed: () {
                Weather.getWeatherHttpGet(weatherPages.value[0].locationInfo);
              }),
          CupertinoButton(
              child: const Text("Load config"),
              onPressed: () {
                loadConfig();
              }),
          const AnimatedWeatherCard(),

          ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (builder){
              return Scaffold(appBar:AppBar(),body: const DragList(),);
            }));
          }, child: const Text("Reorder")),
        ],
      ),
    );
  }
}

class AnimatedWeatherCard extends StatefulWidget {
  const AnimatedWeatherCard({super.key});

  @override
  State<AnimatedWeatherCard> createState() => _AnimatedWeatherCardState();
}

class _AnimatedWeatherCardState extends State<AnimatedWeatherCard> {
  bool isTimeOut = false;

  @override
  Widget build(BuildContext context) {
    countdown();
    return Padding(
      padding: const EdgeInsets.all(10),
      child: AnimatedContainer(
          alignment: Alignment.topLeft,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(20)),
            color: Theme.of(context).colorScheme.secondaryContainer,
          ),
          width: double.infinity,
          duration: const Duration(seconds: 1),
          curve: Curves.ease,
          child: Padding(
              padding: const EdgeInsetsDirectional.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  titleText("title"),
                  isTimeOut ? const Text("data") : loading(),
                ],
              ))),
    );
  }

  Future countdown() async {
    await Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isTimeOut = true;
      });
    });
  }
}





class DragList extends StatefulWidget {
  const DragList({super.key});

  @override
  State<DragList> createState() => _DragListState();
}

class _DragListState extends State<DragList> {
  late List<Widget> _tiles;

  @override
  Widget build(BuildContext context) {
    void onReorder(int oldIndex, int newIndex) {
      setState(() {
        Widget row = _tiles.removeAt(oldIndex);
        _tiles.insert(newIndex, row);
      });
    }
    ScrollController scrollController = PrimaryScrollController.of(context);
    return CustomScrollView(
      controller: scrollController,
      slivers: <Widget>[
        const SliverAppBar(
          expandedHeight: 210.0,
          flexibleSpace: FlexibleSpaceBar(
            title: Text('ReorderableSliverList'),
          ),
        ),
        ReorderableSliverList(
          delegate: ReorderableSliverChildListDelegate(_tiles),
          onReorder: onReorder,
        )
      ],
    );
  }

  @override
  void initState() {

    _tiles = weatherPages.value
        .map((i) {
          return Text(i.title);
        })
        .cast<Widget>()
        .toList();
    super.initState();
  }
}
