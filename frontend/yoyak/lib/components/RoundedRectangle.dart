import 'package:flutter/material.dart';
import 'package:yoyak/screen/Alarm/alarm_screen.dart';
import 'package:yoyak/screen/Mypage/mypage_screen.dart';

class RoundedRectangle extends StatelessWidget {
  final double width, height;
  final destination;
  // final Color color;
  final Widget child;
  final List<BoxShadow>? boxshadow;
  const RoundedRectangle(
      {super.key,
      required this.width,
      required this.height,
      required this.child,
      this.destination,
      this.boxshadow});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => destination));
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              width: 0.1,
              color: Colors.white,
            ),
            boxShadow: boxshadow,
          ),
          width: width,
          height: height,
          child: child,
        ));
  }
}
