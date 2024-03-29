import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyak/components/my_challenge_card.dart';
import 'package:yoyak/components/challenge_appbar.dart';
import 'package:yoyak/store/challenge_store.dart';
import 'package:yoyak/styles/colors/palette.dart';
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
    var accessToken = context.read<LoginStore>().accessToken;
    context.read<ChallengeStore>().getMyChallenge(accessToken);

    return const Scaffold(
      backgroundColor: Palette.BG_BLUE,
      appBar: ChallengeaAppBar(
        color: Palette.BG_BLUE,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 50, 20, 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 챌린지 아직 시작 안했을 때

                  _ChallengeTitleSection(),

                  SizedBox(
                    height: 40,
                  ),
                  MyChallengeCard(
                    title: "성현님이 진행 중인 챌린지",
                    titleImagePath: "assets/images/medal.png",
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  OtherChallengeCard(
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
    print("내 챌린지 목록 길이: ${myChallengeList.length}");
    print("내 챌린지 목록: $myChallengeList");
    return myChallengeList.isEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
          )
        : Column(
            children: [
              const SizedBox(
                height: 60,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "D-5",
                      style: TextStyle(
                        fontSize: 22,
                        color: Palette.MAIN_BLUE,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Pretendard',
                      ),
                    ),
                    RichText(
                        text: const TextSpan(children: [
                      TextSpan(
                        text: '현재까지 복약율  ',
                        style: TextStyle(
                          fontSize: 17,
                          color: Palette.MAIN_BLACK,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                      TextSpan(
                        text: '50',
                        style: TextStyle(
                          fontSize: 30,
                          color: Palette.MAIN_BLACK,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                      TextSpan(
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
            ],
          );
  }
}
