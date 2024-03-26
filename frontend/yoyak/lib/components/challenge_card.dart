import 'package:flutter/material.dart';
import 'package:yoyak/styles/screenSize/screen_size.dart';
import '../styles/colors/palette.dart';
import 'package:simple_progress_indicators/simple_progress_indicators.dart';

class ChallengeCard extends StatelessWidget {
  const ChallengeCard({super.key});

  @override
  Widget build(BuildContext context) {
    double cardWidth = ScreenSize.getWidth(context) * 0.4;
    return Padding(
      padding: const EdgeInsets.only(top: 15, right: 10),
      child: GestureDetector(
              onTap: () {},
              child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(width: 0.4, color: Palette.SHADOW_GREY),
      ),
      width: cardWidth,
      height: 210,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ), // 둥근 모서리 반경 설정
            child: Image.asset(
              'assets/images/medicine1.jpg',
              width: 200, // 이미지의 가로 크기
              height: 110, // 이미지의 세로 크기
              fit: BoxFit.cover, // 이미지의 크기를 설정한 크기에 맞게 조정
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '알약 인증합니다',
                  style: TextStyle(
                    color: Palette.MAIN_BLACK,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                  ),
                ), // 게시물 제목
                const Text(
                  '성혀니',
                  style: TextStyle(
                    color: Palette.SUB_BLACK,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 20,),
                // Progress Bar
            AnimatedProgressBar(
              width: cardWidth * 0.9,
              height: 10,
              value: 0.4,
              duration: const Duration(seconds: 1),
              gradient: const LinearGradient(
                colors: [
                  Colors.lightBlue,
                  Palette.MAIN_BLUE,
                ],
              ),
              backgroundColor: Palette.BG_BLUE,
            ),


              ],
            ),
          )
        ],
      ),
              ),
            ),
    );
  }
}