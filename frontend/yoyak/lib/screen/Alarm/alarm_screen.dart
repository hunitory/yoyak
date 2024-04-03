import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:yoyak/apis/url.dart';
import 'package:yoyak/components/bottom_modal.dart';
import 'package:yoyak/components/dialog.dart';
import 'package:yoyak/components/rounded_rectangle.dart';
import 'package:yoyak/hooks/format_time.dart';
import 'package:yoyak/models/alarm/alarm_models.dart';
import 'package:yoyak/models/user/account_models.dart';
import 'package:yoyak/screen/Alarm/alarm_create.dart';
import 'package:yoyak/screen/Login/login_screen.dart';
import 'package:yoyak/screen/Main/main_screen.dart';
import 'package:yoyak/store/alarm_store.dart';
import 'package:yoyak/store/login_store.dart';
import 'package:yoyak/styles/colors/palette.dart';
import 'package:yoyak/styles/screenSize/screen_size.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  final CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();
  MediaQueryData? queryData;
  int? selectedAccountSeq;

  @override
  Widget build(BuildContext context) {
    double paddingValue = ScreenSize.getWidth(context) * 0.03;

    DateTime now = DateTime.now();

    var alarmList = context.watch<AlarmStore>().alarms;
    var accountList = context.watch<LoginStore>().accountList;

    var isLogin = accountList.isEmpty;

    // 선택된 날짜에 해당하는 alarmList를 필터링
    var filteredAlarmList = _selectedDay != null
        ? alarmList.where((alarm) {
            return alarm.time != null && isSameDay(_selectedDay, alarm.time);
          }).toList()
        : alarmList;

    List<AlarmModel> finalFilteredAlarmList;
    if (selectedAccountSeq == null) {
      // '모두'가 선택되었을 때
      finalFilteredAlarmList = filteredAlarmList;
    } else {
      // 특정 계정이 선택되었을 때, 선택된 seq와 일치하는 alarmList를 필터링합니다.
      finalFilteredAlarmList = filteredAlarmList.where((alarm) {
        return alarm.accountSeq == selectedAccountSeq;
      }).toList();
    }
    // 드롭다운 메뉴 아이템 목록 생성: '모두' + 모든 계정의 닉네임
    // 이전에는 닉네임만 추가했었는데 이제는 seq와 닉네임을 모두 추가합니다.
    List<AccountModel> dropdownItems = [
      AccountModel(seq: null, nickname: '모두')
    ];
    dropdownItems.addAll(accountList);

    return Scaffold(
      // 배경색
      backgroundColor: Palette.BG_BLUE,
      appBar: AppBar(
        // AppBar 배경색
        backgroundColor: Palette.BG_BLUE,
        // AppBar의 제목
        title: const Text(
          '알림 관리',
          style: TextStyle(
            color: Palette.MAIN_BLACK,
            fontSize: 16,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w500,
          ),
        ),
        toolbarHeight: 55,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: paddingValue),
        child: Column(
          children: [
            SizedBox(height: ScreenSize.getHeight(context) * 0.02),
            TableCalendar(
              locale: 'ko_KR',
              headerVisible: false,
              calendarFormat: _calendarFormat,
              firstDay: DateTime.utc(2024, 01, 01),
              // 오늘에서 14일 후 토요일까지 보여줌
              lastDay: now
                  .add(const Duration(days: 14))
                  .subtract(Duration(
                      days: now.add(const Duration(days: 14)).weekday % 7))
                  .add(const Duration(days: 6)),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              calendarStyle: const CalendarStyle(
                // 오늘 날짜 스타일
                todayDecoration: BoxDecoration(
                  color: Palette.SUB_BLUE,
                  shape: BoxShape.circle,
                ),
                todayTextStyle: TextStyle(
                  color: Palette.MAIN_BLACK,
                  fontSize: 15,
                ),

                // 선택된 날짜의 테두리 스타일
                selectedDecoration: BoxDecoration(
                  color: Palette.MAIN_BLUE,
                  shape: BoxShape.circle,
                ),
                selectedTextStyle: TextStyle(
                  color: Palette.MAIN_WHITE,
                  fontSize: 15,
                ),
              ),
              // 달력의 요일 스타일
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                  color: Palette.MAIN_BLACK,
                  fontSize: 14,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                ),
                weekendStyle: TextStyle(
                  color: Palette.MAIN_BLACK,
                  fontSize: 14,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (accountList.length > 1)
                  DropdownButton<int?>(
                    elevation: 6,
                    style: const TextStyle(
                      color: Palette.MAIN_BLACK,
                      fontSize: 15,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                    ),
                    underline: Container(
                      color: Palette.SUB_WHITE,
                      height: 1,
                    ),
                    iconSize: 30,
                    iconEnabledColor: Palette.MAIN_BLACK,
                    borderRadius: BorderRadius.circular(10),
                    value: selectedAccountSeq,
                    onChanged: (int? newValue) {
                      setState(() {
                        selectedAccountSeq = newValue;
                      });
                    },
                    items: dropdownItems
                        .map<DropdownMenuItem<int?>>((AccountModel account) {
                      return DropdownMenuItem<int?>(
                        value: account.seq,
                        child: Text(
                          account.nickname ?? '없음',
                          style: const TextStyle(
                            fontSize: 15,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
            if (accountList.isNotEmpty)
              SizedBox(height: ScreenSize.getHeight(context) * 0.01),
            if (accountList.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ...finalFilteredAlarmList.map<Widget>((alarm) {
                        int notiTimeSeq = alarm.notiTimeSeq ?? 0;
                        String name = alarm.name ?? '';
                        DateTime time = alarm.time ?? DateTime.now();
                        String taken = alarm.taken ?? '';
                        DateTime? takenTime = alarm.takenTime;
                        int accountSeq = alarm.accountSeq ?? 0;
                        int notiSeq = alarm.notiSeq ?? 0;

                        return AlarmItem(
                          notiTimeSeq: notiTimeSeq,
                          name: name,
                          time: time,
                          taken: taken,
                          takenTime: takenTime,
                          accountSeq: accountSeq,
                          notiSeq: notiSeq,
                        );
                      }),
                      SizedBox(
                        // 없으면 카드 좌우 그림자가 짤림
                        width: ScreenSize.getWidth(context) * 0.9,
                        height: ScreenSize.getHeight(context) * 0.09,
                      ),
                    ],
                  ),
                ),
              ),
            if (accountList.isEmpty)
              Column(
                children: [
                  SizedBox(height: ScreenSize.getHeight(context) * 0.3),
                  const Text(
                    '현재 등록된 알림이 없습니다.',
                    style: TextStyle(
                      color: Palette.MAIN_BLACK,
                      fontSize: 15,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
          ],
        ),
      ),
      floatingActionButton: AlarmCreateButton(isLogin: isLogin),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

// 알림 리스트 아이템
class AlarmItem extends StatelessWidget {
  final int notiTimeSeq;
  final String name;
  final DateTime time;
  final String taken;
  final DateTime? takenTime;
  final int accountSeq;
  final int notiSeq;

  const AlarmItem({
    super.key,
    required this.notiTimeSeq,
    required this.name,
    required this.time,
    required this.taken,
    required this.takenTime,
    required this.accountSeq,
    required this.notiSeq,
  });

  @override
  Widget build(BuildContext context) {
    void goToAlarmUpdate(int? notiSeq) {
      Navigator.push(
        context,
        MaterialPageRoute(
          // 수정 할 것
          builder: (context) => AlarmCreate(notiSeq: notiSeq),
        ),
      );
      print('왔니 $notiSeq');
    }

    return Container(
      margin: EdgeInsets.only(
        top: ScreenSize.getHeight(context) * 0.03,
      ),
      child: RoundedRectangle(
        onTap: () {
          // 수정페이지로 이동하게 해야함 ** 서버에서 받아온 notiSeq 데이터를 넘겨줘야함
          goToAlarmUpdate(notiSeq);
        },
        width: ScreenSize.getWidth(context) * 0.9,
        height: ScreenSize.getHeight(context) * 0.12,
        child: Padding(
          padding: EdgeInsets.only(
            left: ScreenSize.getWidth(context) * 0.09,
            right: ScreenSize.getWidth(context) * 0.03,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              taken == 'TAKEN'
                  ? Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                            color: Palette.MAIN_BLUE,
                            fontSize: 15,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w700),
                      ),
                    )
                  : taken == 'NOT_TAKEN'
                      ? Expanded(
                          child: Text(
                            name,
                            style: const TextStyle(
                                color: Palette.SUB_BLACK,
                                fontSize: 15,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w700),
                          ),
                        )
                      : Expanded(
                          child: Text(
                            name,
                            style: const TextStyle(
                                color: Palette.MAIN_BLACK,
                                fontSize: 15,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w700),
                          ),
                        ),
              taken == 'TAKEN'
                  ? Flexible(
                      flex: 2,
                      child: Text(
                        formatTime(time),
                        style: const TextStyle(
                            color: Palette.MAIN_BLUE,
                            fontSize: 15,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w700),
                      ),
                    )
                  : taken == 'YET_TAKEN'
                      ? Flexible(
                          flex: 2,
                          child: Text(
                            formatTime(time),
                            style: const TextStyle(
                                color: Palette.MAIN_BLACK,
                                fontSize: 15,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w700),
                          ),
                        )
                      : Flexible(
                          flex: 2,
                          child: Text(
                            formatTime(time),
                            style: const TextStyle(
                                color: Palette.SUB_BLACK,
                                fontSize: 15,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w700),
                          ),
                        ),
              CheckEatPillButton(
                name: name,
                time: time,
                taken: taken,
                takenTime: takenTime,
                notiSeq: notiSeq,
                notiTimeSeq: notiTimeSeq,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 알림 생성 버튼
class AlarmCreateButton extends StatelessWidget {
  final bool isLogin;

  const AlarmCreateButton({
    super.key,
    required this.isLogin,
  });

  @override
  Widget build(BuildContext context) {
    void goToAlarmCreate(int? notiSeq, bool isLogin) {
      if (isLogin) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const DialogUI(
              destination: LoginScreen(
                destination: MainScreen(),
              ),
            );
          },
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AlarmCreate(notiSeq: notiSeq),
          ),
        );
      }
    }

    return SizedBox(
      width: 80,
      height: 43,
      child: FloatingActionButton(
        backgroundColor: Palette.MAIN_BLUE,
        elevation: 3,
        onPressed: () {
          goToAlarmCreate(null, isLogin);
        },
        child: const Padding(
          padding: EdgeInsets.only(right: 4.6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: Palette.MAIN_WHITE, size: 23),
              Text(
                '알림',
                style: TextStyle(
                  color: Palette.MAIN_WHITE,
                  fontSize: 17,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 복용 체크 버튼
class CheckEatPillButton extends StatefulWidget {
  final String name;
  final DateTime time;
  final String taken;
  final int notiSeq;
  final DateTime? takenTime;
  final int notiTimeSeq;

  const CheckEatPillButton({
    super.key,
    required this.name,
    required this.time,
    required this.taken,
    required this.notiSeq,
    required this.notiTimeSeq,
    this.takenTime,
  });

  @override
  CheckEatPillButtonState createState() => CheckEatPillButtonState();
}

class CheckEatPillButtonState extends State<CheckEatPillButton> {
  // 약 먹었어요
  Future<void> takenPill(int notiTimeSeq, DateTime takenTime) async {
    final prefs = await SharedPreferences.getInstance();
    String yoyakURL = API.yoyakUrl; // 서버 URL// 액세스 토큰
    String url = '$yoyakURL/noti/time/taken';

    String formattedTakenTime = takenTime.toIso8601String();

    Map<String, dynamic> requestData = {
      "notiTimeSeq": notiTimeSeq,
      "takenTime": formattedTakenTime,
    };

    try {
      String? accessToken = prefs.getString('accessToken');
      var response = await http.put(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode(requestData),
      );

      if (response.statusCode == 200) {
        print('Medication taken successfully');
        // 데이터 갱신
        if (mounted) {
          context.read<AlarmStore>().getAlarmDatas(context);
        }
      } else {
        print(accessToken);
        print('Failed to take medication, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error taking medication: $e');
    }
  }

  // 건너 뛰었어요
  Future<void> skipPill(int notiTimeSeq) async {
    String yoyakURL = API.yoyakUrl; // 서버 URL
    final prefs = await SharedPreferences.getInstance(); // 액세스 토큰
    String url = '$yoyakURL/noti/time/not/$notiTimeSeq';

    try {
      String? accessToken = prefs.getString('accessToken');
      var response = await http.put(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        print('Medication skipped successfully');
        // 데이터 갱신
        if (mounted) {
          context.read<AlarmStore>().getAlarmDatas(context);
        }
      } else {
        print('Failed to skip medication, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error skipping medication: $e');
    }
  }

  // 건너 뛰기 취소
  Future<void> cancelSkipPill(int notiTimeSeq) async {
    String yoyakURL = API.yoyakUrl; // 서버 URL
    final prefs = await SharedPreferences.getInstance(); // 액세스 토큰
    String url = '$yoyakURL/noti/time/yet/$notiTimeSeq';

    try {
      String? accessToken = prefs.getString('accessToken');
      var response = await http.put(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        print('Medication skip canceled successfully');
        // 데이터 갱신
        if (mounted) {
          context.read<AlarmStore>().getAlarmDatas(context);
        }
      } else {
        print(
            'Failed to cancel medication skip, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error canceling medication skip: $e');
    }
  }

  // 복용 시간 수정
  Future<void> updateTimePill(int notiTimeSeq, DateTime takenTime) async {
    String yoyakURL = API.yoyakUrl; // 서버 URL
    final prefs = await SharedPreferences.getInstance(); // 액세스 토큰
    String url = '$yoyakURL/noti/time/taken';

    String formattedTakenTime = takenTime.toIso8601String();

    Map<String, dynamic> requestData = {
      "notiTimeSeq": notiTimeSeq,
      "takenTime": formattedTakenTime,
    };

    try {
      String? accessToken = prefs.getString('accessToken');
      var response = await http.put(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode(requestData),
      );

      if (response.statusCode == 200) {
        print('Medication taken successfully');
        // 데이터 갱신
        if (mounted) {
          context.read<AlarmStore>().getAlarmDatas(context);
        }
      } else {
        print('Failed to take medication, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error taking medication: $e');
    }
  }

  // 먹지 않았어요
  Future<void> notTakenPill(int notiTimeSeq) async {
    String yoyakURL = API.yoyakUrl; // 서버 URL
    final prefs = await SharedPreferences.getInstance(); // 액세스 토큰
    String url = '$yoyakURL/noti/time/yet/$notiTimeSeq';

    try {
      String? accessToken = prefs.getString('accessToken');
      var response = await http.put(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        print('Medication not taken successfully');
        // 데이터 갱신
        if (mounted) {
          context.read<AlarmStore>().getAlarmDatas(context);
        }
      } else {
        print(
            'Failed to not take medication, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error not taking medication: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    String name = widget.name;
    DateTime time = widget.time;
    String taken = widget.taken;
    int notiSeq = widget.notiSeq;
    DateTime? takenTime = widget.takenTime;
    int notiTimeSeq = widget.notiTimeSeq;

    return Center(
      child: RoundedRectangle(
        width: 74,
        height: 70,
        color: taken == 'TAKEN' ? Palette.SUB_BLUE : Palette.SUB_WHITE,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 여백
            const SizedBox(height: 5),

            // 버튼 아이콘
            taken == 'TAKEN'
                ? const Icon(
                    Icons.check,
                    color: Palette.MAIN_BLUE,
                    size: 40,
                  )
                : taken == 'YET_TAKEN'
                    ? Image.asset(
                        'assets/images/medicine.png',
                        width: 30,
                        height: 30,
                      )
                    : const Icon(
                        Icons.close,
                        color: Palette.SUB_BLACK,
                        size: 40,
                      ),

            // 버튼 텍스트
            taken == 'TAKEN'
                ? Text(
                    formatTime(takenTime as DateTime),
                    style: const TextStyle(
                        color: Palette.MAIN_BLUE,
                        fontSize: 11,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w700),
                  )
                : taken == 'YET_TAKEN'
                    ? const SizedBox(
                        height: 3,
                      )
                    : const Text(
                        '건너 뛰었어요',
                        style: TextStyle(
                          fontSize: 10,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w700,
                          color: Palette.SUB_BLACK,
                        ),
                      ),
          ],
        ),
        onTap: () {
          checkeatpillmodal(
            context: context,
            name: name,
            time: time,
            notiSeq: notiSeq,
            takenTime: takenTime,
            notiTimeSeq: notiTimeSeq,
          );
        },
      ),
    );
  }

  Future<void> checkeatpillmodal({
    required BuildContext context,
    required String name,
    required DateTime time,
    required int notiSeq,
    required DateTime? takenTime,
    required int notiTimeSeq,
  }) {
    Widget modalContent;
    switch (widget.taken) {
      // 약 복용을 했을 때
      case 'TAKEN':
        modalContent = Padding(
          padding: const EdgeInsets.only(
            top: 20,
            left: 30,
            right: 30,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  // 알람 이름
                  Text(
                    name,
                    style: const TextStyle(
                      color: Palette.MAIN_BLUE,
                      fontSize: 15,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(
                    width: 20,
                  ),

                  // 복용 시간
                  Text(
                    formatTime(time),
                    style: const TextStyle(
                      color: Palette.MAIN_BLUE,
                      fontSize: 15,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 먹지 않았어요 버튼
                  RoundedRectangle(
                    width: 110,
                    height: 100,
                    // 나중에 수정 api 연결
                    onTap: () => {
                      notTakenPill(notiTimeSeq),
                      Navigator.pop(context),
                    },
                    color: Palette.SUB_WHITE,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.close, color: Palette.SUB_BLACK, size: 55),
                        Text(
                          '먹지 않았어요',
                          style: TextStyle(
                            color: Palette.SUB_BLACK,
                            fontSize: 15,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    width: ScreenSize.getWidth(context) * 0.1,
                  ),

                  // 시간 수정 버튼
                  RoundedRectangle(
                    width: 110,
                    height: 100,
                    color: Palette.SUB_BLUE,
                    onTap: () {
                      timeSelectorModal(
                        context: context,
                        notiSeq: notiSeq,
                        takenTime: takenTime as DateTime,
                        notiTimeSeq: notiTimeSeq,
                      );
                    },
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage('assets/images/retime.png'),
                          width: 50,
                          height: 57,
                        ),
                        Text(
                          '시간 수정',
                          style: TextStyle(
                            color: Palette.MAIN_BLUE,
                            fontSize: 15,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
        break;

      // 약 복용을 하지 않았을 때
      case 'NOT_TAKEN':
        modalContent = Padding(
          padding: const EdgeInsets.only(
            top: 20,
            left: 30,
            right: 30,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  // 알람 이름
                  Text(
                    name,
                    style: const TextStyle(
                      color: Palette.MAIN_BLACK,
                      fontSize: 15,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(
                    width: 20,
                  ),

                  // 복용 시간
                  Text(
                    formatTime(time),
                    style: const TextStyle(
                      color: Palette.MAIN_BLACK,
                      fontSize: 15,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 먹지 않았어요 버튼
                  RoundedRectangle(
                    width: 110,
                    height: 100,
                    // 나중에 수정 api 연결
                    onTap: () => {
                      // 건너뛰기 취소 로직
                      cancelSkipPill(notiTimeSeq),
                      Navigator.pop(context),
                    },
                    color: Palette.SUB_WHITE,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.close, color: Palette.SUB_BLACK, size: 55),
                        Text(
                          '건너뛰기 취소',
                          style: TextStyle(
                            color: Palette.SUB_BLACK,
                            fontSize: 15,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
        break;

      // 아직 복용하지 않은 경우
      case 'YET_TAKEN':
        modalContent = Padding(
          padding: const EdgeInsets.only(
            top: 20,
            left: 30,
            right: 30,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  // 알람 이름
                  Text(
                    name,
                    style: const TextStyle(
                      color: Palette.MAIN_BLACK,
                      fontSize: 15,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(
                    width: 20,
                  ),

                  // 복용 시간
                  Text(
                    formatTime(time),
                    style: const TextStyle(
                      color: Palette.MAIN_BLACK,
                      fontSize: 15,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 건너 뛰었어요 버튼
                  RoundedRectangle(
                    width: 110,
                    height: 100,
                    color: Palette.SUB_WHITE,
                    onTap: () => {
                      skipPill(notiTimeSeq),
                      Navigator.pop(context),
                    },
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.close, color: Palette.SUB_BLACK, size: 55),
                        Text(
                          '건너 뛰었어요',
                          style: TextStyle(
                            color: Palette.SUB_BLACK,
                            fontSize: 15,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    width: ScreenSize.getWidth(context) * 0.1,
                  ),

                  // 먹었어요 버튼
                  RoundedRectangle(
                    width: 110,
                    height: 100,
                    color: Palette.SUB_BLUE,
                    onTap: () => {
                      takenPill(notiTimeSeq, DateTime.now()),
                      Navigator.pop(context),
                    },
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check, color: Palette.MAIN_BLUE, size: 55),
                        Text(
                          '먹었어요',
                          style: TextStyle(
                            color: Palette.MAIN_BLUE,
                            fontSize: 15,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
        break;

      // 기본 값
      default:
        modalContent = const Text('정보가 없습니다.');
        break;
    }

    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return BottomModal(child: modalContent);
      },
    );
  }

  Future<void> timeSelectorModal({
    required BuildContext context,
    required int notiSeq,
    required DateTime takenTime,
    required int notiTimeSeq,
  }) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        // 초기 시간 설정
        int selectedHour =
            widget.takenTime!.hour % 12 == 0 ? 12 : widget.takenTime!.hour % 12;
        int selectedMinute = widget.takenTime!.minute;
        int selectedPeriodIndex = widget.takenTime!.hour < 12 ? 0 : 1;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return RoundedRectangle(
              height: 380,
              width: ScreenSize.getWidth(context),
              color: Palette.MAIN_WHITE,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 30,
                      right: 30,
                    ),
                    child: Column(
                      children: <Widget>[
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '복용 시간',
                              style: TextStyle(
                                color: Palette.MAIN_BLUE,
                                fontSize: 20,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Palette.SUB_BLUE.withOpacity(0.5),
                                  ),
                                  width: ScreenSize.getWidth(context) * 0.75,
                                  height: 40,
                                ),
                                Row(
                                  children: [
                                    // 오전/오후 선택기
                                    Column(
                                      children: [
                                        const SizedBox(
                                          height: 40,
                                        ),
                                        NumberPicker(
                                          infiniteLoop: true,
                                          value: selectedPeriodIndex,
                                          minValue: 0,
                                          maxValue: 1,
                                          itemCount: 2,
                                          itemHeight: 40,
                                          textMapper: (String value) {
                                            return value == '0' ? '오전' : '오후';
                                          },
                                          textStyle: const TextStyle(
                                            textBaseline:
                                                TextBaseline.alphabetic,
                                            color: Palette.MAIN_BLACK,
                                            fontSize: 18,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w600,
                                          ),
                                          selectedTextStyle: const TextStyle(
                                            textBaseline:
                                                TextBaseline.alphabetic,
                                            color: Palette.MAIN_BLACK,
                                            fontSize: 20,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w600,
                                          ),
                                          onChanged: (newValue) {
                                            setState(() {
                                              selectedPeriodIndex = newValue;
                                            });
                                          },
                                        ),
                                      ],
                                    ),

                                    // 시간 선택기
                                    NumberPicker(
                                      infiniteLoop: true,
                                      value: selectedHour,
                                      minValue: 1,
                                      maxValue: 12,
                                      itemCount: 7,
                                      itemHeight: 40,
                                      textStyle: const TextStyle(
                                        textBaseline: TextBaseline.alphabetic,
                                        color: Palette.SUB_BLACK,
                                        fontSize: 16,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w600,
                                      ),
                                      selectedTextStyle: const TextStyle(
                                        textBaseline: TextBaseline.alphabetic,
                                        color: Palette.MAIN_BLACK,
                                        fontSize: 20,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w600,
                                      ),
                                      onChanged: (newValue) {
                                        setState(() {
                                          selectedHour = newValue;
                                        });
                                      },
                                    ),

                                    // 분 선택기
                                    NumberPicker(
                                      infiniteLoop: true,
                                      value: selectedMinute,
                                      minValue: 0,
                                      maxValue: 59,
                                      itemCount: 7,
                                      itemHeight: 40,
                                      textMapper: (String value) {
                                        return int.parse(value) < 10
                                            ? '0$value'
                                            : value;
                                      },
                                      textStyle: const TextStyle(
                                        color: Palette.SUB_BLACK,
                                        fontSize: 16,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w600,
                                      ),
                                      selectedTextStyle: const TextStyle(
                                        color: Palette.MAIN_BLACK,
                                        fontSize: 20,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w600,
                                      ),
                                      onChanged: (newValue) {
                                        setState(() {
                                          selectedMinute = newValue;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: ScreenSize.getWidth(context),
                      color: Palette.MAIN_BLUE,
                      child: TextButton(
                        onPressed: () {
                          // 시간 수정 api 연결
                          updateTimePill(
                            notiTimeSeq,
                            DateTime(
                              takenTime.year,
                              takenTime.month,
                              takenTime.day,
                              selectedPeriodIndex == 0
                                  ? selectedHour
                                  : selectedHour + 12,
                              selectedMinute,
                            ),
                          );
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Text(
                          selectedPeriodIndex == 0
                              ? '오전 $selectedHour : ${selectedMinute.toString().padLeft(2, '0')}'
                              : '오후 $selectedHour : ${selectedMinute.toString().padLeft(2, '0')}',
                          style: const TextStyle(
                            color: Palette.MAIN_WHITE,
                            fontSize: 20,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
