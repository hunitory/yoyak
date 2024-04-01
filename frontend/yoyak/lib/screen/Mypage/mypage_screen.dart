import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yoyak/components/rounded_rectangle.dart';
import 'package:yoyak/hooks/goto_screen.dart';
import 'package:yoyak/models/user/account_models.dart';
import 'package:yoyak/screen/Main/main_screen.dart';
import 'package:yoyak/screen/Mypage/privacy_policy.dart';
import 'package:yoyak/screen/Mypage/updateaccount_Screen.dart';
import 'package:yoyak/store/alarm_store.dart';
import 'package:yoyak/store/login_store.dart';
import 'package:yoyak/styles/colors/palette.dart';
import 'package:yoyak/styles/screenSize/screen_size.dart';
import '../../store/challenge_store.dart';

class MypageScreen extends StatefulWidget {
  const MypageScreen({super.key});

  @override
  State<MypageScreen> createState() => _MypageScreenState();
}

class _MypageScreenState extends State<MypageScreen> {
  // States
  List<String?> accountList = [];
  String userName = '';
  String gender = '';
  String birth = '';
  String disease = '';
  int profileImage = 0;

  Future<void> loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      accountList = prefs.getStringList('accountList')!;
      gender = prefs.getString('gender') ?? '';
      birth = prefs.getString('birth') ?? '';
      disease = prefs.getString('disease') ?? '';
      profileImage = prefs.getInt('profileImage') ?? 0;
    });
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
  Widget build(BuildContext context) {
    loadUserInfo();

    final String userdisease =
        context.read<LoginStore>().accountList[0].disease ?? '없음';

    String displayDisease = userdisease.length > 5
        ? '${userdisease.substring(0, 5)}...'
        : userdisease;

    void goToAccountUpdate(AccountModel? accountitem, bool isUser) {
      accountitem ??= AccountModel();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UpdateAccountScreen(
            accountitem: accountitem!,
            isUser: isUser,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Palette.BG_BLUE,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Palette.MAIN_WHITE,
        elevation: 0,
        title: const Text(
          '내 정보',
          style: TextStyle(
            color: Palette.MAIN_BLACK,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: ScreenSize.getWidth(context) * 0.04,
            right: ScreenSize.getWidth(context) * 0.04,
            top: 20,
          ),
          child: Column(
            children: [
              RoundedRectangle(
                width: ScreenSize.getWidth(context),
                height: 200,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.settings),
                            iconSize: 28,
                            onPressed: () {
                              // 내 정보 수정 페이지로 이동
                              goToAccountUpdate(accountList as AccountModel?, true);
                            },
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: ScreenSize.getWidth(context) * 0.05),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image(
                              width: 86,
                              height: 86,
                              image: AssetImage(
                                  'assets/images/profiles/profile$profileImage`1.png'),
                            ),
                            SizedBox(
                                width: ScreenSize.getWidth(context) * 0.04),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '이름',
                                  style: TextStyle(
                                    color: Palette.MAIN_BLACK,
                                    fontSize: 16,
                                    fontFamily: 'pretendard',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  '성별',
                                  style: TextStyle(
                                    color: Palette.MAIN_BLACK,
                                    fontSize: 16,
                                    fontFamily: 'pretendard',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  '생년월일',
                                  style: TextStyle(
                                    color: Palette.MAIN_BLACK,
                                    fontSize: 16,
                                    fontFamily: 'pretendard',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  '주요 증상',
                                  style: TextStyle(
                                    color: Palette.MAIN_BLACK,
                                    fontSize: 16,
                                    fontFamily: 'pretendard',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                                width: ScreenSize.getWidth(context) * 0.05),
                            const Column(
                              children: [
                                Text(
                                  ':',
                                  style: TextStyle(
                                    color: Palette.MAIN_BLACK,
                                    fontSize: 16,
                                    fontFamily: 'pretendard',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  ':',
                                  style: TextStyle(
                                    color: Palette.MAIN_BLACK,
                                    fontSize: 16,
                                    fontFamily: 'pretendard',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  ':',
                                  style: TextStyle(
                                    color: Palette.MAIN_BLACK,
                                    fontSize: 16,
                                    fontFamily: 'pretendard',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  ':',
                                  style: TextStyle(
                                    color: Palette.MAIN_BLACK,
                                    fontSize: 16,
                                    fontFamily: 'pretendard',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                                width: ScreenSize.getWidth(context) * 0.05),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userName,
                                  style: const TextStyle(
                                    color: Palette.MAIN_BLACK,
                                    fontSize: 16,
                                    fontFamily: 'pretendard',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  gender,
                                  style: const TextStyle(
                                    color: Palette.MAIN_BLACK,
                                    fontSize: 16,
                                    fontFamily: 'pretendard',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  birth,
                                  style: const TextStyle(
                                    color: Palette.MAIN_BLACK,
                                    fontSize: 16,
                                    fontFamily: 'pretendard',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  displayDisease,
                                  style: const TextStyle(
                                    color: Palette.MAIN_BLACK,
                                    fontSize: 16,
                                    fontFamily: 'pretendard',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Palette.MAIN_WHITE,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Palette.SUB_BLACK.withOpacity(0.15),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '돌봄 대상',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'pretendard',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      // AccountList(accountList: accountList.sublist(1)),
                      if (accountList.length < 3)
                        const SizedBox(
                          height: 10,
                        ),
                      if (accountList.length < 3)
                        GestureDetector(
                          onTap: () {
                            goToAccountUpdate(null, false);
                          },
                          child: const SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.add,
                                  size: 24,
                                  color: Palette.MAIN_BLACK,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    '돌봄 대상 추가하기 (최대 2명)',
                                    style: TextStyle(
                                      color: Palette.MAIN_BLACK,
                                      fontSize: 16,
                                      fontFamily: 'pretendard',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Palette.MAIN_WHITE,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Palette.SUB_BLACK.withOpacity(0.15),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: GestureDetector(
                  onTap: () {
                    // 개인정보 처리방침 페이지로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PrivacyPolicyScreen(),
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '개인정보 처리방침',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'pretendard',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              RoundedRectangle(
                width: double.infinity,
                height: 50,
                onTap: () async {
                  // 로그아웃
                  final prefs = await SharedPreferences.getInstance();
                  prefs.clear();
                  context.read<ChallengeStore>().clearChallenges();
                  context.read<LoginStore>().clearAccounts();
                  context.read<AlarmStore>().clearAlarms();
                  goToScreen(context, const MainScreen());
                },
                child: const Center(
                  child: Text(
                    '로그아웃',
                    style: TextStyle(
                      color: Palette.MAIN_BLACK,
                      fontSize: 16,
                      fontFamily: 'pretendard',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
