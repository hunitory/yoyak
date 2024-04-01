import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyak/store/challenge_store.dart';
import 'package:yoyak/store/login_store.dart';
import 'package:yoyak/styles/colors/palette.dart';
import 'package:yoyak/styles/screenSize/screen_size.dart';

class RegistChallengeScreen extends StatefulWidget {
  const RegistChallengeScreen({super.key});

  @override
  State<RegistChallengeScreen> createState() => _GreetingScreenState();
}

class _GreetingScreenState extends State<RegistChallengeScreen> {
  String name = '';
  late DateTime _alarmStartDate = DateTime.now();
  late DateTime _alarmEndDate = DateTime.now();
  DateTimeRange dateTimeRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );
  TextEditingController challengeNameController = TextEditingController();

  // bool isValidate() {
  //   if (userNameController.text.isEmpty) {
  //     Vibration.vibrate(duration: 300); // 진동
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(shape: RoundedRectangleBorder( // ShapeDecoration을 사용하여 borderRadius 적용
  //       borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
  //     ), content: Text("이름을 입력해주세요", style: TextStyle(color: BASIC_BLACK),), backgroundColor: Colors.yellow, duration: Duration(milliseconds: 1100),));
  //     return false;
  //   }
  //   return true;
  // }

  @override
  Widget build(BuildContext context) {
    var inputWidth = MediaQuery.of(context).size.width * 0.9;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back_ios, size: 25,),
        title: const Text("챌린지 시작하기", style: TextStyle(
          color: Palette.MAIN_BLACK,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w500,
          fontSize: 20,
        ),),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                width: ScreenSize.getWidth(context) * 0.9,
                child: Image.asset("assets/images/flag.png",
                    width: 75, height: 75),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    const Text("챌린지 이름", style: TextStyle(
                      color: Palette.MAIN_BLUE,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),),
                    const SizedBox(height: 10,),
                    Container(
                        width: inputWidth,
                        height: 55,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Palette.SHADOW_GREY, width: 0.8),
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Center(
                            child: TextField(
                              controller: challengeNameController,
                              onChanged: (value) {
                                setState(() {
                                  name = value;
                                });
                              },
                              decoration: const InputDecoration(
                                hintText: "챌린지 이름을 입력해주세요",
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
                      height: 30,
                    ),
                    const Text("챌린지 기간", style: TextStyle(
                      color: Palette.MAIN_BLUE,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),),
                    const SizedBox(height: 10,),
                    Container(
                      width: inputWidth,
                      height: 55,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Palette.SHADOW_GREY, width: 0.8),
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          await selectDateRange();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${_alarmStartDate.year}.${_alarmStartDate.month}.${_alarmStartDate.day}     ~     ${_alarmEndDate.year}.${_alarmEndDate.month}.${_alarmEndDate.day}',
                              style: const TextStyle(
                                color: Palette.MAIN_BLACK,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: Size(ScreenSize.getWidth(context), 48),
          backgroundColor: Palette.MAIN_BLUE,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        ),
        onPressed: () {
          // 챌린지 등록
          context.read<ChallengeStore>().registChallenge(name, _alarmStartDate, _alarmEndDate, context);
        },
        child: const Center(
          child: Text(
            '완료',
            style: TextStyle(
              color: Palette.MAIN_WHITE,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }

  Future selectDateRange() async {
    DateTimeRange? newRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
      initialDateRange: dateTimeRange,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Palette.MAIN_BLUE, // 선택된 날짜 및 확인 버튼 색상
              secondary: Palette.SUB_BLUE,
            ),
            textTheme: const TextTheme(
              // 달력 상단 텍스트 스타일
              titleLarge: TextStyle(
                color: Palette.MAIN_BLACK,
                fontSize: 23,
                fontWeight: FontWeight.w500,
                fontFamily: 'Pretendard',
              ),
              // 달력 상단 작은 텍스트 스타일
              titleSmall: TextStyle(
                color: Palette.MAIN_BLACK,
                fontSize: 18,
                fontWeight: FontWeight.w500,
                fontFamily: 'Pretendard',
              ),

              // 기간 입력 텍스트 스타일
              bodyLarge: TextStyle(
                color: Palette.MAIN_BLACK,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'Pretendard',
              ),

              // 달력 텍스트 스타일
              bodyMedium: TextStyle(
                color: Palette.MAIN_BLACK,
                fontSize: 15,
                fontWeight: FontWeight.w500,
                fontFamily: 'Pretendard',
              ),
              // 버튼 텍스트 스타일
              labelLarge: TextStyle(
                color: Palette.MAIN_BLACK,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'Pretendard',
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (newRange != null) {
      setState(() {
        dateTimeRange = newRange;
        _alarmStartDate = newRange.start; // 시작 날짜 업데이트
        _alarmEndDate = newRange.end; // 종료 날짜 업데이트
      });
    }
  }

}
