import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:yoyak/components/rounded_rectangle.dart';
import 'package:yoyak/store/challenge_store.dart';
import 'package:yoyak/styles/screenSize/screen_size.dart';
import '../styles/colors/palette.dart';
import 'challenge_card.dart';

class MyChallengeCard extends StatelessWidget {
  const MyChallengeCard(
      {super.key,
      this.subTitle,
      this.title,
      this.imagePath,
      this.titleImagePath});

  final subTitle, title, imagePath, titleImagePath;

  @override
  Widget build(BuildContext context) {
    double cardListWidth = MediaQuery.of(context).size.width * 0.9;
    var myChallengeList = context.watch<ChallengeStore>().myChallengeList;
    var myChallengeCard = context.watch<ChallengeStore>().myChallengeCard;
    return RoundedRectangle(
      width: ScreenSize.getWidth(context),
      height: 350,
      color: Palette.MAIN_WHITE,
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
          myChallengeCard.length != 0
              ? myChallengeList.isNotEmpty
                  ? SizedBox(
                      width: cardListWidth,
                      height: 255,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: myChallengeList.length, // 개수 고치기 배열의 길이로
                          itemBuilder: (context, i) {
                            // 사버에서 받은 데이터로 넘겨주기
                            return ChallengeCard(challenge: myChallengeList[i]);
                          }),
                    )
                  : SizedBox(
                      width: ScreenSize.getWidth(context),
                      height: 200,
                      child: Center(
                          child: Column(
                        children: [
                          Lottie.asset('assets/lotties/cat.json',
                              width: 120, height: 120),
                          Text(
                            "${myChallengeCard?['title'] ?? ""} 챌린지의 인증샷을 올려보세요!",
                            style: const TextStyle(
                                fontFamily: "Pretendard",
                                color: Palette.SUB_BLACK,
                                fontWeight: FontWeight.w500,
                                fontSize: 15),
                          ),
                        ],
                      )),
                    )
              : SizedBox(
                  width: ScreenSize.getWidth(context),
                  height: 200,
                  child: Center(
                      child: Column(
                    children: [
                      Lottie.asset('assets/lotties/cat.json',
                          width: 120, height: 120),
                      const Text(
                        "챌린지를 시작해볼까요?",
                        style: TextStyle(
                            fontFamily: "Pretendard",
                            color: Palette.SUB_BLACK,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                    ],
                  )),
                )
        ]),
      ),
    );
  }
}
