import 'package:yoyak/models/user/account_models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyak/components/pill_bag_dialog.dart';
import 'package:yoyak/screen/PillBag/pill_bag_detail_screen.dart';
import 'package:yoyak/store/pill_bag_store.dart';
import 'package:yoyak/store/login_store.dart';
import 'package:yoyak/styles/colors/palette.dart';

class PillBagScreen extends StatefulWidget {
  const PillBagScreen({super.key});

  @override
  State<PillBagScreen> createState() => _PillBagScreenState();
}

class _PillBagScreenState extends State<PillBagScreen> {
  // 약 봉투 삭제
  final List<int> _checkedPillBags = <int>[]; // 체크된 약 봉투 Seq
  bool _isDeleteMode = false; // 삭제 모드
  // 돌보미별 약 봉투 필터
  int? _selectedAccountSeq; // 선택된 accountSeq

  // 삭제 모드 토글
  void _toggleDeleteMode() {
    setState(() {
      _isDeleteMode = !_isDeleteMode;
      _checkedPillBags.clear(); // 삭제 모드를 끄면 체크된 약 봉투 항목 초기화
    });
    print("삭제 모드: $_isDeleteMode");
  }

  _showSnackbar(String message, String color) {
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

  // 약 봉투 컴포넌트
  Widget _pillBagComponent(
    int medicineEnvelopSeq,
    String envelopName,
    int accountSeq,
    String nickname,
    String color,
    // bool isSavedMedicine,
    // VoidCallback onClick,
  ) {
    bool isChecked =
        _checkedPillBags.contains(medicineEnvelopSeq); // 현재 약 봉투 항목이 선택되었는지 여부

    return GestureDetector(
      onTap: () async {
        if (!_isDeleteMode) {
          // 삭제 모드가 아닐 때, 클릭하면 상세 페이지로 이동
          print("약 봉투 클릭 -> 상세 페이지 이동");
          // 약 조회 api 호출
          // async awiat 적용 부르고 네비게이터로 이동
          await context
              .read<PillBagStore>()
              .getPillBagDetail(context, medicineEnvelopSeq);
          // 상세페이지 이동
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PillBagDetailScreen(
                envelopName: envelopName,
                accountSeq: accountSeq,
                envelopSeq: medicineEnvelopSeq,
              ),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.only(bottom: 20),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Palette.MAIN_BLACK, width: 0.1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 삭제모드 - 약 봉투 체크박스 출력
            Row(
              children: [
                _isDeleteMode
                    ? SizedBox(
                        // 덜컹안하게 체크박스 원래 padding 조정
                        width: MediaQuery.of(context).size.width * 0.078,
                        height: MediaQuery.of(context).size.width * 0.078,
                        // 체크 박스 크기 조정
                        child: Transform.scale(
                          scale: 1.4,
                          child: Checkbox(
                            value: isChecked, // 체크 여부
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  _checkedPillBags.add(
                                      medicineEnvelopSeq); // 체크하면 체크된 약 봉투 Seq에 추가
                                  print(
                                      "@@@@_checkedPillBags 추가 : $_checkedPillBags");
                                } else {
                                  _checkedPillBags.remove(medicineEnvelopSeq);
                                  print(
                                      "@@@@_checkedPillBags 삭제 : $_checkedPillBags"); // 체크 해제하면 체크된 약 봉투 Seq에서 제거
                                }
                              });
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            side: const BorderSide(
                              color: Palette.MAIN_BLACK,
                              width: 0.5,
                            ),
                            activeColor: Palette.MAIN_BLUE,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      )
                    // 삭제모드가 아닐 때
                    : Icon(
                        // Icons.folder_rounded,
                        Icons.folder_open_rounded,
                        color: Color(int.parse(color)),
                        size: 30,
                      ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.06,
                ),
                // 약 봉투 이름
                Text(
                  envelopName,
                  style: const TextStyle(
                    color: Palette.MAIN_BLACK,
                    fontSize: 17,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(int.parse(color)),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                nickname,
                style: const TextStyle(
                  fontSize: 13,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                  color: Palette.MAIN_BLACK,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 돌보미 목록을 드롭다운 아이템
  // List<DropdownMenuItem<int>> getAccountDropdownItems() {
  //   List<DropdownMenuItem<int>> dropdownItems = [
  //     const DropdownMenuItem(
  //       value: null, // '모두' 옵션
  //       child: Text("모두의 약 봉투"),
  //     ),
  //   ];
  //   // pillBags 데이터에서 고유한 accountSeq와 nickname을 추출하여 목록 생성
  //   // 예시로 직접 추가한 항목들, 실제로는 API에서 받은 데이터 사용
  //   var accounts = [
  //     {"accountSeq": 1, "nickname": "사용자1"},
  //     {"accountSeq": 2, "nickname": "사용자2"},
  //   ];
  //   for (var account in accounts) {
  //     dropdownItems.add(
  //       DropdownMenuItem(
  //         value: account['accountSeq'],
  //         child: Text(account['nickname']),
  //       ),
  //     );
  //   }
  //   return dropdownItems;
  // }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> pillBags =
        context.watch<PillBagStore>().pillBags; // 약 봉투 데이터
    print("@@@@@pillBags: $pillBags");
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
    List<Widget> filteredPillBagsWidgets = pillBags['result']
            // 주어진 조건을 만족하는지 확인하고, 그 조건을 만족하는 항목들만을 모아 새로운 리스트를 생성
            // ?. : null이 아닌 경우에만
            ?.where((pillBag) =>
                _selectedAccountSeq == null || // 모든 약 봉투 보기 선택 시
                pillBag['accountSeq'] ==
                    _selectedAccountSeq) // 특정 사용자의 약 봉투만 보기 선택 시
            .map<Widget>((pillBag) => _pillBagComponent(
                  // 위젯으로 변환
                  pillBag['medicineEnvelopSeq'],
                  pillBag['envelopName'],
                  pillBag['accountSeq'],
                  pillBag['nickname'],
                  pillBag['color'],
                ))
            .toList() ??
        []; // pillBags["result"] is null이면 빈 리스트를 반환

    return Scaffold(
      backgroundColor: Palette.BG_BLUE,
      appBar: AppBar(
        title: const Text(
          '약 봉투',
          style: TextStyle(
            color: Palette.MAIN_BLACK,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w500,
            fontSize: 16,
            backgroundColor: Palette.BG_BLUE,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _toggleDeleteMode, // 삭제 모드 토글 버튼
          ),
        ],
        backgroundColor: Palette.BG_BLUE,
        centerTitle: true,
        toolbarHeight: 55,
      ),
      // 약 봉투가 없을 때
      body: pillBags['count'] == 0
          ? const Center(
              child: Text(
                "약 봉투를 생성해주세요.",
                style: TextStyle(
                  color: Palette.SUB_BLACK,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            )
          // 약 봉투가 있을 때
          : SingleChildScrollView(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.02,
                  horizontal: MediaQuery.of(context).size.height * 0.03,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 돌보미 필터링 드롭다운 메뉴
                    if (accountList.length > 1)
                      Padding(
                        padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.height * 0.004,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            DropdownButton<int>(
                              value: _selectedAccountSeq,
                              items: dropdownItems,
                              onChanged: (value) {
                                setState(() {
                                  _selectedAccountSeq =
                                      value; // 선택된 accountSeq 업데이트
                                });
                              },
                              underline: Container(), // 드롭다운 메뉴의 밑줄 제거
                            ),
                          ],
                        ),
                      ),

                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Column(
                      children: [
                        // 필터링된 약 봉투 위젯 목록
                        if (filteredPillBagsWidgets.isNotEmpty)
                          ...filteredPillBagsWidgets
                        else
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // 가운데가 안 먹어
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
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
                  ],
                ),
              ),
            ),
      // 약 봉투 생성 or 삭제 버튼
      floatingActionButton: _isDeleteMode
          // 삭제 모드일 때
          ? Container(
              width: 45,
              height: 43,
              margin: const EdgeInsets.only(bottom: 10),
              child: FloatingActionButton(
                backgroundColor: Palette.MAIN_BLUE,
                elevation: 3,
                // 약 봉투 생성 버튼 클릭 시, 약 봉투 생성 다이얼로그 출력(medicineSeq는 그냥 다시 get road용)
                onPressed: () {
                  // @@ 진짜 삭제하시겠습니까? 다이얼로그 출력????
                  print("약 봉투 삭제 버튼 클릭");
                  // checkedPillBags에 있는 Seq들을 삭제
                  for (int medicineEnvelopSeq in _checkedPillBags) {
                    context
                        .read<PillBagStore>()
                        .deletePillBag(context, medicineEnvelopSeq);
                  }
                  _showSnackbar("약 봉투가 삭제되었습니다.", 'red');
                  // 삭제 모드 종료
                  _toggleDeleteMode();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 23,
                    ),
                  ],
                ),
              ),
            )
          // 삭제 모드가 아닐 때
          : Container(
              // width: 100,
              // height: 43,
              width: 45,
              height: 43,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
              ),
              margin: const EdgeInsets.only(bottom: 10),
              child: FloatingActionButton(
                backgroundColor: Palette.MAIN_BLUE,
                elevation: 3,
                // 약 봉투 생성 버튼 클릭 시, 약 봉투 생성 다이얼로그 출력(medicineSeq는 그냥 다시 get road용)
                onPressed: () {
                  print("약 봉투 생성 버튼 클릭");
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      // 실시간 반영을 위한 StatefulBuilder
                      return StatefulBuilder(builder: (context, setState) {
                        return const PillBagDialog(
                          medicineSeq: 0,
                        );
                      });
                    },
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 30,
                    ),
                  ],
                ),
              ),
            ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
