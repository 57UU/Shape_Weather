import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CheckUpdates extends StatefulWidget {
  const CheckUpdates({super.key});

  @override
  State<CheckUpdates> createState() => _CheckUpdatesState();
}

class _CheckUpdatesState extends State<CheckUpdates> {
  @override
  Widget build(BuildContext context) {
    if(kIsWeb){
      return const Center(child: Text("With Github Action\nWeb version is always the latest"),);
    }
    return const Placeholder();
  }
}
