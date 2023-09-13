import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 50, 0, 20),
            child: Text(
              "It seems that you haven't added a city yet",
              textAlign: TextAlign.center,
            ),
          ),
          Text("Click the top left button to add one"),
        ],
      ),
    );
  }
}
