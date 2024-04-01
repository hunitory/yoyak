import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyak/components/base_button.dart';
import 'package:yoyak/store/challenge_store.dart';
import 'package:yoyak/store/login_store.dart';
import 'package:yoyak/styles/screenSize/screen_size.dart';
import '../styles/colors/palette.dart';
import 'package:simple_progress_indicators/simple_progress_indicators.dart';

class LookAroundChallengeCard extends StatelessWidget {
  const LookAroundChallengeCard({super.key, this.challenge});
  final challenge;

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
          height: 270,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ), // 둥근 모서리 반경 설정
                child: Image.network(
                  challenge?['imgUrl'],
                  width: 200, // 이미지의 가로 크기
                  height: 110, // 이미지의 세로 크기
                  fit: BoxFit.cover, // 이미지의 크기를 설정한 크기에 맞게 조정
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      challenge?['title'] ?? "챌린지 이름",
                      style: const TextStyle(
                        color: Palette.MAIN_BLACK,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                      ),
                    ), // 게시물 제목
                    Text(
                      challenge?['userNickname'] ?? "유저 닉네임",
                      style: const TextStyle(
                        color: Palette.SUB_BLACK,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
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
                    const SizedBox(
                      height: 20,
                    ),


                    BaseButton(
                      width: cardWidth,
                      height: 40,
                      fontSize: 15,
                      borderWidth: 1.0,
                      onPressed: () {
                        context.read<ChallengeStore>().cheerUp(challenge?['articleSeq']);
                      },
                      text: "응원하기",
                      colorMode: 'white',
                      borderRadius: BorderRadius.circular(10),
                    )
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
