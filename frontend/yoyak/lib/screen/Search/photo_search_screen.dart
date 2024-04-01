import 'package:flutter/material.dart';
import 'package:yoyak/components/rounded_rectangle.dart';
import '../../styles/colors/palette.dart';

class PhotoSearchScreen extends StatelessWidget {
  const PhotoSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double rectangleWidth = MediaQuery.of(context).size.width * 0.8;
    double rectangleHeight = MediaQuery.of(context).size.width * 0.5;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '알약 검색',
          style: TextStyle(
            color: Palette.MAIN_BLACK,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w400,
            fontSize: 15,
          ),
        ),
        backgroundColor: Palette.BG_BLUE,
        centerTitle: true,
        toolbarHeight: 55,
      ),
      body: Container(
        width: double.infinity,
        color: Palette.BG_BLUE,
        padding: const EdgeInsets.all(40),
        // padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: const Text(
                "사진으로 알약 검색",
                style: TextStyle(
                    color: Palette.MAIN_BLACK,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w700,
                    fontSize: 24),
              ),
            ),
            const Text(
              "인식률을 높이기 위해, ",
              style: TextStyle(
                  color: Palette.MAIN_BLACK,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                  fontSize: 15),
            ),
            const Text(
              "밝은 곳에서 알약의 문자가 잘 보이게 촬영해주세요.",
              style: TextStyle(
                  color: Palette.MAIN_BLACK,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                  fontSize: 15),
            ),
            // Spacer(),
            Container(
              margin: const EdgeInsets.only(top: 50, bottom: 40),
              child: RoundedRectangle(
                width: rectangleWidth,
                height: rectangleHeight,
                boxShadow: const [
                  BoxShadow(
                    color: Palette.SHADOW_GREY,
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  )
                ],
                child: const Image(
                  image: AssetImage('assets/images/guide.png'),
                ),
              ),
            ),
            // => 이미지, 촬영 일러스트 변경하기!
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(),
                  child: Column(
                    children: [
                      RoundedRectangle(
                        width: MediaQuery.of(context).size.width * 0.35,
                        height: MediaQuery.of(context).size.width * 0.35,
                        boxShadow: const [
                          BoxShadow(
                            color: Palette.SHADOW_GREY,
                            blurRadius: 3,
                            offset: Offset(0, 2),
                          )
                        ],
                        child: Center(
                          // 이미지 크기 조절
                          child: Image.asset(
                            'assets/images/mountain.png',
                            width: rectangleHeight * 0.55,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "이미지 업로드",
                        style: TextStyle(
                            color: Palette.MAIN_BLACK,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(),
                  child: Column(
                    children: [
                      RoundedRectangle(
                        width: MediaQuery.of(context).size.width * 0.35,
                        height: MediaQuery.of(context).size.width * 0.35,
                        boxShadow: const [
                          BoxShadow(
                            color: Palette.SHADOW_GREY,
                            blurRadius: 3,
                            offset: Offset(0, 2),
                          )
                        ],
                        child: Center(
                          child: Image.asset(
                            'assets/images/camera.png',
                            fit: BoxFit.cover,
                            width: rectangleHeight * 0.55,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "촬영하기",
                        style: TextStyle(
                            color: Palette.MAIN_BLACK,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      )
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
