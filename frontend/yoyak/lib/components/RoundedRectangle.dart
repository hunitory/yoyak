// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:yoyak/styles/colors/palette.dart';

class RoundedRectangle extends StatelessWidget {
  final double width, height;
  final Widget child;
  final List<BoxShadow>? boxShadow;
  final Function()? onTap;

// width, height 필수
// child 필수
// boxShadow 커스텀 가능 (기본 설정 O)
// onTap 커스텀 가능 (기본 설정 X)

  const RoundedRectangle({
    super.key,
    required this.width,
    required this.height,
    required this.child,
    this.boxShadow,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                width: 0.1,
                color: Colors.white,
              ),
              boxShadow: boxShadow ??
                  [
                    BoxShadow(
                      color: Palette.SUB_BLACK.withOpacity(0.15),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 0),
                    ),
                  ]),
          width: width,
          height: height,
          child: child,
        ));
  }
}
