import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yoyak/apis/url.dart';
import 'package:yoyak/components/account_filter.dart';
import 'package:yoyak/components/base_button.dart';
import 'package:yoyak/components/base_input.dart';
import 'package:yoyak/components/bottom_modal.dart';
import 'package:yoyak/components/rounded_rectangle.dart';
import 'package:yoyak/components/selectday_button.dart';
import 'package:yoyak/hooks/format_time.dart';
import 'package:yoyak/models/alarm/alarmdetail_models.dart';
import 'package:yoyak/store/alarm_store.dart';
import 'package:yoyak/store/login_store.dart';
import 'package:yoyak/styles/colors/palette.dart';
import 'package:yoyak/styles/screenSize/screen_size.dart';

class AlarmCreate extends StatefulWidget {
  final int? notiSeq;

  const AlarmCreate({
    super.key,
    required this.notiSeq,
  });

  @override
  State<AlarmCreate> createState() => _AlarmCreateState();
}

class _AlarmCreateState extends State<AlarmCreate> {
  final _formKey = GlobalKey<FormState>();

  late String _alarmName = '';
  late DateTime _alarmStartDate = DateTime.now();
  late DateTime _alarmEndDate = DateTime.now();
  DateTimeRange dateTimeRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );
  late List<String> _alarmDays = [
    'MONDAY',
    'TUESDAY',
    'WEDNESDAY',
    'THURSDAY',
    'FRIDAY',
    'SATURDAY',
    'SUNDAY',
  ];
  late List<DateTime> _alarmTime = [];

  // 주기 관련 변수
  late bool isEveryday = true;
  late int _alarmAccountSeq; // 실제 계정번호로 대체 필요

  late TextEditingController _alarmNameController;

  void _showSnackbar(String message, String color) {
    final snackbar = SnackBar(
      backgroundColor: color == 'red' ? Palette.MAIN_RED : Palette.MAIN_BLUE,
      content: Text(
        message,
        style: const TextStyle(
          color: Palette.MAIN_WHITE,
          fontSize: 14,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w400,
        ),
      ),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  Future<void> fetchAlarmData(int notiSeq) async {
    String yoyakURL = API.yoyakUrl; // 서버 URL
    final prefs = await SharedPreferences.getInstance();
    String url = '$yoyakURL/noti/$notiSeq';
    Uri uri = Uri.parse(url);

    try {
      // GET 요청 보내기
      String? accessToken = prefs.getString('accessToken');
      var response = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        "Authorization": 'Bearer $accessToken',
      });
      if (response.statusCode == 200) {
        var decodedBody = utf8.decode(response.bodyBytes);
        var jsonData = json.decode(decodedBody);

        // AlarmDetailModels 객체로 변환
        AlarmDetailModel alarmDetails = AlarmDetailModel.fromJson(jsonData);

        // AlarmDetailModels 객체를 사용하여 폼 데이터 설정
        setState(() {
          _alarmName = alarmDetails.name!;
          _alarmAccountSeq = alarmDetails.accountSeq!;
          _alarmNameController = TextEditingController(text: _alarmName);
          _alarmStartDate = DateTime.parse(alarmDetails.startDate ?? '');
          _alarmEndDate = DateTime.parse(alarmDetails.endDate ?? '');
          _alarmDays = alarmDetails.period ?? [];
          _alarmTime = alarmDetails.time?.map<DateTime>((timeStr) {
                List<String> parts = timeStr.split(':');
                return DateTime(
                  _alarmStartDate.year,
                  _alarmStartDate.month,
                  _alarmStartDate.day,
                  int.parse(parts[0]),
                  int.parse(parts[1]),
                  int.parse(parts[2]),
                );
              }).toList() ??
              [];
        });
      } else {
        print('Failed to load data ${response.statusCode}');
      }
    } catch (e) {
      // 예외 처리
      print('Error fetching data: $e');
    }
  }

  Future<void> sendAlarmData() async {
    String yoyakURL = API.yoyakUrl; // 서버 URL
    final prefs = await SharedPreferences.getInstance();
    String url = '$yoyakURL/noti'; // 서버 URL

    // _alarmTime을 "HH:mm" 형식의 문자열로 변환
    List<String> formattedAlarmTimes = _alarmTime.map((datetime) {
      return '${datetime.hour.toString().padLeft(2, '0')}:${datetime.minute.toString().padLeft(2, '0')}';
    }).toList();
    print(
      '$_alarmAccountSeq, $_alarmName, $_alarmStartDate, $_alarmEndDate, $_alarmDays, $formattedAlarmTimes',
    );

    // 서버에 보낼 데이터 준비
    Map<String, dynamic> alarmData = {
      'accountSeq': _alarmAccountSeq,
      'name': _alarmName,
      'startDate': _alarmStartDate.toIso8601String(),
      'endDate': _alarmEndDate.toIso8601String(),
      'period': _alarmDays,
      'time': formattedAlarmTimes,
    };

    try {
      // POST 요청 보내기
      String? accessToken = prefs.getString('accessToken');
      var response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer $accessToken',
        },
        body: json.encode(alarmData),
      );

      if (response.statusCode == 200) {
        _showSnackbar('알람이 생성되었습니다.', 'blue');
        print('Alarm data sent successfully');
        // 알람 데이터를 다시 불러오기
        if (mounted) {
          context.read<AlarmStore>().getAlarmDatas(context);
        }
      } else {
        // 오류 처리
        print(accessToken);
        print('Failed to send alarm data, status code: ${response.statusCode}');
      }
    } catch (e) {
      // 예외 처리
      print('Error sending alarm data: $e');
    }
  }

  Future<void> updateAlarmData(int notiSeq) async {
    String yoyakURL = API.yoyakUrl; // 서버 URL
    final prefs = await SharedPreferences.getInstance();

    String url = '$yoyakURL/noti'; // 서버 URL

    // _alarmTime을 "HH:mm" 형식의 문자열로 변환
    List<String> formattedAlarmTimes = _alarmTime.map((datetime) {
      return '${datetime.hour.toString().padLeft(2, '0')}:${datetime.minute.toString().padLeft(2, '0')}';
    }).toList();

    // 서버에 보낼 데이터 준비
    Map<String, dynamic> alarmData = {
      'notiSeq': notiSeq,
      'name': _alarmName,
      'startDate': _alarmStartDate.toIso8601String(),
      'endDate': _alarmEndDate.toIso8601String(),
      'period': _alarmDays,
      'time': formattedAlarmTimes,
    };

    try {
      // POST 요청 보내기
      String? accessToken = prefs.getString('accessToken');
      var response = await http.put(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer $accessToken',
        },
        body: json.encode(alarmData),
      );

      if (response.statusCode == 200) {
        _showSnackbar('알람이 수정되었습니다.', 'blue');
        print('수정 완료');
        // 알람 데이터를 다시 불러오기
        if (mounted) {
          context.read<AlarmStore>().getAlarmDatas(context);
        }
      } else {
        // 오류 처리
        print('Failed to send alarm data, status code: ${response.statusCode}');
      }
    } catch (e) {
      // 예외 처리
      print('Error sending alarm data: $e');
    }
  }

  Future<void> deleteAlarmData(int notiSeq) async {
    String yoyakURL = API.yoyakUrl; // 서버 URL
    final prefs = await SharedPreferences.getInstance();
    String url = '$yoyakURL/noti/time/$notiSeq'; // 서버 URL

    try {
      // DELETE 요청 보내기
      String? accessToken = prefs.getString('accessToken');
      var response = await http.delete(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        _showSnackbar('알람이 삭제되었습니다.', 'red');
        print('삭제 완료');
        if (mounted) {
          context.read<AlarmStore>().getAlarmDatas(context);
        }
        // 알람 데이터를 다시 불러오기
      } else {
        // 오류 처리
        print('Failed to send alarm data, status code: ${response.statusCode}');
      }
    } catch (e) {
      // 예외 처리
      print('Error sending alarm data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _alarmNameController = TextEditingController();
    if (widget.notiSeq != null) {
      fetchAlarmData(widget.notiSeq!);
    }

    // accountList에서 첫 번째 요소의 seq를 가져와서 초기화
    var accountList = context.read<LoginStore>().accountList;
    _alarmAccountSeq = accountList.isNotEmpty ? accountList.first.seq ?? 0 : 0;
  }

  void handleEverydaySelected() {
    setState(() {
      isEveryday = true;
      _alarmDays.clear();
    });
  }

  void handleSpecificDaySelected() {
    setState(() {
      if (isEveryday) {
        _alarmDays.clear();
        isEveryday = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var accountList = context.watch<LoginStore>().accountList;

    return Scaffold(
      backgroundColor: Palette.MAIN_WHITE,
      appBar: AppBar(
        backgroundColor: Palette.MAIN_WHITE,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(), // 왼쪽 여백
            if (widget.notiSeq != null) // 조건 확인
              BaseButton(
                height: 35,
                onPressed: () {
                  // 삭제 로직 추가
                  deleteAlarmData(widget.notiSeq!);
                  Navigator.pop(context);
                },
                text: '삭제하기',
                colorMode: 'blue',
              ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // 여백
                const SizedBox(
                  height: 10,
                ),
                // 알림 이름
                BaseInput(title: '알림 이름', child: alarmnameInput()),
                // 여백
                const SizedBox(
                  height: 20,
                ),
                // 계정 선택
                if (accountList.length > 1) ...[
                  // 계정 선택 섹션
                  AccountFilter(
                    title: '돌봄 대상',
                    child: DropdownButton<int>(
                      isDense: true,
                      isExpanded: true,
                      padding: const EdgeInsets.only(
                        left: 15,
                        right: 15,
                        top: 7.5,
                      ),
                      value: _alarmAccountSeq,
                      items: accountList.map((account) {
                        return DropdownMenuItem<int>(
                          value: account.seq,
                          child: Text(account.nickname ?? 'Unknown'),
                        );
                      }).toList(),
                      onChanged: widget.notiSeq == null
                          ? (int? newValue) {
                              setState(() {
                                _alarmAccountSeq =
                                    newValue ?? accountList[0].seq!;
                              });
                            }
                          : null, // 수정 상태에서는 드롭다운 비활성화
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                // 기간
                BaseInput(
                  title: '알림 기간',
                  child: GestureDetector(
                    onTap: () async {
                      await selectDateRange();
                    },
                    child: RoundedRectangle(
                      width: ScreenSize.getWidth(context) * 0.85,
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${_alarmStartDate.year}.${_alarmStartDate.month}.${_alarmStartDate.day}        ~        ${_alarmEndDate.year}.${_alarmEndDate.month}.${_alarmEndDate.day}',
                            style: const TextStyle(
                              color: Palette.MAIN_BLACK,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // 주기
                BaseInput(
                  title: '알림 요일',
                  child: InputSelectDay(
                    selectedDays: _alarmDays,
                    isEveryday: isEveryday,
                    onEverydaySelected: handleEverydaySelected,
                    onSpecificDaySelected: handleSpecificDaySelected,
                    onDaysChanged: (updatedDays) {
                      setState(() {
                        _alarmDays = updatedDays;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // 알림 시간
                const Row(
                  children: [
                    // input 값 이름 왼쪽 여백
                    SizedBox(width: 20),

                    // input 값 이름
                    Text(
                      '알림 시간',
                      style: TextStyle(
                        color: Palette.MAIN_BLUE,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                alarmTimeList(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    BaseButton(
                      width: ScreenSize.getWidth(context) * 0.67,
                      onPressed: () {
                        timeSelectorModal(
                            context: context,
                            time: null,
                            onTimeSelected: (selectedTime) {
                              setState(() {
                                _alarmTime = List.from(_alarmTime)
                                  ..add(selectedTime);
                              });
                            });
                      },
                      text: '시간 추가 +',
                      colorMode: 'blue',
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
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
        onPressed: () async {
          bool isFormValid = _formKey.currentState!.validate();
          if (!isFormValid) {
            // 폼의 필드 중 하나라도 유효하지 않은 경우
            return; // 더 이상 진행하지 않음
          }

          // 폼의 모든 TextFormField의 onSaved를 호출
          _formKey.currentState!.save();

          // 필수 필드 확인
          if (_alarmName.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Palette.MAIN_RED,
                content: Text(
                  '알람 이름을 입력해주세요.',
                  style: TextStyle(
                    color: Palette.MAIN_WHITE,
                    fontSize: 16,
                    fontFamily: 'pretendard',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                duration: Duration(seconds: 1),
              ),
            );
            return;
          }

          if (_alarmDays.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Palette.MAIN_RED,
                content: Text(
                  '알람 요일을 선택해주세요.',
                  style: TextStyle(
                    color: Palette.MAIN_WHITE,
                    fontSize: 16,
                    fontFamily: 'pretendard',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                duration: Duration(seconds: 1),
              ),
            );
            return;
          }
          if (_alarmTime.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Palette.MAIN_RED,
                content: Text('시간을 추가해주세요.',
                    style: TextStyle(
                      color: Palette.MAIN_WHITE,
                      fontSize: 16,
                      fontFamily: 'pretendard',
                      fontWeight: FontWeight.w500,
                    )),
                duration: Duration(seconds: 1),
              ),
            );
            return;
          }
          // 알림 생성 시
          if (widget.notiSeq == null) {
            await sendAlarmData();
            print(accountList);
          } else {
            // 알림 수정 시
            await updateAlarmData(widget.notiSeq!);
          }
          if (context.mounted) {
            Navigator.pop(context);
          }
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

  // 알림 이름 입력
  Widget alarmnameInput() {
    return TextFormField(
      controller: _alarmNameController,
      maxLength: 6,
      cursorHeight: 20,
      cursorColor: Palette.MAIN_BLUE,
      style: const TextStyle(
        color: Palette.MAIN_BLACK,
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
      decoration: const InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.only(
          left: 15,
          bottom: 10,
          top: 10,
        ),
        // placeholder
        hintText: '알람 이름을 입력해주세요.',
        // 글자수 제한 안내문구 삭제
        counterText: '',
      ),
      onSaved: (value) {
        _alarmName = value!;
      },
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

  Future<void> timeSelectorModal({
    required BuildContext context,
    required DateTime? time,
    required Function(DateTime) onTimeSelected,
  }) {
    time ??= DateTime.now();

    int selectedHour;
    int selectedMinute = time.minute;
    int selectedPeriodIndex = time.hour < 12 ? 0 : 1;

    if (time.hour == 0) {
      // 자정은 12시로 표시
      selectedHour = 12;
    } else if (time.hour > 12) {
      // 오후 시간 변환
      selectedHour = time.hour - 12;
    } else {
      selectedHour = time.hour;
    }

    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return RoundedRectangle(
              height: 380,
              width: ScreenSize.getWidth(context),
              color: Palette.MAIN_WHITE,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              '알림 시간',
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
                  const Spacer(),
                  Container(
                    width: ScreenSize.getWidth(context),
                    height: 46.7,
                    color: Palette.MAIN_BLUE,
                    child: TextButton(
                      onPressed: () {
                        int hour;
                        if (selectedPeriodIndex == 0) {
                          hour = selectedHour % 12;
                        } else {
                          hour = selectedHour + (selectedHour == 12 ? 0 : 12);
                        }

                        DateTime selectedTime = DateTime(
                          _alarmStartDate.year,
                          _alarmStartDate.month,
                          _alarmStartDate.day,
                          hour,
                          selectedMinute,
                        );

                        // 중복 체크
                        if (!_alarmTime.contains(selectedTime)) {
                          // 중복이 아니면 리스트에 추가하고 시간 순으로 정렬
                          onTimeSelected(selectedTime);
                          _alarmTime.sort((a, b) => a.compareTo(b));
                        } else {
                          // 중복인 경우, 사용자에게 알림 표시
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Palette.MAIN_RED,
                              content: Text(
                                "이미 추가된 시간입니다.",
                                style: TextStyle(
                                  color: Palette.MAIN_WHITE,
                                  fontSize: 16,
                                  fontFamily: 'pretendard',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        }

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
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget alarmTimeList() {
    return Column(
      children: _alarmTime.map((time) {
        return AlarmItem(
          alarmTime: time,
          onDelete: () {
            setState(() {
              _alarmTime.remove(time);
            });
          },
          onEdit: () {
            timeSelectorModal(
              context: context,
              time: time,
              onTimeSelected: (selectedTime) {
                int index = _alarmTime.indexOf(time);
                if (index != -1) {
                  setState(() {
                    _alarmTime[index] = selectedTime;
                    _alarmTime.sort((a, b) => a.compareTo(b));
                  });
                }
              },
            );
          },
        );
      }).toList(),
    );
  }
}

class InputSelectDay extends StatelessWidget {
  final List<String> selectedDays;
  final bool? isEveryday;
  final Function onEverydaySelected;
  final Function() onSpecificDaySelected;
  final Function(List<String>) onDaysChanged;

  const InputSelectDay({
    super.key,
    required this.selectedDays,
    required this.isEveryday,
    required this.onEverydaySelected,
    required this.onSpecificDaySelected,
    required this.onDaysChanged,
  });

  String getFormattedDays() {
    Map<String, int> dayOrder = {
      'MONDAY': 1,
      'TUESDAY': 2,
      'WEDNESDAY': 3,
      'THURSDAY': 4,
      'FRIDAY': 5,
      'SATURDAY': 6,
      'SUNDAY': 7,
    };

    Map<String, String> dayMap = {
      'MONDAY': '월',
      'TUESDAY': '화',
      'WEDNESDAY': '수',
      'THURSDAY': '목',
      'FRIDAY': '금',
      'SATURDAY': '토',
      'SUNDAY': '일',
    };

    List<String> sortedDays = List.from(selectedDays)
      ..sort((a, b) => dayOrder[a]!.compareTo(dayOrder[b]!));

    return sortedDays.map((day) => dayMap[day]!).join(', ');
  }

  bool isEverydaySelected() {
    List<String> allDays = [
      'MONDAY',
      'TUESDAY',
      'WEDNESDAY',
      'THURSDAY',
      'FRIDAY',
      'SATURDAY',
      'SUNDAY'
    ];

    return selectedDays.toSet().containsAll(allDays.toSet());
  }

  Future<void> selectDayModal({
    required BuildContext context,
    required List<String> selectedDays,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return BottomModal(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 20,
              left: 30,
              right: 30,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // 알람 이름
                    Text(
                      '알림 요일',
                      style: TextStyle(
                        color: Palette.MAIN_BLUE,
                        fontSize: 15,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        List<String> allDays = [
                          'MONDAY',
                          'TUESDAY',
                          'WEDNESDAY',
                          'THURSDAY',
                          'FRIDAY',
                          'SATURDAY',
                          'SUNDAY'
                        ];
                        onEverydaySelected();
                        onDaysChanged(allDays); // 모든 요일 선택
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: ScreenSize.getWidth(context) * 0.75,
                        color: Palette.MAIN_WHITE,
                        padding: const EdgeInsets.all(8),
                        child: const Text(
                          '매일 알림',
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
                const Divider(
                  color: Palette.SUB_BLACK,
                  height: 20,
                  thickness: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      child: Container(
                        width: ScreenSize.getWidth(context) * 0.75,
                        color: Palette.MAIN_WHITE,
                        padding: const EdgeInsets.all(8),
                        child: const Text(
                          '특정 요일',
                          style: TextStyle(
                            color: Palette.MAIN_BLACK,
                            fontSize: 16,
                            fontFamily: 'pretendard',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      onTap: () {
                        print('if 전 $selectedDays $isEveryday');
                        if (isEveryday != null && isEveryday == true) {
                          selectedDays.clear();
                          onSpecificDaySelected();
                        }

                        print(' $selectedDays');
                        showSpecificDayModal(
                          context: context,
                          selectedDays: selectedDays,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> showSpecificDayModal({
    required BuildContext context,
    required List<String> selectedDays,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return BottomModal(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 8,
              left: 15,
              right: 15,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back_ios,
                            color: Palette.MAIN_BLACK,
                            size: 18,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        const Text(
                          '특정 요일',
                          style: TextStyle(
                            color: Palette.MAIN_BLACK,
                            fontSize: 15,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        onDaysChanged(selectedDays);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        '완료',
                        style: TextStyle(
                          color: Palette.MAIN_BLUE,
                          fontSize: 15,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SelectedDay(
                      day: 'SUNDAY',
                      selectedDays: selectedDays,
                    ),
                    SelectedDay(day: 'MONDAY', selectedDays: selectedDays),
                    SelectedDay(day: 'TUESDAY', selectedDays: selectedDays),
                    SelectedDay(day: 'WEDNESDAY', selectedDays: selectedDays),
                    SelectedDay(day: 'THURSDAY', selectedDays: selectedDays),
                    SelectedDay(day: 'FRIDAY', selectedDays: selectedDays),
                    SelectedDay(day: 'SATURDAY', selectedDays: selectedDays),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 빈 공간 선택 시 반응
      behavior: HitTestBehavior.opaque,
      onTap: () {
        selectDayModal(context: context, selectedDays: selectedDays);
      },
      child: SizedBox(
        width: ScreenSize.getWidth(context),
        height: 100,
        child: Center(
          child: Text(
            isEverydaySelected() ? '매일 알림' : getFormattedDays(),
            style: const TextStyle(
              color: Palette.MAIN_BLACK,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class AlarmItem extends StatelessWidget {
  final DateTime alarmTime;
  final Function onDelete;
  final Function onEdit;

  const AlarmItem({
    super.key,
    required this.alarmTime,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(
              width: 20,
            ),
            GestureDetector(
              onTap: () => onEdit(),
              child: RoundedRectangle(
                width: ScreenSize.getWidth(context) * 0.67,
                boxShadow: const [],
                height: 40,
                border: Border.all(
                  color: Palette.MAIN_BLUE,
                  width: 1,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      formatTime(alarmTime),
                      style: const TextStyle(
                        color: Palette.MAIN_BLACK,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: ScreenSize.getWidth(context) * 0.05,
            ),
            Container(
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Palette.MAIN_RED,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Palette.MAIN_WHITE,
                  size: 25,
                ),
                onPressed: () => onDelete(),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
