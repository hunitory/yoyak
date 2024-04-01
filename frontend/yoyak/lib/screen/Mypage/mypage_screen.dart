import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:yoyak/components/accountlist_view.dart';
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

class MypageScreen extends StatelessWidget {
  const MypageScreen({super.key});

  @override
  Widget build(BuildContext context) {
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


    // final List<AccountModel> accountList =
    //     context.watch<LoginStore>().accountList;

    // final AccountModel accountitem = context.read<LoginStore>().accountList[0];

    // final String userName = context.read<LoginStore>().accountList[0].nickname!;

    // final String userGender = context.read<LoginStore>().accountList[0].gender!;
    // String gender = userGender == 'F' ? '여자' : '남자';

    // final String userBirth = context.read<LoginStore>().accountList[0].birth!;

    // final String userdisease =
    //     context.read<LoginStore>().accountList[0].disease ?? '없음';

    // String displayDisease = userdisease.length > 5
    //     ? '${userdisease.substring(0, 5)}...'
    //     : userdisease;

    // final int profileImg =
    //     context.read<LoginStore>().accountList[0].profileImg!;

    final List<AccountModel> accountList =
        context.watch<LoginStore>().accountList;

    if (accountList.isNotEmpty) {
      final AccountModel accountitem = accountList[0];
      final String userName = accountitem.nickname!;
      final String userGender = accountitem.gender!;
      String gender = userGender == 'F' ? '여자' : '남자';
      final String userBirth = accountitem.birth!;
      final String userdisease = accountitem.disease ?? '없음';

      String displayDisease = userdisease.length > 5
          ? '${userdisease.substring(0, 5)}...'
          : userdisease;

      final int profileImg = accountitem.profileImg!;
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
                                goToAccountUpdate(accountitem, true);
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
                                    'assets/images/profiles/profile$profileImg.png'),
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
                                    userBirth,
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
                        AccountList(accountList: accountList.sublist(1)),
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
                  onTap: () {
                    // 로그아웃 시 할 것들
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
      // 이제 이 변수들을 사용하면 됩니다.
    } else {
      // accountList가 비어있을 때 처리할 로직
      return const Center(
        child: CircularProgressIndicator(
          backgroundColor: Palette.BG_BLUE,
        ),
      );
    }
  }
}
