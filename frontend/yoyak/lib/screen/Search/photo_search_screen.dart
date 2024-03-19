import 'package:flutter/material.dart';
import 'package:yoyak/components/RoundedRectangle.dart';
import '../../styles/colors/palette.dart';

class PhotoSearchScreen extends StatelessWidget {
  const PhotoSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double rectangleWidth = MediaQuery.of(context).size.width * 0.8;
    double rectangleHeight = MediaQuery.of(context).size.width * 0.5;

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        width: double.infinity,
        color: Palette.SUB_BLUE,
        padding: EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Text(
                "사진으로 알약 검색",
                style: TextStyle(
                    color: Palette.MAIN_BLACK,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w700,
                    fontSize: 24),
              ),
            ),
            Text(
              "인식률을 높이기 위해, ",
              style: TextStyle(
                  color: Palette.MAIN_BLACK,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                  fontSize: 14),
            ),
            Text(
              "밝은 곳에서 알약의 문자가 잘 보이게 촬영해주세요.",
              style: TextStyle(
                  color: Palette.MAIN_BLACK,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                  fontSize: 14),
            ),
            // Spacer(),
            Container(
              margin: EdgeInsets.only(top: 50, bottom: 40),
              child: RoundedRectangle(
                width: rectangleWidth,
                height: rectangleHeight,
                boxshadow: [
                  BoxShadow(
                    color: Palette.SHADOW_GREY,
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  )
                ],
                child: Container(
                  child: Image(
                    image: AssetImage('assets/images/guide.png'),
                  ),
                  // child: Image.asset('assets/images/guide.png'),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(),
                  child: Column(
                    children: [
                      RoundedRectangle(
                        width: MediaQuery.of(context).size.width * 0.35,
                        height: MediaQuery.of(context).size.width * 0.35,
                        boxshadow: [
                          BoxShadow(
                            color: Palette.SHADOW_GREY,
                            blurRadius: 3,
                            offset: Offset(0, 2),
                          )
                        ],
                        child: Container(
                          child: Image(
                            image: AssetImage('assets/images/guide.png'),
                          ),
                          // child: Image.asset('assets/images/guide.png'),
                        ),
                      ),
                      Text("이미지 업로드")
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(),
                  child: Column(
                    children: [
                      RoundedRectangle(
                        width: MediaQuery.of(context).size.width * 0.35,
                        height: MediaQuery.of(context).size.width * 0.35,
                        boxshadow: [
                          BoxShadow(
                            color: Palette.SHADOW_GREY,
                            blurRadius: 3,
                            offset: Offset(0, 2),
                          )
                        ],
                        child: Container(
                          child: Image(
                            image: AssetImage('assets/images/guide.png'),
                          ),
                          // child: Image.asset('assets/images/guide.png'),
                        ),
                      ),
                      Text("촬영하기")
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
