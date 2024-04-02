import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yoyak/apis/url.dart';
import 'package:yoyak/components/base_button.dart';
import 'package:yoyak/components/base_input.dart';
import 'package:yoyak/models/user/account_models.dart';
import 'package:yoyak/store/login_store.dart';
import 'package:yoyak/styles/colors/palette.dart';
import 'package:yoyak/styles/screenSize/screen_size.dart';

class UpdateAccountScreen extends StatefulWidget {
  final AccountModel accountitem;
  final bool isUser;

  const UpdateAccountScreen({
    super.key,
    required this.accountitem,
    required this.isUser,
  });

  @override
  State<UpdateAccountScreen> createState() => _UpdateAccountScreenState();
}

class _UpdateAccountScreenState extends State<UpdateAccountScreen> {
  late TextEditingController _userNameController;
  late TextEditingController _userDiseaseController;

  TextEditingController yearController = TextEditingController();
  TextEditingController monthController = TextEditingController();
  TextEditingController dayController = TextEditingController();

  FocusNode monthFocusNode = FocusNode();
  FocusNode dayFocusNode = FocusNode();
  String gender = 'N';

  String getGenderDisplay(String gender) {
    switch (gender) {
      case 'F':
        return '여자';
      case 'M':
        return '남자';
      case 'N':
        return '선택하지 않음';
      default:
        return '알 수 없음'; // 혹은 다른 기본값
    }
  }

  void _showGenderDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Palette.MAIN_WHITE,
          child: Container(
            width: 100,
            height: 210,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('남자'),
                  titleTextStyle: const TextStyle(
                    color: Palette.MAIN_BLACK,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  onTap: () {
                    setState(() {
                      gender = 'M';
                    });
                    Navigator.of(context).pop();
                  },
                ),
                const Divider(
                  // Divider 추가
                  height: 0.1,
                  color: Palette.SUB_BLACK,
                ),
                ListTile(
                  title: const Text('여자'),
                  titleTextStyle: const TextStyle(
                    color: Palette.MAIN_BLACK,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  onTap: () {
                    setState(() {
                      gender = 'F';
                    });
                    Navigator.of(context).pop();
                  },
                ),
                const Divider(
                  // Divider 추가
                  height: 0.1,
                  color: Palette.SUB_BLACK,
                ),
                ListTile(
                  title: const Text('선택하지 않음'),
                  titleTextStyle: const TextStyle(
                    color: Palette.MAIN_BLACK,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  onTap: () {
                    setState(() {
                      gender = 'N';
                    });
                    Navigator.of(context).pop();
                  },
                ),
                const Divider(
                  // Divider 추가
                  height: 0.1,
                  color: Palette.SUB_BLACK,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSnackbar(String message) {
    final snackbar = SnackBar(
      backgroundColor: Palette.MAIN_RED,
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

  Future<void> deleteAccountData(int accountSeq) async {
    String yoyakURL = API.yoyakUrl; // 서버 URL
    final prefs = await SharedPreferences.getInstance();
    String url = '$yoyakURL/account/$accountSeq'; // 서버 URL

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
        print('삭제 완료');
        if (mounted) {
          context.read<LoginStore>().getAccountData();
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

  Future<void> updateAccountData() async {
    String yoyakURL = API.yoyakUrl; // 서버 URL
    final prefs = await SharedPreferences.getInstance();

    String url = '$yoyakURL/account'; // 서버 URL
    String formattedMonth = monthController.text.length == 1
        ? '0${monthController.text}'
        : monthController.text;

    // 서버에 보낼 데이터 준비
    Map<String, dynamic> accountData = {
      'seq': widget.accountitem.seq,
      'name': _userNameController.text,
      'nickname': _userNameController.text,
      'gender': gender,
      'birth': '${yearController.text}-$formattedMonth-${dayController.text}',
      'disease': _userDiseaseController.text,
      'profileImg': widget.accountitem.profileImg,
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
        body: json.encode(accountData),
      );

      if (response.statusCode == 200) {
        print('수정 완료');
        // 알람 데이터를 다시 불러오기
        if (mounted) {
          context.read<LoginStore>().getAccountData();
        }
      } else {
        // 오류 처리
        print('수정 엑세스 토큰 $accessToken');
        print('뭐지 뭐가 잘못됨? $accountData');
        print(
            'Failed to send account data, status code: ${response.statusCode}');
      }
    } catch (e) {
      // 예외 처리
      print('Error sending account data: $e');
    }
  }

  Future<void> createAccountData() async {
    String yoyakURL = API.yoyakUrl; // 서버 URL
    final prefs = await SharedPreferences.getInstance();
    String url = '$yoyakURL/account'; // 서버 URL
    String formattedMonth = monthController.text.length == 1
        ? '0${monthController.text}'
        : monthController.text;

    // 서버에 보낼 데이터 준비
    Map<String, dynamic> accountData = {
      'name': _userNameController.text,
      'nickname': _userNameController.text,
      'gender': gender,
      'birth': '${yearController.text}-$formattedMonth-${dayController.text}',
      'disease': _userDiseaseController.text,
      'profileImg': widget.accountitem.profileImg,
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
        body: json.encode(accountData),
      );

      if (response.statusCode == 200) {
        print('생성완료');
        // 알람 데이터를 다시 불러오기
        if (mounted) {
          context.read<LoginStore>().getAccountData();
        }
      } else {
        // 오류 처리
        print(accountData);
        print(
            'Failed to send account data, status code: ${response.statusCode}');
      }
    } catch (e) {
      // 예외 처리
      print('Error sending account data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _userNameController =
        TextEditingController(text: widget.accountitem.nickname);

    gender = widget.accountitem.gender!;
    _userDiseaseController =
        TextEditingController(text: widget.accountitem.disease);

    yearController = TextEditingController();
    monthController = TextEditingController();
    dayController = TextEditingController();
    monthFocusNode = FocusNode();
    dayFocusNode = FocusNode();

    if (widget.accountitem.birth != null &&
        widget.accountitem.birth!.isNotEmpty) {
      // birth 값이 있는 경우, 해당 값을 사용하여 yearController, monthController, dayController를 초기화
      List<String> parts = widget.accountitem.birth!.split('-');
      if (parts.length == 3) {
        yearController.text = parts[0];
        monthController.text = parts[1];
        dayController.text = parts[2];
      }
    } else {
      // birth 값이 없는 경우, 컨트롤러를 빈 값으로 초기화
      yearController.clear();
      monthController.clear();
      dayController.clear();
    }

    // 년도 입력 필드 리스너
    yearController.addListener(() {
      String yearText = yearController.text;
      if (yearText.isNotEmpty && int.tryParse(yearText) != null) {
        int yearValue = int.parse(yearText);
        int currentYear = DateTime.now().year;
        if (yearValue > currentYear) {
          _showSnackbar("년도는 현재 년도를 초과할 수 없습니다.");
          yearController.text = currentYear.toString();
        }
      }
    });

    print('지금 유저 인가요? ${widget.isUser}');
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
    return Scaffold(
      backgroundColor: Palette.MAIN_WHITE,
      appBar: AppBar(
        backgroundColor: Palette.MAIN_WHITE,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Palette.MAIN_BLACK,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.accountitem.nickname!.isEmpty ? '돌봄 대상 추가' : '프로필 수정',
              style: const TextStyle(
                color: Palette.MAIN_BLACK,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
            if (widget.isUser == false &&
                widget.accountitem.nickname!.isNotEmpty)
              BaseButton(
                width: 104,
                height: 35,
                onPressed: () {
                  deleteAccountData(widget.accountitem.seq!);
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
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),

              // 프로필 이미지
              GestureDetector(
                onTap: () {
                  // 프로필 이미지 변경
                  _showProfileImageDialog();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Image(
                          image: AssetImage(
                              'assets/images/profiles/profile${widget.accountitem.profileImg}.png'),
                        ),
                        Positioned(
                          right: 3, // 버튼을 오른쪽으로 조금 이동
                          bottom: 3, // 버튼을 아래로 조금 이동
                          child: SizedBox(
                            width: 30,
                            height: 30,
                            child: FloatingActionButton(
                              backgroundColor: Palette.MAIN_BLUE,
                              elevation: 2,
                              shape: const CircleBorder(),
                              onPressed: () {
                                _showProfileImageDialog();
                              },
                              child: const Icon(Icons.add,
                                  color: Palette.MAIN_WHITE, size: 22),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 이름
              BaseInput(title: '이름', child: nameInput()),
              const SizedBox(height: 20),

              // 성별
              const SizedBox(width: 20),
              BaseInput(
                title: '성별',
                child: GestureDetector(
                  onTap: _showGenderDialog,
                  child: SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        getGenderDisplay(gender),
                        style: const TextStyle(
                          color: Palette.MAIN_BLACK,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              // 생년월일
              Column(
                children: [
                  const Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        '생년월일',
                        style: TextStyle(
                          color: Palette.MAIN_BLUE,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: ScreenSize.getWidth(context) * 0.25,
                        height: 50,
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Palette.MAIN_BLUE, width: 1),
                          borderRadius: BorderRadius.circular(20),
                          color: Palette.MAIN_WHITE,
                        ),
                        child: Center(
                          child: TextField(
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.datetime,
                            controller: yearController,
                            onChanged: (value) {
                              setState(() {
                                yearController.text = value;
                              });
                            },
                            maxLength: 4,
                            decoration: const InputDecoration(
                              counterText: '',
                              hintText: "2000",
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ),
                              border: InputBorder.none,
                            ),
                            onEditingComplete: () {
                              if (yearController.text.length == 4) {
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
                          width: ScreenSize.getWidth(context) * 0.25,
                          height: 50,
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Palette.MAIN_BLUE, width: 1),
                            borderRadius: BorderRadius.circular(20),
                            color: Palette.MAIN_WHITE,
                          ),
                          child: Center(
                            child: TextField(
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.datetime,
                              controller: monthController,
                              focusNode: monthFocusNode,
                              onChanged: (value) {
                                setState(() {
                                  monthController.text = value;
                                });
                              },
                              maxLength: 2,
                              decoration: const InputDecoration(
                                counterText: '',
                                hintText: "10",
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                                border: InputBorder.none,
                              ),
                              onEditingComplete: () {
                                if (monthController.text.length == 2) {
                                  FocusScope.of(context)
                                      .requestFocus(dayFocusNode);
                                }
                              },
                              onSubmitted: (value) {
                                int? monthValue = int.tryParse(value);
                                if (monthValue == null ||
                                    monthValue < 1 ||
                                    monthValue > 12) {
                                  _showSnackbar("월은 1과 12 사이의 숫자여야 합니다.");
                                  monthController.clear();
                                } else {
                                  monthController.text =
                                      monthValue.toString().padLeft(2, '0');
                                }
                              },
                            ),
                          )),
                      const SizedBox(
                        width: 15,
                      ),
                      // 일 입력
                      Container(
                        width: ScreenSize.getWidth(context) * 0.25,
                        height: 50,
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Palette.MAIN_BLUE, width: 1),
                          borderRadius: BorderRadius.circular(20),
                          color: Palette.MAIN_WHITE,
                        ),
                        child: Center(
                          child: TextField(
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.datetime,
                            controller: dayController,
                            focusNode: dayFocusNode,
                            onChanged: (value) {
                              setState(() {
                                dayController.text = value; // 이렇게 해야 합니다.
                              });
                            },
                            maxLength: 2,
                            decoration: const InputDecoration(
                              counterText: '',
                              hintText: "20",
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ),
                              border: InputBorder.none,
                            ),
                            onSubmitted: (value) {
                              int? dayValue = int.tryParse(value);
                              if (dayValue == null ||
                                  dayValue < 1 ||
                                  dayValue > 31) {
                                _showSnackbar("일은 1과 31 사이의 숫자여야 합니다.");
                                dayController.clear();
                              } else {
                                dayController.text =
                                    dayValue.toString().padLeft(2, '0');
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              BaseInput(title: '주요 증상', child: diseaseInput()),
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
        onPressed: () async {
          // 필수 필드 확인
          if (_userNameController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Palette.MAIN_RED,
                content: Text(
                  '이름을 입력해주세요.',
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

          if (gender.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Palette.MAIN_RED,
                content: Text(
                  '성별을 선택해주세요.',
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
          if (yearController.text.isEmpty ||
              monthController.text.isEmpty ||
              dayController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Palette.MAIN_RED,
                content: Text('생년월일을 입력해주세요.',
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
          if (widget.accountitem.seq == null) {
            await createAccountData();
          } else {
            // 알림 수정 시
            await updateAccountData();
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

  void _showProfileImageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3개의 열
                crossAxisSpacing: 10.0, // 열 사이 간격
                mainAxisSpacing: 10.0, // 행 사이 간격
              ),
              itemCount: 9, // 프로필 이미지 개수
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // 이미지 선택 로직
                    setState(() {
                      widget.accountitem.profileImg = index;
                    });
                    Navigator.of(context).pop();
                  },
                  child: Image.asset(
                    'assets/images/profiles/profile$index.png',
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget nameInput() {
    return TextField(
      controller: _userNameController,
      // autofocus: true,
      maxLength: 5,
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
        hintText: '이름을 입력해주세요.',
        // 글자수 제한 안내문구 삭제
        counterText: '',
      ),
    );
  }

  Widget diseaseInput() {
    return TextField(
      controller: _userDiseaseController,
      maxLength: 100,
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
        hintText: '주요 증상을 입력해주세요.',
        // 글자수 제한 안내문구 삭제
        counterText: '',
      ),
    );
  }
}
