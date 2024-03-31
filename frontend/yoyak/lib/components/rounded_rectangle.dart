import 'package:flutter/material.dart';
import 'package:yoyak/styles/colors/palette.dart';

class RoundedRectangle extends StatelessWidget {
  final double width, height;
  final Color? color;
  final Widget child;
  final List<BoxShadow>? boxShadow;
  final Function()? onTap;
  final BorderRadius? borderRadius;
  final Border? border;

// width, height 필수
// child 필수
// boxShadow 커스텀 가능 (기본 설정 O)
// onTap 커스텀 가능 (기본 설정 X)

  const RoundedRectangle({
    super.key,
    required this.width,
    required this.height,
    required this.child,
    this.color,
    this.boxShadow,
    this.onTap,
    this.borderRadius,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: color ?? Colors.white,
            borderRadius: borderRadius ?? BorderRadius.circular(15),
            border: border,
            boxShadow: boxShadow ??
                [
                  BoxShadow(
                    color: Palette.SUB_BLACK.withOpacity(0.15),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ]),
        width: width,
        height: height,
        child: child,
      ),
    );
  }
}
