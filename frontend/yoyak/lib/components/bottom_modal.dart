import 'package:flutter/material.dart';
import 'package:yoyak/styles/screenSize/screen_size.dart';

import '../styles/colors/palette.dart';

class BottomModal extends StatelessWidget {
  final Widget child;
  final double? height;

  const BottomModal({
    super.key,
    required this.child,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 200,
      width: ScreenSize.getWidth(context),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Palette.MAIN_WHITE,
      ),
      child: child,
    );
  }
}
