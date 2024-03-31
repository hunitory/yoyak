import 'package:flick_video_player/flick_video_player.dart';
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
import 'package:video_player/video_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final FlickManager flickManager;

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      autoPlay: true,
      videoPlayerController: VideoPlayerController.asset(
        'assets/videos/hangang.mp4',
      )
        ..setLooping(true)
        ..setVolume(0), // 비디오 반복 재생 설정
      onVideoEnd: () {
        // 비디오가 끝나면 다시 처음부터 재생
        flickManager.flickControlManager?.seekTo(Duration.zero);
        flickManager.flickControlManager?.play();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double rectangleSize = MediaQuery.of(context).size.width * 0.44;
    // LoginStore에서 alarmAccounts 가져오기
    List<AccountModel> alarmAccounts = context.watch<LoginStore>().accountList;

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
      // appBar: const MainAppBar(
      //   color: Palette.MAIN_BLUE,
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: screenWidth,
                  height: 250,
                  color: Palette.MAIN_BLUE,
                ),
                Positioned.fill(
                  child: FlickVideoPlayer(
                    flickManager: flickManager,
                    flickVideoWithControls: FlickVideoWithControls(
                      controls: Container(), // 컨트롤을 비어 있는 컨테이너로 설정하여 숨깁니다.
                    ),
                    flickVideoWithControlsFullscreen: FlickVideoWithControls(
                      controls: Container(), // 전체 화면 모드에서도 컨트롤을 숨깁니다.
                    ),
                  ),
                ),
                MainAppBar(
                  color: Colors.black.withOpacity(0),
                ),
                Positioned(
                  bottom: 20, // 원하는 위치로 조정
                  left: 20, // 원하는 위치로 조정
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (account != null) ...[
                        Text(
                          "안녕하세요 ${account.nickname}님",
                          style: const TextStyle(
                            fontSize: 20,
                            color: Palette.MAIN_WHITE,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Pretendard',
                          ),
                        ),
                        const SizedBox(height: 3), // SizedBox로 간격 조정
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
                                text: "오늘도 ",
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                ),
                              ),
                              TextSpan(
                                text: "요약",
                                style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.yellow,
                                  fontFamily: 'Pretendard',
                                ),
                              ),
                              TextSpan(
                                text: " 하세요!",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Pretendard',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        const Row(
                          children: [
                            Text(
                              "약이 궁금할 땐, ",
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Pretendard',
                              ),
                            ),
                            Text(
                              "요약",
                              style: TextStyle(
                                fontSize: 24,
                                color: Palette.MAIN_BLUE,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Pretendard',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3), // SizedBox로 간격 조정

                        // const Text(
                        //   "더 많은 서비스를 이용하실 수 있습니다.",
                        //   style: TextStyle(
                        //     fontSize: 18,
                        //     color: Colors.white,
                        //     fontWeight: FontWeight.w600,
                        //     fontFamily: 'Pretendard',
                        //   ),
                        // )
                      ]
                    ],
                  ),
                ),
              ],
            ),
            Container(
              color: Palette.MAIN_WHITE,
              child: Container(
                  decoration: BoxDecoration(
                    color: Palette.MAIN_WHITE,
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

  @override
  void dispose() {
    flickManager.dispose(); // FlickManager 리소스 해제
    super.dispose();
  }
}
