import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:yoyak/apis/url.dart';
import 'package:yoyak/screen/SignUp/greeting_screen.dart';
import 'package:yoyak/store/login_store.dart';
import 'package:yoyak/styles/colors/palette.dart';
import 'package:yoyak/styles/screenSize/screen_size.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  String email = '';
  String password = '';
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  late FocusNode emailFocusNode;
  late FocusNode passwordFocusNode;

  @override
  void initState() {
    super.initState();
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
  }

  bool isValidate() {
    if (idController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "아이디를 입력해주세요",
          style: TextStyle(color: Palette.MAIN_WHITE),
        ),
        backgroundColor: Palette.MAIN_RED,
        duration: Duration(milliseconds: 1100),
      ));
      return false;
    }

    if (passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "비밀번호를 입력해주세요",
          style: TextStyle(color: Palette.MAIN_WHITE),
        ),
        backgroundColor: Palette.MAIN_RED,
        duration: Duration(milliseconds: 1100),
      ));
      return false;
    }
    return true;
  }

  Future<bool> checkUsernameDuplicate(String username) async {
    String yoyak = API.yoyakUrl;
    String url = '$yoyak/user/dupid?username=$username';

    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data['code']);
        if (data['code'] == 1003) {
          return true;
        } else if (data['code'] == 1004) {
          return false;
        } else {
          return false; // 또는 true, 에러 상황에 대한 기본값
        }
      } else {
        return true; // 또는 false, 비정상적인 상태 코드에 대한 기본값
      }
    } catch (e) {
      return true; // 또는 false, 예외 발생 시 기본값
    }
  }

  @override
  void dispose() {
    idController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var inputWidth = MediaQuery.of(context).size.width * 0.8;
    return Scaffold(
      backgroundColor: Palette.MAIN_WHITE,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: ScreenSize.getHeight(context) * 0.13,
                  ),
                  const Image(
                      image: AssetImage('assets/images/biglogo.png'),
                      width: 240,
                      height: 240),
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: '회원가입을 위해 ',
                          style: TextStyle(
                            color: Palette.MAIN_BLACK,
                            fontSize: 18,
                            fontFamily: 'pretendard',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        // const TextSpan(
                        //   text: '님이군요!',
                        //   style: TextStyle(
                        //     fontSize: 26,
                        //     color: Palette.MAIN_BLACK,
                        //     fontWeight: FontWeight.w600,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "아래의 정보를 입력해주세요",
                    style: TextStyle(
                      color: Palette.MAIN_BLACK,
                      fontSize: 18,
                      fontFamily: 'pretendard',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
              Column(
                children: [
                  // 아이디 입력란
                  Container(
                      width: inputWidth,
                      height: 60,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.grey.shade200, width: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        color: Palette.SHADOW_GREY.withOpacity(0.3),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Center(
                          child: TextField(
                            controller: idController,
                            focusNode: emailFocusNode,
                            onEditingComplete: () {
                              FocusScope.of(context)
                                  .requestFocus(passwordFocusNode);
                            },
                            onChanged: (value) {
                              setState(() {
                                email = value;
                              });
                            },
                            decoration: const InputDecoration(
                              hintText: "아이디를 입력해주세요.",
                              hintStyle: TextStyle(
                                fontSize: 16,
                                fontFamily: 'pretendard',
                                fontWeight: FontWeight.w400,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  // 이메일 입력란
                  Container(
                      width: inputWidth,
                      height: 60,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.grey.shade200, width: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        color: Palette.SHADOW_GREY.withOpacity(0.3),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Center(
                          child: TextField(
                            controller: passwordController,
                            focusNode: passwordFocusNode,
                            obscureText: true,
                            onChanged: (value) {
                              setState(() {
                                password = value;
                              });
                            },
                            decoration: const InputDecoration(
                              hintText: "비밀번호를 입력해주세요.",
                              hintStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'pretendard',
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      )),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(width: 10),
                    // 회원가입 요청
                    GestureDetector(
                      onTap: () async {
                        // await showPersonalAgreementDialog(context);
                        // if (!agreement) {
                        //   // agreement가 false인 경우 메시지를 띄움
                        //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        //     content: Text('개인정보 수집 동의가 필요합니다.'),
                        //   ));
                        //   return; // 등록 작업을 중단
                        // }

                        // agreement가 true인 경우 사용자 정보 입력 값의 유효성 검사를 수행

                        if (!isValidate()) {
                          return; // 등록 작업을 중단
                        }

                        bool isDuplicate =
                            await checkUsernameDuplicate(idController.text);

                        if (isDuplicate) {
                          // 아이디가 중복인 경우 사용자에게 알림
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text(
                              "이미 가입된 아이디입니다!",
                              style: TextStyle(color: Palette.MAIN_WHITE),
                            ),
                            backgroundColor: Palette.MAIN_RED,
                            duration: Duration(milliseconds: 1100),
                          ));
                        } else {
                          context.read<LoginStore>().userEmail =
                              idController.text;
                          context.read<LoginStore>().password =
                              passwordController.text;
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (c, a1, a2) =>
                                  const GreetingScreen(),
                              transitionsBuilder: (c, a1, a2, child) =>
                                  SlideTransition(
                                position: Tween(
                                  begin: const Offset(-1.0, 0.0),
                                  end: const Offset(0.0, 0.0),
                                )
                                    .chain(CurveTween(curve: Curves.easeInOut))
                                    .animate(a1),
                                child: child,
                              ),
                              transitionDuration:
                                  const Duration(milliseconds: 500),
                            ),
                          );
                        }

                        //회원가입 요청
                        // try {
                        //   context.read<LoginStore>().userEmail = email;
                        //   context.read<LoginStore>().password = password;

                        //   if (isValidate()) {
                        //     Navigator.of(context).pop();
                        //     Navigator.of(context).pop();
                        //     // 회원가입 성공 시 이름이랑 닉네임 페이지 사라지게
                        //     Navigator.push(
                        //       context,
                        //       PageRouteBuilder(
                        //         pageBuilder: (c, a1, a2) =>
                        //             const GreetingScreen(),
                        //         transitionsBuilder: (c, a1, a2, child) =>
                        //             SlideTransition(
                        //           position: Tween(
                        //             begin: const Offset(-1.0, 0.0),
                        //             end: const Offset(0.0, 0.0),
                        //           )
                        //               .chain(
                        //                   CurveTween(curve: Curves.easeInOut))
                        //               .animate(a1),
                        //           child: child,
                        //         ),
                        //         transitionDuration:
                        //             const Duration(milliseconds: 500),
                        //       ),
                        //     );
                        //   }
                        // } catch (e) {
                        //   // Vibration.vibrate(duration: 300); // 진동
                        //   ScaffoldMessenger.of(context)
                        //       .showSnackBar(const SnackBar(
                        //     shape: RoundedRectangleBorder(
                        //       // ShapeDecoration을 사용하여 borderRadius 적용
                        //       borderRadius: BorderRadius.only(
                        //           topLeft: Radius.circular(15),
                        //           topRight: Radius.circular(15)),
                        //     ),
                        //     content: Text(
                        //       "이미 가입된 아이디입니다!",
                        //       style: TextStyle(color: Palette.MAIN_WHITE),
                        //     ),
                        //     backgroundColor: Palette.MAIN_RED,
                        //     duration: Duration(milliseconds: 1100),
                        //   ));
                        // }
                      },
                      child: Container(
                        width: 55,
                        height: 40,
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Palette.MAIN_BLUE, // 원의 배경색
                        ),
                        child: const Center(
                          child: Text(
                            '다음',
                            style: TextStyle(
                              color: Palette.MAIN_WHITE,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'pretendard',
                            ),
                          ),
                        ),
                      ),
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
