import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyak/components/main_appbar.dart';
import 'package:yoyak/components/rounded_rectangle.dart';
import 'package:yoyak/models/user/account_models.dart';
import 'package:yoyak/screen/Alarm/alarm_screen.dart';
import 'package:yoyak/screen/Challenge/challenge_screen.dart';
import 'package:yoyak/screen/Login/kakao_login_screen.dart';
import 'package:yoyak/screen/Search/filter_search_screen.dart';
import 'package:yoyak/screen/Search/photo_search_screen.dart';
import 'package:yoyak/styles/colors/palette.dart';
import '../../components/icon_in_rectangle.dart';
import '../../store/login_store.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double rectangleSize = MediaQuery.of(context).size.width * 0.44;
    // LoginStore에서 alarmAccounts 가져오기
    List<AccountModel> alarmAccounts =
        context.watch<LoginStore>().alarmAccounts;

    // account 변수를 선언하고 조건에 따라 할당
    AccountModel? account =
        alarmAccounts.isNotEmpty ? alarmAccounts.first : null;

    goTo(destination) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => destination),
      );
    }

    return Scaffold(
      appBar: const MainAppBar(
        color: Palette.MAIN_BLUE,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: screenWidth,
              height: 180,
              color: Palette.MAIN_BLUE,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (account != null) ...[
                      Text(
                        "${account.nickname} 님! 안녕하세요.",
                        style: const TextStyle(
                          fontSize: 24,
                          color: Palette.MAIN_WHITE,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                      const SizedBox(height: 10), // SizedBox로 간격 조정
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            color: Palette.MAIN_WHITE,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Pretendard',
                          ),
                          children: [
                            TextSpan(
                              text: "오늘도 건강한 ",
                            ),
                            TextSpan(
                              text: "'요약'",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            TextSpan(
                              text: " 하세요.",
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      const Text(
                        "안녕하세요, 요약입니다.",
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                      const SizedBox(height: 10), // SizedBox로 간격 조정
                      const Text(
                        "로그인 하시면,",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                      const Text(
                        "더 많은 서비스를 이용하실 수 있습니다.",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Pretendard',
                        ),
                      )
                    ]
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.blueAccent,
              child: Container(
                  decoration: BoxDecoration(
                    color: Palette.BG_BLUE,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    border: Border.all(
                      width: 0.1,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                  ),
                  width: screenWidth,
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 40),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),
                          RoundedRectangle(
                            width: rectangleSize,
                            height: rectangleSize,
                            onTap: () {
                              goTo(const PhotoSearchScreen());
                            },
                            child: const IconInRectangle(
                              subTitle: "AI가 약을 찾아줘요",
                              title: "사진 찍기",
                              imagePath: "assets/images/camera.png",
                            ),
                          ),
                          const Spacer(),
                          RoundedRectangle(
                            width: rectangleSize,
                            height: rectangleSize,
                            onTap: () {
                              goTo(const FilterSearchScreen());
                            },
                            child: const IconInRectangle(
                              subTitle: "사진 찍기 힘들다면",
                              title: "검색하기",
                              imagePath: "assets/images/search.png",
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),
                          RoundedRectangle(
                              width: rectangleSize,
                              height: rectangleSize,
                              onTap: () => goTo(const KakaoLoginScreen()),
                              child: const IconInRectangle(
                                subTitle: "내 약을 한눈에",
                                title: "MY 약 봉투",
                                imagePath: "assets/images/envelop.png",
                              )),
                          const Spacer(),
                          RoundedRectangle(
                              width: rectangleSize,
                              height: rectangleSize,
                              onTap: () {
                                goTo(const AlarmScreen());
                              },
                              child: const IconInRectangle(
                                subTitle: "복약 시간 알려드려요",
                                title: "알림",
                                imagePath: "assets/images/alarm.png",
                              )),
                          const Spacer(),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      RoundedRectangle(
                          width: screenWidth * 0.91,
                          height: 180,
                          onTap: () => goTo(const ChallengeScreen()),
                          child: const IconInRectangle(
                              subTitle: "꾸준히 복용해봐요",
                              title: "챌린지 참여하기",
                              imagePath: "assets/images/flag.png")),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
