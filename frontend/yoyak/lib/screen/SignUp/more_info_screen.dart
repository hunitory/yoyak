import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyak/screen/SignUp/last_info_screen.dart';
import 'package:yoyak/store/login_store.dart';
import '../../styles/colors/palette.dart';

class MoreInfoScreen extends StatefulWidget {
  const MoreInfoScreen({super.key});

  @override
  State<MoreInfoScreen> createState() => _MoreInfoScreenState();
}

class _MoreInfoScreenState extends State<MoreInfoScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var inputWidth = MediaQuery.of(context).size.width * 0.83;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "원하는 시간에",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'PUSH 알림',
                          style: TextStyle(
                            color: Palette.MAIN_BLUE,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: '을 받아보세요',
                          style: TextStyle(
                            fontSize: 22,
                            color: Palette.MAIN_BLACK,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10), // 둥근 모서리 반경 설정
                    child: Image.asset(
                      'assets/images/signup2.jpg',
                      width: 230, // 이미지의 가로 크기
                      height: 260, // 이미지의 세로 크기
                      fit: BoxFit.cover, // 이미지의 크기를 설정한 크기에 맞게 조정
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  RichText(
                    text: const TextSpan(
                      children: [
                        // const TextSpan(
                        //   text: '님 성별을 알려주세요',
                        //   style: TextStyle(
                        //     fontFamily: "Pretendard",
                        //     fontSize: 22,
                        //     color: Palette.MAIN_BLACK,
                        //     fontWeight: FontWeight.w600,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
              Center(
                child: Column(
                  children: [
                    // 남자에요
                    GestureDetector(
                      onTap: () {
                        context.read<LoginStore>().setGender('M'); // 성별 저장
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (c, a1, a2) => const LastInfoScreen(),
                            transitionsBuilder: (c, a1, a2, child) =>
                                SlideTransition(
                              position: Tween(
                                begin: const Offset(1.0, 0.0),
                                end: const Offset(0.0, 0.0),
                              )
                                  .chain(CurveTween(curve: Curves.easeInOut))
                                  .animate(a1),
                              child: child,
                            ),
                            transitionDuration:
                                const Duration(milliseconds: 400),
                          ),
                        );
                      },
                      child: Container(
                        width: inputWidth,
                        height: 60,
                        decoration: BoxDecoration(
                          // border: Border.all(color: Colors.lightBlueAccent, width: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.lightBlueAccent.withOpacity(0.08),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Center(
                            child: Text(
                              "남자에요",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // 여자에요
                    GestureDetector(
                      onTap: () {
                        context.read<LoginStore>().setGender('F'); // 성별 저장
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/', (_) => false);
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (c, a1, a2) => const LastInfoScreen(),
                            transitionsBuilder: (c, a1, a2, child) =>
                                SlideTransition(
                              position: Tween(
                                begin: const Offset(1.0, 0.0),
                                end: const Offset(0.0, 0.0),
                              )
                                  .chain(CurveTween(curve: Curves.easeInOut))
                                  .animate(a1),
                              child: child,
                            ),
                            transitionDuration:
                                const Duration(milliseconds: 400),
                          ),
                        );
                      },
                      child: Container(
                        width: inputWidth,
                        height: 60,
                        decoration: BoxDecoration(
                          // border: Border.all(color: Colors.grey.shade200, width: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.yellow.withOpacity(0.1),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Center(
                            child: Text(
                              "여자에요",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
