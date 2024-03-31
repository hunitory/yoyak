import 'package:flutter/material.dart';
import 'package:yoyak/styles/colors/palette.dart';

class BaseButton extends StatelessWidget {
  final Function() onPressed;
  final String text;
  final String colorMode; // 'white' || 'blue'
  final ButtonStyle? style;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final double? fontSize;
  final backgroundColor;
  final borderWidth;

  // 필수 값
  // 눌렀을 때 실행시킬 함수, 버튼 글자, 컬러 모드(흰색, 파랑색)
  // 기본 값
  // 버튼 width, height, 버튼 style(border, color 등), borderRadius, fontSize

  const BaseButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.colorMode,
    this.style,
    this.borderRadius,
    this.height,
    this.width,
    this.fontSize,
    this.backgroundColor,
    this.borderWidth,
  });

  @override
  Widget build(BuildContext context) {
    // non-nullable 변수이므로, 초기화
    Color borderColor = Palette.MAIN_BLUE;
    Color backgroundColor = Palette.MAIN_BLUE;
    Color textColor = Palette.MAIN_WHITE;

    // colorMode 값에 따라 버튼 색 결정
    if (colorMode == 'white') {
      borderColor = Palette.MAIN_BLUE;
      backgroundColor = Palette.MAIN_WHITE;
      textColor = Palette.MAIN_BLUE;
    } else if (colorMode == 'blue') {
      borderColor = Palette.MAIN_BLUE;
      backgroundColor = Palette.MAIN_BLUE;
      textColor = Palette.MAIN_WHITE;
    } else if (colorMode == 'gray') {
      backgroundColor = Palette.SHADOW_GREY;
    }

    // 버튼을 눌렀을 때  기본효과(inkwell)를 제거하기 위한 ButtonStyle
    final ButtonStyle buttonStyle = ButtonStyle(
      side: MaterialStateProperty.all(BorderSide(
        color: borderColor,
        width: borderWidth ?? 1.5,
      )),
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
      child: OutlinedButton(
        onPressed: onPressed,
        style: buttonStyle,
        child: Text(
          textAlign: TextAlign.center,
          text,
          style: TextStyle(
            color: textColor,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w700,
            fontSize: fontSize ?? 16,
          ),
        ),
      ),
    );
  }
}
