import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_progress_indicators/simple_progress_indicators.dart';
import 'package:yoyak/auto_login/singleton_secure_storage.dart';
import 'package:yoyak/components/my_challenge_card.dart';
import 'package:yoyak/components/challenge_appbar.dart';
import 'package:yoyak/screen/Challenge/regist_challenge_screen.dart';
import 'package:yoyak/store/challenge_store.dart';
import 'package:yoyak/styles/colors/palette.dart';
import 'package:yoyak/styles/screenSize/screen_size.dart';
import '../../components/base_button.dart';
import '../../components/dialog.dart';
import '../../components/other_challenge_card.dart';
import '../../hooks/goto_screen.dart';
import '../../store/camera_store.dart';
import '../../store/login_store.dart';
import '../Login/login_screen.dart';
import '../Mypage/mypage_screen.dart';

class ChallengeScreen extends StatefulWidget {
  const ChallengeScreen({super.key});

  @override
  State<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> with WidgetsBindingObserver {
  String accessToken = '';



  Future<void> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      accessToken = prefs.getString('accessToken') ?? ''; // accessToken state 업데이트
    });
  }

  @override
  void initState() {
    super.initState();
    getAccessToken();
    WidgetsBinding.instance.addObserver(this);
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print('resumed123');
        break;
      case AppLifecycleState.inactive:
        print('inactive123');
        break;
      case AppLifecycleState.detached:
        print('detached123');
        // DO SOMETHING!
        break;
      case AppLifecycleState.paused:
        print('paused123');
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    context.read<ChallengeStore>().getMyChallenge(accessToken); // 내 챌린지 호출
    context.read<ChallengeStore>().getMyChallengeList(accessToken); // 내 챌린지 덱 호출
    context.read<ChallengeStore>().getOthersChallenge(accessToken); // 챌린지 둘러보기 호출

    // storage에서 사용자 이름 불러오기 - 수정하기
    Future<String?> getUserName() async {
      var storage = SingletonSecureStorage().storage;
      var userName = await storage.read(key: 'userName');
      return userName;
    }

    return Scaffold(
      backgroundColor: Palette.BG_BLUE,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 10,
              color: Colors.white,
            ),
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
                  FutureBuilder<String?>(
                    future: getUserName(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // 데이터를 기다리는 중일 때의 UI
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        // 에러가 발생한 경우의 UI
                        return Text('Error: ${snapshot.error}');
                      } else {
                        // 데이터를 성공적으로 받아온 경우의 UI
                        var userName = snapshot.data;
                        return MyChallengeCard(
                          title: "$userName님이 진행 중인 챌린지",
                          titleImagePath: "assets/images/medal.png",
                        );
                      }
                    },
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

  Future<String?> getUserName() async {
    var storage = SingletonSecureStorage().storage;
    var userName = await storage.read(key: 'userName');
    return userName;
  }

  @override
  Widget build(BuildContext context) {
    var myChallengeList = context.watch<ChallengeStore>().myChallengeList;
    var myChallengeCard = context.watch<ChallengeStore>().myChallengeCard;

    var storage = context.read<LoginStore>().storage;
    var getImageAndNavigate = context.read<CameraStore>().getImageAndNavigate;


    var totalDay = (myChallengeCard?["day"]?? 0) + 1;
    var articleSize = myChallengeCard?["articleSize"];
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
                    "챌린지를 응원해요",
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
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


                  myChallengeCard.isEmpty
                      ? GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MypageScreen()));
                    },
                    child: SizedBox(
                        width: 120,
                        height: 33,
                        child: BaseButton(
                          height: 40,
                          fontSize: 15,
                          onPressed: () {
                            // print("tqtqtqtq: ${storage.read(key: 'accessToken')}");
                            storage.read(key: 'accessToken') != null ? goToScreen(context, const RegistChallengeScreen()) // 로그인 되어있다면
                                : showDialog(context: context, builder: (context) { // 로그인 안되어있을 경우
                              return const DialogUI(destination: LoginScreen(destination: RegistChallengeScreen(),),);
                            });
                          },
                          text: "시작하기",
                          colorMode: 'white',
                          borderWidth: 1.0,
                          borderRadius: BorderRadius.circular(20),
                        )),
                  )
                      : GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MypageScreen()));
                    },
                    child: SizedBox(
                        width: 130,
                        height: 33,
                        child: BaseButton(
                          height: 40,
                          fontSize: 15,
                          onPressed: () {
                            // 모달 창 나옴
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    height: 170,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 20),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              // 사진 촬영 기능 구현
                                              getImageAndNavigate(
                                                  ImageSource.camera, context);
                                            },
                                            child: const Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '사진 촬영',
                                                  style: TextStyle(
                                                    color: Palette.MAIN_BLUE,
                                                    fontFamily: 'Pretendard',
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 19,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const Divider(
                                          height: 0.1,
                                          color: Palette.SHADOW_GREY,
                                        ),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              // 이미지 업로드 기능 구현
                                              getImageAndNavigate(
                                                  ImageSource.gallery, context);
                                              // Navigator.pop(context);
                                            },
                                            child: const Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '이미지 업로드',
                                                  style: TextStyle(
                                                    color: Palette.MAIN_BLUE,
                                                    fontFamily: 'Pretendard',
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 19,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          },
                          text: "챌린지 올리기",
                          colorMode: 'white',
                          borderWidth: 1.0,
                          borderRadius: BorderRadius.circular(20),
                        )),
                  )

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
