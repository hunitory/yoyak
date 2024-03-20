import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlarmCreate extends StatefulWidget {
  const AlarmCreate({super.key});

  @override
  State<AlarmCreate> createState() => _AlarmCreateState();
}

class _AlarmCreateState extends State<AlarmCreate> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Column(
      children: [
        Text('알람 생성 화면'),
      ],
    ));
  }
}
