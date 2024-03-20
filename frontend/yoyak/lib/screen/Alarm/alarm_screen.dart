import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:yoyak/components/RoundedRectangle.dart';
import 'package:yoyak/screen/Alarm/alarm_create.dart';
import 'package:yoyak/screen/Home/home_screen.dart';
import 'package:yoyak/styles/colors/palette.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  final CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  MediaQueryData? queryData;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double paddingValue = screenWidth * 0.05; // 화면 너비의 10%

    return Scaffold(
      backgroundColor: Palette.BG_BLUE,
      appBar: AppBar(
        title: const Center(
          child: Text('알림 관리',
              style: TextStyle(
                color: Palette.MAIN_BLACK,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
                fontSize: 15,
              )),
        ),
        toolbarHeight: 55,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: paddingValue),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            TableCalendar(
              locale: 'ko_KR',
              headerVisible: false,
              calendarFormat: _calendarFormat,
              firstDay: DateTime.utc(2024, 03, 10),
              lastDay: DateTime.utc(2024, 04, 03),
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
                // 기본 달력 스타일
                // defaultTextStyle: const TextStyle(
                //   color: Palette.MAIN_BLACK,
                //   fontSize: 15,
                //   fontFamily: 'Pretendard',
                //   fontWeight: FontWeight.w500,
                // ),
                // defaultDecoration: const BoxDecoration(
                //   color: Colors.black,
                //   shape: BoxShape.circle,
                // ),

                // 오늘 날짜 스타일
                todayDecoration: BoxDecoration(
                  color: Palette.MAIN_BLUE,
                  shape: BoxShape.circle,
                ),
                todayTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),

                // 선택된 날짜의 테두리 스타일
                selectedDecoration: BoxDecoration(
                  color: Palette.SUB_BLUE,
                  shape: BoxShape.circle,
                ),
                selectedTextStyle: TextStyle(
                  color: Palette.MAIN_BLACK,
                  fontSize: 15,
                ),
              ),
              // 달력의 요일 스타일
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                  color: Palette.MAIN_BLACK,
                  fontSize: 10,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                ),
                weekendStyle: TextStyle(
                  color: Palette.MAIN_BLACK,
                  fontSize: 10,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // 여백
            const SizedBox(
              height: 20,
            ),

            // 알림 리스트
            RoundedRectangle(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AlarmCreate()),
                );
              },
              width: MediaQuery.of(context).size.width * 0.9,
              height: 100,
              // 알림 상세 화면으로 이동시켜야 할듯
              child: Padding(
                padding: EdgeInsets.only(
                    left: screenWidth * 0.10, right: screenWidth * 0.03),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '감기약',
                      style: TextStyle(
                          color: Palette.MAIN_BLACK,
                          fontSize: 15,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w700),
                    ),
                    const Text(
                      '오전 10: 11',
                      style: TextStyle(
                          color: Palette.MAIN_BLACK,
                          fontSize: 15,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w700),
                    ),
                    RoundedRectangle(
                      width: 68,
                      height: 64,
                      onTap: () => print('알림 활성화'),
                      child: const Icon(
                        Icons.check,
                        color: Palette.MAIN_BLACK,
                        size: 15,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
