import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyak/components/main_appbar.dart';
import 'package:yoyak/components/rounded_rectangle.dart';
import 'package:yoyak/models/user/account_models.dart';
import 'package:yoyak/screen/Alarm/alarm_screen.dart';
import 'package:yoyak/screen/Challenge/challenge_screen.dart';
import 'package:yoyak/screen/Login/kakao_login_screen.dart';
import 'package:yoyak/screen/PillBag/pill_bag_screen.dart';
import 'package:yoyak/screen/Search/filter_search_screen.dart';
import 'package:yoyak/screen/Search/photo_search_screen.dart';
import 'package:yoyak/store/pill_bag_store.dart';
import 'package:yoyak/styles/colors/palette.dart';
import '../../auto_login/singleton_secure_storage.dart';
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
  void dispose() {
    flickManager.dispose(); // FlickManager 리소스 해제
    super.dispose();
  }

  Future<Map<String, String?>> getUserData() async {
    var storage = SingletonSecureStorage().storage;
    var accessToken = await storage.read(key: 'accessToken');
    var userName = await storage.read(key: 'userName');
    // userName과 accessToken을 Map으로 반환합니다.
    return {'userName': userName, 'accessToken': accessToken};
  }

  void goTo(destination) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double rectangleSize = MediaQuery.of(context).size.width * 0.44;
    // LoginStore에서 alarmAccounts 가져오기
    List<AccountModel> alarmAccounts = context.watch<LoginStore>().accountList;
    print("accountList: $alarmAccounts");
    // 약 봉투 read 요청 - 로그인 됐을 때
    if (alarmAccounts.isNotEmpty) {
      context.read<PillBagStore>().getPillBagDatas(context, medicineSeq: 0);
    }

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
      body: SingleChildScrollView(
        child: FutureBuilder<Map<String, String?>>(
          future: getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // 데이터를 기다리는 중일 때의 UI
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              // 에러가 발생한 경우의 UI
              return Text('Error: ${snapshot.error}');
            } else {
              // 데이터를 성공적으로 받아온 경우의 UI
              var userData = snapshot.data;
              var accessToken = userData?['accessToken'];
              var userName = userData?['userName'];
              return Column(
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
                            controls: Container(),
                          ),
                          flickVideoWithControlsFullscreen:
                              FlickVideoWithControls(
                            controls: Container(),
                          ),
                        ),
                      ),
                      MainAppBar(
                        color: Colors.black.withOpacity(0),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (accessToken != null) ...[
                              Text(
                                "안녕하세요 $accessToken님",
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Palette.MAIN_WHITE,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Pretendard',
                                ),
                              ),
                              const SizedBox(height: 3),
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
                              const SizedBox(height: 3),
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
                          topRight: Radius.circular(20),
                        ),
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
                                onTap: () {
                                  alarmAccounts.isNotEmpty
                                      ? goTo(const PillBagScreen())
                                      : goTo(const KakaoLoginScreen());
                                },
                                child: const IconInRectangle(
                                  subTitle: "내 약을 한눈에",
                                  title: "MY 약 봉투",
                                  imagePath: "assets/images/envelop.png",
                                ),
                              ),
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
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
