import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'widgets/controls.dart';

class Introduce extends StatelessWidget {
  const Introduce({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.introduce2ShapeWeather),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            textTitle(AppLocalizations.of(context)!.addCity),
            TextRow(
                (AppLocalizations.of(context)!.inPortraitModeTap), Icon(Icons.map), (AppLocalizations.of(context)!.toOpenMap)),
            TextRow(
                (AppLocalizations.of(context)!.thenTap),
                SizedBox(
                  height: 110,
                  width: 150,
                  child: commonCard(
                    context: context,
                    title: AppLocalizations.of(context)!.add_upper,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.blueAccent,
                        ),
                      ],
                    ),
                  ),
                ),
                (AppLocalizations.of(context)!.toOpenSearchPage)),
            TextRow(
                "1) tap the button",
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.gps_fixed_rounded)),
                "to locate current city"),
            const TextRow(
                "2) input the city name in the search bar",
                SizedBox(
                    width: 120,
                    child: SearchBar(
                      leading: Icon(Icons.search),
                    )),
                "to search"),
            //----------------switch---------------
            textTitle("Switch cities"),
            const TextRow("1)  You can swipe the view ", Icon(Icons.web_asset),
                " to switch"),
            TextRow("2)  In landscape mode,you can tap the card in the left",
                cardShow(context), " to switch"),
            const TextRow("3)  In portrait mode,you can tap ", Icon(Icons.map),
                " to open map and switch"),
            //----------------delete-------------
            textTitle("Delete"),
            TextRow(
                "Tap",
                SizedBox(
                  height: 110,
                  width: 150,
                  child: commonCard(
                    context: context,
                    title: "Delete",
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                ),
                "to enable deleting mode"),
            TextRow(
                "Tap the city you want to delete",
                SizedBox(
                    height: 110,
                    width: 150,
                    child: commonCard(
                        context: context,
                        title: "London",
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("32℃"),
                            Text(
                              "✖",
                              style: TextStyle(color: Colors.red),
                            )
                          ],
                        ))),
                "to delete"),
            TextRow(
                "Tap again",
                SizedBox(
                  height: 110,
                  width: 150,
                  child: commonCard(
                    context: context,
                    title: "Cancel",
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.subdirectory_arrow_left,
                          color: Colors.blueAccent,
                        ),
                      ],
                    ),
                  ),
                ),
                "to exit deleting mode"),
            textTitle("Reorder the List"),
            TextRow("Long press the card", cardShow(context),
                "to reorder the list"),
            textTitle("setting"),
            TextRow(
                "Tap the button in the right top ",
                IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
                " to open it"),
            TextRow(
                "And you can tap",
                ElevatedButton(
                    onPressed: () {}, child: const Text("Read Introduce")),
                "to open the User's Guide again"),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 50, 0, 50),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "I'm fully understand",
                      textScaler: TextScaler.linear(1.2),
                    ),
                  )),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Icon(Icons.subdirectory_arrow_left),
      ),
    );
  }
}

Widget cardShow(BuildContext context) {
  return SizedBox(
      height: 110,
      width: 250,
      child: commonCard(
          context: context,
          title: "London",
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("32℃"),
              Text(
                "Clear",
              )
            ],
          )));
}
