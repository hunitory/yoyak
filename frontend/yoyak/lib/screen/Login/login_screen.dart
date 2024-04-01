import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:yoyak/styles/colors/palette.dart';
import '../../store/login_store.dart';
import '../Main/main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.destination});
  final destination;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var email = '';
  var password = '';
  var accessToken = ''; // 일단 이렇게 설정해놓음

  // 자동 로그인 여부
  bool switchValue = true;

  //이메일과 비밀번호 정보
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Focus Node
  late FocusNode emailFocusNode;
  late FocusNode passwordFocusNode;

  @override
  void initState() {
    super.initState();
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
  }

  bool isValidEmail(String email) {
    // 정규 표현식을 사용하여 이메일 형식 검사
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegex.hasMatch(email);
  }

  bool isValidate() {
    if (emailController.text.isEmpty) {
      // Vibration.vibrate(duration: 300); // 진동
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        shape: RoundedRectangleBorder(
          // ShapeDecoration을 사용하여 borderRadius 적용
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        content: Text(
          "이메일을 입력해주세요",
          style: TextStyle(color: Palette.MAIN_BLACK),
        ),
        backgroundColor: Colors.yellow,
        duration: Duration(milliseconds: 1100),
      ));
      return false;
    } else if (!isValidEmail(emailController.text)) {
      // Vibration.vibrate(duration: 300); // 진동
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        shape: RoundedRectangleBorder(
          // ShapeDecoration을 사용하여 borderRadius 적용
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        ),
        content: Text(
          "올바른 이메일 형식이 아니에요",
          style: TextStyle(color: Palette.MAIN_BLACK),
        ),
        backgroundColor: Colors.yellow,
        duration: Duration(milliseconds: 1100),
      ));
      return false;
    }

    if (passwordController.text.isEmpty) {
      // Vibration.vibrate(duration: 300); // 진동
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        shape: RoundedRectangleBorder(
          // ShapeDecoration을 사용하여 borderRadius 적용
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        ),
        content: Text(
          "비밀번호를 입력해주세요",
          style: TextStyle(color: Palette.MAIN_BLACK),
        ),
        backgroundColor: Colors.yellow,
        duration: Duration(milliseconds: 1100),
      ));
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    setEmail(emailInput) {
      email = emailInput;
    }

    setPassword(passwordInput) {
      password = passwordInput;
    }
    var inputWidth = MediaQuery.of(context).size.width * 0.82;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF), // 0xFFF5F6F9
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _header(context),
                const SizedBox(
                  height: 30,
                ),
            Column(
              children: [
                // SizedBox(height: 10),
                SizedBox(
                  width: inputWidth,
                  height: 55,
                  child: TextField(
                    controller: emailController,
                    focusNode: emailFocusNode,
                    onChanged: (value) {
                      setEmail(value); // 이 부분에서 이름을 state에 저장합니다.
                    },
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(passwordFocusNode);
                    },
                    decoration: InputDecoration(
                        hintText: "이메일",
                        hintStyle: TextStyle(
                            color: Colors.grey.shade400, fontWeight: FontWeight.w400),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none),
                        fillColor: Palette.SHADOW_GREY.withOpacity(0.3),
                        filled: true,
                        prefixIcon:
                        Icon(Icons.email_outlined, color: Colors.grey.shade500)),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: inputWidth,
                  height: 55,
                  child: TextField(
                    controller: passwordController,
                    focusNode: passwordFocusNode,
                    onChanged: (value) {
                      setPassword(value);
                    },
                    decoration: InputDecoration(
                      hintText: "비밀번호",
                      hintStyle: TextStyle(
                          color: Colors.grey.shade400, fontWeight: FontWeight.w400),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none),
                      fillColor: Palette.SHADOW_GREY.withOpacity(0.3),
                      filled: true,
                      prefixIcon:
                      Icon(Icons.password_outlined, color: Colors.grey.shade500),
                    ),
                    obscureText: true,
                  ),
                ),
                const SizedBox(height: 5),
                const SizedBox(height: 30),
                //로그인 버튼
                SizedBox(
                  width: inputWidth,
                  child: ElevatedButton(
                    onPressed: () {
                      if (isValidate()) {
                        try {
                          context.read<LoginStore>().login(
                              context, email, password, const MainScreen());
                          print('로그인 버튼 눌림');
                          // 로그인 확인
                          // if (loginCheck == '-1') {
                          //   print('로그인 실패');
                          //   showDialog(
                          //     context: context,
                          //     builder: (BuildContext context) {
                          //       return AlertDialog(
                          //         title: const Text('알림'),
                          //         content: const Text('아이디 또는 비밀번호가 올바르지 않습니다.'),
                          //         actions: [
                          //           TextButton(
                          //             child: const Text('닫기'),
                          //             onPressed: () {
                          //               Navigator.of(context).pop();
                          //             },
                          //           ),
                          //         ],
                          //       );
                          //     },
                          //   );
                          // }
                        } catch (error) {
                          print(error);
                          // Vibration.vibrate(duration: 300); // 진동
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            shape: RoundedRectangleBorder(
                              // ShapeDecoration을 사용하여 borderRadius 적용
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15)),
                            ),
                            content: Text(
                              "로그인 되었습니다",
                              style: TextStyle(color: Palette.MAIN_BLACK),
                            ),
                            backgroundColor: Colors.yellow,
                            duration: Duration(milliseconds: 1100),
                          ));
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Palette.MAIN_BLUE,
                    ),
                    child: const Text(
                      "로그인",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                // const SizedBox(height: 10,),
                // _forgotPassword(context),
              ],
            ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _header(context) {
    return Column(
      children: [
        Lottie.asset('assets/lotties/cat.json',
            fit: BoxFit.contain, width: 200, height: 200),
      ],
    );
  }
// _forgotPassword(context) {
//   return TextButton(
//     onPressed: () {
//       Navigator.push(context,
//           MaterialPageRoute(builder: (context) => FindPasswordScreen()));
//     },
//     child: Text(
//       "비밀번호 생각 안나시나요",
//       style: TextStyle(color: BASIC_BLACK.withOpacity(0.7), decoration: TextDecoration.underline, fontSize: 13),
//     ),
//   );
// }
}
