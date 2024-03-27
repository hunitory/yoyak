import 'package:flutter/material.dart';
import 'package:yoyak/components/rounded_rectangle.dart';
import 'package:yoyak/styles/screenSize/screen_size.dart';

import '../styles/colors/palette.dart';
import 'challenge_card.dart';

class OtherChallengeCard extends StatelessWidget {
  const OtherChallengeCard(
      {super.key,
      this.subTitle,
      this.title,
      this.imagePath,
      this.titleImagePath});

  final subTitle, title, imagePath, titleImagePath;

  @override
  Widget build(BuildContext context) {
    double cardListWidth = MediaQuery.of(context).size.width * 0.9;
    // 응원했으면 배경 색, 글씨 색 바꾸기
    return RoundedRectangle(
      width: ScreenSize.getWidth(context),
      height: 400,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (subTitle != null)
            Text(
              "$subTitle",
              style: const TextStyle(
                  fontFamily: "Pretendard",
                  color: Palette.SUB_BLACK,
                  fontWeight: FontWeight.w500,
                  fontSize: 15),
            ),
          Row(
            children: [
              Text(
                "$title",
                style: const TextStyle(
                    fontFamily: "Pretendard",
                    color: Palette.MAIN_BLACK,
                    fontWeight: FontWeight.w600,
                    fontSize: 19),
              ),
              if (titleImagePath != null)
                Image.asset(
                  titleImagePath,
                  width: 50,
                  height: 50,
                ),
            ],
          ),
          // Spacer 제거 또는 SizedBox로 변경
          const SizedBox(height: 10), // 예시로 추가한 SizedBox
          if (imagePath != null)
            Image.asset(
              imagePath,
              width: 70,
              height: 70,
            ),

          // 챌린지 시작했을 때, 안했을 때 분기
          SizedBox(
                  width: cardListWidth,
                  height: 300,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: 6, // 개수 고치기 배열의 길이로
                      itemBuilder: (context, i) {
                        return const ChallengeCard();
                      }),
                )

        ]),
      ),
    );
  }
}