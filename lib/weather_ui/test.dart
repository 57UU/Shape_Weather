import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';
import 'package:shape_weather/setting/configuration.dart';
import 'package:shape_weather/libs/weather_api.dart';
import 'package:shape_weather/weather_ui/widgets/index.dart';

import 'widgets/controls.dart';

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          CupertinoButton(
              child: const Text("loading dialog with error"),
              onPressed: () {
                showLoadingDialogWithErrorString(
                    context: context,
                    func: () async {
                      await Future.delayed(const Duration(seconds: 1));
                      throw Exception("designed error");
                    },
                  onErrorMessage: "designed error\n"*10

                    );
              }),
          CupertinoButton(
            onPressed: () {showInfoDialog(context: context,title: "test",content: "114514");},
            child: const Text("show Info dialog"),
          ),
          const AnimatedWeatherCard(),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (builder) {
                  return Scaffold(
                    appBar: AppBar(),
                    body: const DragList(),
                  );
                }));
              },
              child: const Text("Reorder")),
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
  final String content = "This is a very long string\n" * 10;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: commonCard(
        child: AnimatedSize(
          curve: Curves.easeOutQuart,
          duration: const Duration(milliseconds: 500),
          child: Padding(
              padding: const EdgeInsetsDirectional.all(20),
              child: isTimeOut ? loading() : Text(content)),
        ),
        onTap: (context) {
          setState(() {
            isTimeOut = !isTimeOut;
          });
        },
        context: context,
        title: 'Test Animation (Click)',
      ),
    );
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
