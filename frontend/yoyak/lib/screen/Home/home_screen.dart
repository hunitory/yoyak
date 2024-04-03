import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yoyak/components/dialog.dart';
import 'package:yoyak/components/main_appbar.dart';
import 'package:yoyak/components/rounded_rectangle.dart';
import 'package:yoyak/models/user/account_models.dart';
import 'package:yoyak/screen/Alarm/alarm_screen.dart';
import 'package:yoyak/screen/Login/login_screen.dart';
import 'package:yoyak/screen/PillBag/pill_bag_screen.dart';
import 'package:yoyak/screen/Search/filter_search_screen.dart';
import 'package:yoyak/screen/Search/photo_search_screen.dart';
import 'package:yoyak/store/pill_bag_store.dart';
import 'package:yoyak/styles/colors/palette.dart';
import '../../components/icon_in_rectangle.dart';
import '../../store/login_store.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  String accessToken = '';
  AccountModel? account;

  @override
  void initState() {
    super.initState();
    loadUserData();
    loadAccountData();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("state는 이거임 : $state");
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

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      accessToken =
          prefs.getString('accessToken') ?? ''; // accessToken state 업데이트
      print('asdas asdasda $accessToken');
    });
  }

  Future<AccountModel?> loadAccount() async {
    final prefs = await SharedPreferences.getInstance();
    String? accountJson = prefs.getString('accountModel');
    if (accountJson != null) {
      return AccountModel.fromJson(jsonDecode(accountJson));
    }
    return null;
  }

  Future<void> loadAccountData() async {
    AccountModel? accountData = await loadAccount();
    setState(() {
      account = accountData; // 로드된 데이터로 account 변수 업데이트
    });
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

    // account 변수를 선언하고 조건에 따라 할당
    List<AccountModel> alarmAccounts = context.watch<LoginStore>().accountList;

    AccountModel? account =
        alarmAccounts.isNotEmpty ? alarmAccounts.first : null;

    // 약 봉투 read 요청 - 로그인 됐을 때
    if (accessToken.isNotEmpty) {
      context.read<PillBagStore>().getPillBagDatas(context, medicineSeq: 0);
    }
    goTo(destination) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => destination),
      );
    }

    return Scaffold(
      backgroundColor: Palette.MAIN_WHITE,
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
                MainAppBar(
                  color: Colors.black.withOpacity(0),
                ),
                Positioned(
                  bottom: 25,
                  left: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (accessToken.isNotEmpty) ...[
                        Text(
                          "안녕하세요 ${account?.nickname}님",
                          style: const TextStyle(
                            fontSize: 23,
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
                              fontSize: 23,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Pretendard',
                            ),
                            children: [
                              TextSpan(
                                text: "오늘도 ",
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: 23,
                                ),
                              ),
                              TextSpan(
                                text: "요약",
                                style: TextStyle(
                                  fontSize: 26,
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
                                  fontSize: 23,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        const Row(
                          children: [
                            Text(
                              "요 약이 궁금할 땐, ",
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
                                color: Colors.yellow,
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
                decoration: const BoxDecoration(
                  color: Palette.MAIN_WHITE,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
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
                            if (accessToken.isNotEmpty) {
                              goTo(const PillBagScreen());
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return const DialogUI(
                                      destination: LoginScreen());
                                },
                              );
                            }
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
                            goTo(
                              const AlarmScreen(),
                            );
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
        ),
      ),
    );
  }
}
