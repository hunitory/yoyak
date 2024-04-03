import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyak/components/rounded_rectangle.dart';
import 'package:yoyak/components/pill_bag.dart';
import 'package:yoyak/store/pill_bag_store.dart';
import 'package:yoyak/styles/screenSize/screen_size.dart';
import '../../styles/colors/palette.dart';
import 'package:yoyak/components/pill_bag_dialog.dart';
import 'package:yoyak/models/user/account_models.dart';
import 'package:yoyak/store/login_store.dart';

class PillBagModal extends StatefulWidget {
  final double sceenHeight;
  final int medicineSeq;

  const PillBagModal({
    super.key,
    required this.sceenHeight,
    required this.medicineSeq,
  });

  @override
  State<PillBagModal> createState() => _PillBagModalState();
}

class _PillBagModalState extends State<PillBagModal> {
  int? _selectedAccountSeq; // 선택된 accountSeq

  @override
  Widget build(BuildContext context) {
    // 약 봉투 리스트 가져오기
    var pillBags = context.watch<PillBagStore>().pillBags;
    // 돌보미별 약 봉투 필터
    List<dynamic> pillBagList = pillBags["result"] ?? [];

    print('모달 pillBagList: $pillBags');
    print('다시 빌드?');

    final List<AccountModel> accountList =
        context.watch<LoginStore>().accountList; // 돌보미 목록

    // 돌보미 필터링 드롭다운 메뉴 항목 생성
    List<DropdownMenuItem<int>> dropdownItems = [
      const DropdownMenuItem(
        value: null, // '모두' 옵션
        child: Text("모두  "),
      ),
    ];

    // accountList의 각 요소를 순회하면서 드롭다운 메뉴 항목(DropdownMenuItem) 생성
    for (var account in accountList) {
      dropdownItems.add(
        DropdownMenuItem(
          value: account.seq,
          child: Text(account.nickname!),
        ),
      );
    }

    // 필터링된 약 봉투 위젯 목록 생성
    List<Widget> filteredPillBagsModalWidgets = pillBags['result']
            // 주어진 조건을 만족하는지 확인하고, 그 조건을 만족하는 항목들만을 모아 새로운 리스트를 생성
            // ?. : null이 아닌 경우에만
            ?.where((pillBag) =>
                _selectedAccountSeq == null || // 모든 약 봉투 보기 선택 시
                pillBag['accountSeq'] ==
                    _selectedAccountSeq) // 특정 사용자의 약 봉투만 보기 선택 시
            .map<Widget>((bag) => PillBag(
                  // 위젯으로 변환
                  medicineEnvelopSeq: bag["medicineEnvelopSeq"],
                  envelopName: bag["envelopName"],
                  medicineSeq: widget.medicineSeq,
                  accountSeq: bag["accountSeq"],
                  nickname: bag["nickname"],
                  isSavedMedicine: bag["isSavedMedicine"],
                  // 컬러코드로 받기
                  color: bag["color"],
                  onClick: () {
                    // 약 봉투에 저장하기 함수..?
                    print('클릭');
                  },
                ))
            .toList() ??
        []; // pillBags["result"] is null이면 빈 리스트를 반환

    // @ 모달 자체를 scroll 못하나?
    return RoundedRectangle(
      width: double.infinity,
      // height: widget.sceenHeight * 0.75,
      height: MediaQuery.of(context).size.height * 0.60,
      color: Palette.MAIN_WHITE,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                // width: 0,
                width: MediaQuery.of(context).size.height * 0.05,
              ),
              const Text(
                "약 봉투에 담기",
                style: TextStyle(
                  color: Palette.MAIN_BLACK,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // 약 봉투 생성 함수..?
                  print('약 봉투 생성');
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      // 실시간 반영을 위한 StatefulBuilder
                      return StatefulBuilder(builder: (context, setState) {
                        return Builder(
                          // Builder를 사용하여 새로운 context를 생성
                          builder: (innerContext) {
                            // 이제 innerContext는 모달 내부의 context를 참조합니다.
                            return PillBagDialog(
                              medicineSeq: widget.medicineSeq,
                              onError: (errorMessage) {
                                // ScaffoldMessenger.of(innerContext).showSnackBar(
                                //   // innerContext를 사용
                                //   SnackBar(
                                //     content: Text(errorMessage),
                                //     backgroundColor: Colors.red,
                                //   ),
                                // );
                              },
                            );
                          },
                        );
                      });
                    },
                  );
                },
                child: Image.asset(
                  'assets/images/pillbag.png',
                  width: 40,
                  height: 40,
                ),
              ),
            ],
          ),
          // 돌보미 필터
          // 돌보미 필터링 드롭다운 메뉴
          if (accountList.length > 1)
            // 여기에 sizedbox
            Padding(
              padding: const EdgeInsets.only(
                right: 15.0,
                top: 10,
                bottom: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  DropdownButton<int>(
                    value: _selectedAccountSeq,
                    items: dropdownItems,
                    onChanged: (value) {
                      setState(() {
                        _selectedAccountSeq = value; // 선택된 accountSeq 업데이트
                      });
                    },
                    underline: Container(), // 드롭다운 메뉴의 밑줄 제거
                  ),
                ],
              ),
            )

          // 약 봉투 리스트
          else
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
          SizedBox(
            height: widget.sceenHeight * 0.35,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (filteredPillBagsModalWidgets.isNotEmpty)
                    ...filteredPillBagsModalWidgets
                  else
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 가운데가 안 먹어
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1,
                          ),
                          const Text(
                            "약 봉투가 없습니다.",
                            style: TextStyle(
                              color: Palette.SUB_BLACK,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (accountList.length <= 1)
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),

          Container(
            margin: const EdgeInsets.only(
              bottom: 10,
            ),
            height: 45,
            width: ScreenSize.getWidth(context) * 0.9,
            decoration: BoxDecoration(
              color: Palette.MAIN_BLUE,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextButton(
              onPressed: () {
                Navigator.pop(context); // 모달 닫기
              },
              style: TextButton.styleFrom(
                foregroundColor: Palette.MAIN_BLUE, // 버튼 텍스트 색상
              ),
              child: const Text(
                '완료',
                style: TextStyle(
                  color: Palette.MAIN_WHITE,
                  fontSize: 17,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
