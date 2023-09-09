import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Search.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Welcome to Shape Weather"),),
      body: Center(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 50, 0, 20),
              child: Text("It seems that you haven't added a city yet\nClick the button below to add one" ,textAlign: TextAlign.center,),
            ),
            ElevatedButton(onPressed: (){
              Navigator.push(context, CupertinoPageRoute(builder: (builder) {
                return const LocationSearch();
              }));
            }, child: const Text("ADD")),
          ],
        ),
      ),
    );
  }
}
