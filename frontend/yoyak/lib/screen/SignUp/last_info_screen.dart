import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyak/screen/Login/login_screen.dart';
import 'package:yoyak/screen/Main/main_screen.dart';
import 'package:yoyak/store/login_store.dart';
import 'package:yoyak/styles/colors/palette.dart';

class LastInfoScreen extends StatefulWidget {
  const LastInfoScreen({super.key});

  @override
  State<LastInfoScreen> createState() => _LastInfoScreenState();
}

class _LastInfoScreenState extends State<LastInfoScreen> {
  final TextEditingController yearController = TextEditingController();
  final TextEditingController monthController = TextEditingController();
  final TextEditingController dayController = TextEditingController();

  late FocusNode monthFocusNode;
  late FocusNode dayFocusNode;

  String year = '';
  String month = '';
  String day = '';

  @override
  void initState() {
    super.initState();
    monthFocusNode = FocusNode();
    dayFocusNode = FocusNode();

    // 년 입력 필드에 포커스가 왔을 때 일로 자동 이동
    yearController.addListener(() {
      if (yearController.text.length == 4) {
        FocusScope.of(context).requestFocus(monthFocusNode);
      }
    });

    // 월 입력 필드에 포커스가 왔을 때 일로 자동 이동
    monthController.addListener(() {
      if (monthController.text.length == 2) {
        FocusScope.of(context).requestFocus(dayFocusNode);
      }
    });
  }

  @override
  void dispose() {
    yearController.dispose();
    monthController.dispose();
    dayController.dispose();
    monthFocusNode.dispose();
    dayFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var inputWidth = MediaQuery.of(context).size.width * 0.25;
    return Scaffold(
      backgroundColor: Palette.MAIN_WHITE,
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
                    "약을 검색하고",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: '내 약통',
                          style: TextStyle(
                            color: Palette.MAIN_BLUE,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: '에 저장해보세요',
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
                      'assets/images/signup3.jpg',
                      width: 230, // 이미지의 가로 크기
                      height: 260, // 이미지의 세로 크기
                      fit: BoxFit.cover, // 이미지의 크기를 설정한 크기에 맞게 조정
                    ),
                  ),
                  const SizedBox(
                    height: 70,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: context.watch<LoginStore>().userName,
                          style: const TextStyle(
                            color: Palette.MAIN_BLUE, // 영양이 부분의 색상을 빨간색으로 지정
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const TextSpan(
                          text: '님의 생일을 알려주세요.',
                          style: TextStyle(
                            fontSize: 20,
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
                ],
              ),
              Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: inputWidth,
                          height: 60,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey.shade200, width: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            color: Palette.MAIN_BLACK.withOpacity(0.1),
                          ),
                          child: Center(
                            child: TextField(
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.datetime,
                              autofocus: true,
                              controller: yearController,
                              onChanged: (value) {
                                setState(() {
                                  year = value;
                                });
                              },
                              maxLength: 4,
                              decoration: const InputDecoration(
                                counterText: '',
                                hintText: "년",
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                                border: InputBorder.none,
                              ),
                              onEditingComplete: () {
                                if (yearController.text.length == 4) {
                                  // 입력값이 변경되면 다음 입력 필드로 포커스 이동
                                  FocusScope.of(context)
                                      .requestFocus(monthFocusNode);
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        // 월 입력
                        Container(
                            width: inputWidth,
                            height: 60,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey.shade200, width: 0.1),
                              borderRadius: BorderRadius.circular(20),
                              color: Palette.SUB_BLACK.withOpacity(0.1),
                            ),
                            child: Center(
                              child: TextField(
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.datetime,
                                controller: monthController,
                                focusNode: monthFocusNode,
                                onChanged: (value) {
                                  setState(() {
                                    month = value;
                                  });
                                },
                                maxLength: 2,
                                decoration: const InputDecoration(
                                  counterText: '',
                                  hintText: "월",
                                  hintStyle: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                  ),
                                  border: InputBorder.none,
                                ),
                                onEditingComplete: () {
                                  if (monthController.text.length == 4) {
                                    // 입력값이 변경되면 다음 입력 필드로 포커스 이동
                                    FocusScope.of(context)
                                        .requestFocus(dayFocusNode);
                                  }
                                },
                              ),
                            )),
                        const SizedBox(
                          width: 15,
                        ),
                        // 일 입력
                        Container(
                            width: inputWidth,
                            height: 60,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey.shade200, width: 0.1),
                              borderRadius: BorderRadius.circular(20),
                              color: Palette.SUB_BLACK.withOpacity(0.1),
                            ),
                            child: Center(
                              child: TextField(
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.datetime,
                                controller: dayController,
                                focusNode: dayFocusNode,
                                onChanged: (value) {
                                  setState(() {
                                    day = value;
                                  });
                                },
                                maxLength: 2,
                                decoration: const InputDecoration(
                                  counterText: '',
                                  hintText: "일",
                                  hintStyle: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 70,
                    ),

                    // 시작하기 버튼
                    GestureDetector(
                      onTap: () async {
                        context.read<LoginStore>().setYear(year);
                        context.read<LoginStore>().setMonth(month);
                        context.read<LoginStore>().setDay(day);

                        context.read<LoginStore>().signUp(context); // 회원 가입

                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          backgroundColor: Palette.MAIN_BLUE,
                          content: Text(
                            '회원가입이 완료되었습니다.',
                            style: TextStyle(
                              color: Palette.MAIN_WHITE,
                              fontSize: 14,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          duration: Duration(seconds: 2),
                        ));

                        Navigator.pushNamedAndRemoveUntil(
                            context, '/', (_) => false);
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (c, a1, a2) => const LoginScreen(
                              destination: MainScreen(),
                            ),
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
                                const Duration(milliseconds: 750),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(25, 15, 25, 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35),
                          color: Palette.MAIN_BLUE.withOpacity(0.9), // 원의 배경색
                        ),
                        child: const Text(
                          '가입하기',
                          style: TextStyle(
                            color: Colors.white, // 텍스트의 색상
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
