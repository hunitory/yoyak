import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyak/store/login_store.dart';
import 'package:yoyak/store/pill_bag_store.dart';
import '../../styles/colors/palette.dart';
import 'package:yoyak/components/base_input.dart';
import 'package:yoyak/styles/screenSize/screen_size.dart';
import 'package:yoyak/components/account_filter.dart';
import 'package:yoyak/components/base_button.dart';
import 'package:yoyak/apis/url.dart';

// 약 봉투 생성 다이얼로그
class PillBagDialog extends StatefulWidget {
  const PillBagDialog({super.key});

  @override
  State<PillBagDialog> createState() => _PillBagDialogState();
}

class _PillBagDialogState extends State<PillBagDialog> {
  final TextEditingController _nameController =
      TextEditingController(); // 약 봉투 이름 관리
  // selectedAccountSeq 초기에 null값인거 바꾸기
  int? _selectedAccountSeq;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // 약 봉투 생성 api
  Future<void> createPillBag(int accountSeq, String name) async {
    String yoyakURL = API.yoyakUrl; // 호스트 URL
    String accessToken = context.read<LoginStore>().accessToken;
    String url = '$yoyakURL/medicineEnvelop'; // path
    // 색상 리스트
    List<String> colors = [
      "0XffBED1CF",
      "0xffE78895",
      "0xffBBE2EC",
      "0xffFFE4C9"
    ];

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode({
          "accountSeq": accountSeq,
          "name": _nameController.text,
          // 남은 일 : color
          // @
          //color 어떻게 바꾸지?
          "color": colors[accountSeq % 4],
        }),
      );

      if (response.statusCode == 200) {
        print("약 봉투 생성 성공");
        if (mounted) {
          Navigator.pop(context);
        }
        context.read<PillBagStore>().getPillBagDatas(context);
      } else {
        print("약 봉투 생성 실패: ${response.body}");
      }
    } catch (e) {
      print("약 봉투 생성 에러: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var accountList = context.watch<LoginStore>().alarmAccounts;

    return Dialog(
      backgroundColor: Palette.MAIN_WHITE,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 300,
        child: Column(
          children: [
            SizedBox(
              height: ScreenSize.getWidth(context) * 0.07,
            ),
            BaseInput(
              title: "약 봉투 이름",
              width: ScreenSize.getWidth(context) * 0.675,
              child: TextField(
                controller: _nameController,
                maxLength: 10,
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
                    bottom: 13,
                    top: 13,
                  ),
                  counterText: '',
                ),
              ),
            ),
            SizedBox(
              height: ScreenSize.getWidth(context) * 0.07,
            ),
            // 돌보미 필터
            AccountFilter(
              title: "누구의 약 봉투인가요?",
              child: DropdownButton<int>(
                  isDense: true,
                  isExpanded: true,
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                    top: 7.5,
                  ),
                  value: _selectedAccountSeq ?? accountList[0].seq!,
                  items: accountList.map((account) {
                    return DropdownMenuItem<int>(
                      value: account.seq!,
                      child: Text(account.nickname ?? 'Unknown'),
                    );
                  }).toList(),
                  // 값을 선택하였을 때의 action
                  onChanged: (int? newValue) {
                    setState(() {
                      _selectedAccountSeq = newValue ?? accountList[0].seq!;
                      print(_selectedAccountSeq);
                    });
                  }),
            ),
            SizedBox(
              height: ScreenSize.getWidth(context) * 0.07,
            ),

            // 확인 버튼
            BaseButton(
                text: "생성하기",
                width: ScreenSize.getWidth(context) * 0.675,
                colorMode: 'blue',
                onPressed: () {
                  print('약 봉투 생성');

                  createPillBag(
                    _selectedAccountSeq ?? accountList[0].seq!,
                    _nameController.text,
                  );
                }),
          ],
        ),
      ),
    );
  }
}
