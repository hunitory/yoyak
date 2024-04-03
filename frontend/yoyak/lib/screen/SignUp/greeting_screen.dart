import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyak/screen/SignUp/more_info_screen.dart';
import 'package:yoyak/styles/colors/palette.dart';
import 'package:yoyak/styles/screenSize/screen_size.dart';
import '../../store/login_store.dart';

class GreetingScreen extends StatefulWidget {
  const GreetingScreen({super.key});

  @override
  State<GreetingScreen> createState() => _GreetingScreenState();
}

class _GreetingScreenState extends State<GreetingScreen> {
  String name = '';
  TextEditingController userNameController = TextEditingController();

  bool isValidate() {
    if (userNameController.text.isEmpty) {
      // Vibration.vibrate(duration: 300); // 진동
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "닉네임을 입력해주세요",
          style: TextStyle(color: Palette.MAIN_WHITE),
        ),
        backgroundColor: Palette.MAIN_RED,
        duration: Duration(milliseconds: 1100),
      ));
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var inputWidth = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
      backgroundColor: Palette.MAIN_WHITE,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(
                height: ScreenSize.getHeight(context) * 0.08,
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "사진 한 장이면 충분해요",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'AI 약 검색 앱, ',
                            style: TextStyle(
                              fontSize: 22,
                              color: Palette.MAIN_BLACK,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: '요약 ',
                            style: TextStyle(
                              color: Palette.MAIN_BLUE, // 영양이 부분의 색상을 빨간색으로 지정
                              fontSize: 22,
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
                        'assets/images/signup1.jpg',
                        width: 230, // 이미지의 가로 크기
                        height: 260, // 이미지의 세로 크기
                        fit: BoxFit.cover, // 이미지의 크기를 설정한 크기에 맞게 조정
                      ),
                    ),
                    const SizedBox(
                      height: 70,
                    ),
                    Container(
                        width: inputWidth,
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey.shade200, width: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          color: Palette.SHADOW_GREY.withOpacity(0.3),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 18),
                          child: Center(
                            child: TextField(
                              controller: userNameController,
                              onChanged: (value) {
                                setState(() {
                                  name = value;
                                });
                              },
                              decoration: const InputDecoration(
                                hintText: "닉네임을 입력해주세요",
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        )),
                    const SizedBox(
                      width: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            context.read<LoginStore>().userName = name;
                            if (isValidate()) {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (c, a1, a2) =>
                                      const MoreInfoScreen(),
                                  transitionsBuilder: (c, a1, a2, child) =>
                                      SlideTransition(
                                    position: Tween(
                                      begin: const Offset(1.0, 0.0),
                                      end: const Offset(0.0, 0.0),
                                    )
                                        .chain(
                                            CurveTween(curve: Curves.easeInOut))
                                        .animate(a1),
                                    child: child,
                                  ),
                                  transitionDuration:
                                      const Duration(milliseconds: 750),
                                ),
                              );
                            }
                          },
                          child: const CircleAvatar(
                            radius: 20.0,
                            backgroundColor: Palette.MAIN_BLUE, // 원의 배경색
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white, // 화살표 아이콘의 색상
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
