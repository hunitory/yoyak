import 'package:flutter/material.dart';
import 'package:yoyak/styles/colors/palette.dart';

class MainAppBarButton extends StatelessWidget {
  final Function() onPressed;
  final String text;
  final String colorMode; // 'white' || 'blue'
  final ButtonStyle? style;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final double? fontSize;

  const MainAppBarButton({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.colorMode,
    this.style,
    this.borderRadius,
    this.height,
    this.width,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    // non-nullable 변수이므로, 초기화
    Color backgroundColor = Palette.MAIN_WHITE;
    Color textColor = Palette.MAIN_BLUE;

    // colorMode 값에 따라 버튼 색 결정
    if (colorMode == 'white') {
      backgroundColor = Palette.MAIN_WHITE;
      textColor = Palette.MAIN_BLUE;
    } else if (colorMode == 'blue') {
      backgroundColor = Palette.MAIN_BLUE;
      textColor = Palette.MAIN_WHITE;
    }

    // 버튼을 눌렀을 때  기본효과(inkwell)를 제거하기 위한 ButtonStyle
    final ButtonStyle buttonStyle = ButtonStyle(
      backgroundColor: MaterialStateProperty.all(backgroundColor),
      // 물결 효과 제거
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          // 사용시에는 borderRadius: BorderRadius.circular(원하는값),
          borderRadius: borderRadius ?? BorderRadius.circular(30),
        ),
      ),
    ).merge(style); // 추가적으로 제공된 스타일과 병합

    return SizedBox(
      width: width ?? 110,
      height: height ?? 43,
      child: TextButton(
        onPressed: onPressed,
        style: buttonStyle,
        child: Center(
          // 텍스트를 가운데 정렬하기 위해 Center 위젯 추가
          child: Text(
            text,
            textAlign: TextAlign.center, // 텍스트를 수평 가운데 정렬
            style: TextStyle(
              color: textColor,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500,
              fontSize: fontSize ?? 16,
            ),
          ),
        ),
      ),
    );
  }
}
