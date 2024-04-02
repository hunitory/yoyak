import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_progress_indicators/simple_progress_indicators.dart';
import 'package:yoyak/auto_login/singleton_secure_storage.dart';
import 'package:yoyak/components/my_challenge_card.dart';
import 'package:yoyak/components/challenge_appbar.dart';
import 'package:yoyak/store/challenge_store.dart';
import 'package:yoyak/styles/colors/palette.dart';
import 'package:yoyak/styles/screenSize/screen_size.dart';
import '../../components/other_challenge_card.dart';
import '../../store/login_store.dart';

class ChallengeScreen extends StatefulWidget {
  const ChallengeScreen({super.key});

  @override
  State<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {

  @override
  Widget build(BuildContext context) {
    var userName = context.read<LoginStore>().userName;
    context.read<ChallengeStore>().getMyChallenge(); // 내 챌린지 호출
    context.read<ChallengeStore>().getMyChallengeList(); // 내 챌린지 덱 호출
    context.read<ChallengeStore>().getOthersChallenge(); // 챌린지 둘러보기 호출

    return Scaffold(
      backgroundColor: Palette.BG_BLUE,
      appBar: const ChallengeaAppBar(
        color: Palette.MAIN_WHITE
        ,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: ScreenSize.getWidth(context),
              height: 250,
              color: Palette.MAIN_WHITE,
              child: const Padding(
                padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
                child: _ChallengeTitleSection(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 30, 15, 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  MyChallengeCard(
                    title: "$userName님이 진행 중인 챌린지",
                    titleImagePath: "assets/images/medal.png",
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const OtherChallengeCard(
                    title: "챌린지 둘러보기",
                    titleImagePath: "assets/images/medal.png",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChallengeTitleSection extends StatelessWidget {
  const _ChallengeTitleSection({super.key});

  @override
  Widget build(BuildContext context) {
    var myChallengeList = context.watch<ChallengeStore>().myChallengeList;
    var myChallengeCard = context.watch<ChallengeStore>().myChallengeCard;
    var userName = context.read<LoginStore>().userName; // 사용자 이름
    print("내 챌린지 목록 길이: ${myChallengeList.length}");
    print("내 챌린지 목록: $myChallengeList");

    var totalDay = (myChallengeCard?["day"]?? 0) + 1;
    var articleSize = myChallengeCard?["articleSize"];
    print("totalDay $totalDay");
    // 챌린지를 시작하지 않은 경우
    if (myChallengeCard.isEmpty) {
      return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "꾸준한 복용을 위해",
                style: TextStyle(
                  fontSize: 20,
                  color: Palette.SUB_BLACK.withOpacity(0.5),
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Pretendard',
                ),
              ),
              RichText(
                  text: const TextSpan(children: [
                TextSpan(
                  text: '새로운 ',
                  style: TextStyle(
                    fontSize: 27,
                    color: Palette.MAIN_BLACK,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Pretendard',
                  ),
                ),
                TextSpan(
                  text: '챌린지',
                  style: TextStyle(
                    fontSize: 27,
                    color: Palette.MAIN_BLUE,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Pretendard',
                  ),
                ),
                TextSpan(
                  text: '를',
                  style: TextStyle(
                    fontSize: 27,
                    color: Palette.MAIN_BLACK,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Pretendard',
                  ),
                ),
              ])),
              const Text(
                "시작해보세요",
                style: TextStyle(
                  fontSize: 27,
                  color: Palette.MAIN_BLACK,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Pretendard',
                ),
              ),
            ],
          );
    } else {  // 챌린지를 시작했다면
      return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 10,),
                  Text(
                    "$userName님의 챌린지를 응원해요",
                    style: TextStyle(
                      fontSize: 17,
                      color: Palette.SUB_BLACK.withOpacity(0.6),
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Pretendard',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 10,),
                  Text(
                    myChallengeCard["title"],
                    style: const TextStyle(
                      fontSize: 27,
                      color: Palette.MAIN_BLACK,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Pretendard',
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "D-$totalDay",
                      style: const TextStyle(
                        fontSize: 22,
                        color: Palette.MAIN_BLUE,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Pretendard',
                      ),
                    ),
                    RichText(
                        text: TextSpan(children: [
                      const TextSpan(
                        text: '현재까지 완료율   ',
                        style: TextStyle(
                          fontSize: 16,
                          color: Palette.MAIN_BLACK,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                      TextSpan(
                        text: "${((myChallengeList.length / totalDay) * 100).toInt()}",
                        style: const TextStyle(
                          fontSize: 30,
                          color: Palette.MAIN_BLACK,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                      const TextSpan(
                        text: '%',
                        style: TextStyle(
                          fontSize: 17,
                          color: Palette.MAIN_BLACK,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                    ])),
                  ],
                ),
              ),
              const SizedBox(height: 20,),
              // Progress Bar
              AnimatedProgressBar(
                width: ScreenSize.getWidth(context) * 0.82,
                height: 10,
                value: articleSize / totalDay,
                duration: const Duration(seconds: 1),
                gradient: const LinearGradient(
                  colors: [
                    Colors.lightBlue,
                    Palette.MAIN_BLUE,
                  ],
                ),
                backgroundColor: Palette.SUB_BLACK.withOpacity(0.1),
              ),

            ],
          );
    }
  }
}
