
import 'package:flutter/cupertino.dart';

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(child: Column(
      children: [
        CupertinoButton(child: Text("Hello"), onPressed: (){})
      ],
    ),

    );
  }
}
