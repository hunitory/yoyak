import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyak/screen/SignUp/user_info.screen.dart';
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

  bool isValidate() {
    if (emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "아이디를 입력해주세요",
          style: TextStyle(
            color: Palette.MAIN_WHITE,
            fontWeight: FontWeight.w500,
            fontFamily: 'Pretendard',
          ),
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
          style: TextStyle(
            color: Palette.MAIN_WHITE,
            fontWeight: FontWeight.w500,
            fontFamily: 'Pretendard',
          ),
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
    setEmail(emailInput) {
      email = emailInput;
    }

    setPassword(passwordInput) {
      password = passwordInput;
    }

    var inputWidth = MediaQuery.of(context).size.width * 0.82;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Palette.MAIN_WHITE,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Palette.MAIN_BLACK),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      backgroundColor: Palette.MAIN_WHITE,
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _header(context),
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
                          FocusScope.of(context)
                              .requestFocus(passwordFocusNode);
                        },
                        decoration: InputDecoration(
                            hintText: "아이디",
                            hintStyle: const TextStyle(
                              color: Palette.SUB_BLACK,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Pretendard',
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none),
                            fillColor: Palette.SHADOW_GREY.withOpacity(0.3),
                            filled: true,
                            prefixIcon: const Icon(Icons.person_outline,
                                color: Palette.SUB_BLACK)),
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
                          hintStyle: const TextStyle(
                            color: Palette.SUB_BLACK,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Pretendard',
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none),
                          fillColor: Palette.SHADOW_GREY.withOpacity(0.3),
                          filled: true,
                          prefixIcon: const Icon(Icons.password_outlined,
                              color: Palette.SUB_BLACK),
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
                        onPressed: () async {
                          if (isValidate()) {
                            bool loginSuccess = await context
                                .read<LoginStore>()
                                .login(context, email, password,
                                    const MainScreen());

                            if (!loginSuccess) {
                              // 로그인 실패 알림
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text(
                                  "아이디 또는 비밀번호가 올바르지 않습니다.",
                                  style: TextStyle(
                                    color: Palette.MAIN_WHITE,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Pretendard',
                                  ),
                                ),
                                backgroundColor: Palette.MAIN_RED,
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
                          style: TextStyle(
                            fontSize: 16,
                            color: Palette.MAIN_WHITE,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Pretendard',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    // _forgotPassword(context),
                    _signup(context),
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
    return const Column(
      children: [
        Image(
            image: AssetImage('assets/images/loginopen.png'),
            width: 240,
            height: 240),
        // const SizedBox(
        //   height: 20,
        // ),
        // const Text("당신의 요 약, ")
      ],
    );
  }

  _signup(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "요약 회원이 아니신가요? ",
          style: TextStyle(
              color: Palette.MAIN_BLACK,
              fontSize: 13,
              fontWeight: FontWeight.w400,
              fontFamily: 'Pretendard'),
        ),
        GestureDetector(
          child: const Text(
            "회원가입",
            style: TextStyle(
                color: Palette.MAIN_BLUE,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                fontFamily: 'Pretendard'),
          ),
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (c, a1, a2) => const UserInfoScreen(),
                transitionsBuilder: (c, a1, a2, child) => FadeTransition(
                  opacity: a1,
                  child: child,
                ),
                transitionDuration: const Duration(milliseconds: 500),
              ),
            );
          },
        )
      ],
    );
  }
}
