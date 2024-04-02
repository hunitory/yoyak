import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:yoyak/components/pill_bag_dialog.dart';
import 'package:yoyak/screen/PillBag/pill_bag_detail_screen.dart';
import 'package:yoyak/store/pill_bag_store.dart';
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

  void _toggleDeleteMode() {
    // 삭제 모드 토글
    setState(() {
      _isDeleteMode = !_isDeleteMode;
      _checkedPillBags.clear(); // 삭제 모드를 끄면 체크된 약 봉투 항목 초기화
    });
    print("삭제 모드: $_isDeleteMode");
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

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> pillBags = context.watch<PillBagStore>().pillBags;
    print("@@@@@pillBags: $pillBags");

    return Scaffold(
      backgroundColor: Palette.BG_BLUE,
      appBar: AppBar(
        title: const Text(
          '내 약 봉투',
          style: TextStyle(
            color: Palette.MAIN_BLACK,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w500,
            fontSize: 16,
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
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        if (pillBags['count'] != 0)
                          for (var pillBag in pillBags['result'])
                            _pillBagComponent(
                              pillBag['medicineEnvelopSeq'],
                              pillBag['envelopName'],
                              pillBag['accountSeq'],
                              pillBag['nickname'],
                              pillBag['color'],
                            )
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
