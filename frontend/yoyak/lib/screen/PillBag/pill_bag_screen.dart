import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:yoyak/components/base_button.dart';
import 'package:yoyak/components/pill_bag_dialog.dart';
import 'package:yoyak/store/pill_bag_store.dart';
import 'package:yoyak/styles/colors/palette.dart';

class PillBagScreen extends StatefulWidget {
  const PillBagScreen({super.key});

  @override
  State<PillBagScreen> createState() => _PillBagScreenState();
}

class _PillBagScreenState extends State<PillBagScreen> {
  // 약 봉투 삭제
  final Set<int> _checkedPillBags = <int>{}; // 체크된 약 봉투 Seq
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
    // int accountSeq,
    String nickname,
    String color,
    // bool isSavedMedicine,
    // VoidCallback onClick,
  ) {
    bool isChecked =
        _checkedPillBags.contains(medicineEnvelopSeq); // 현재 약 봉투 항목이 선택되었는지 여부

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.only(bottom: 20),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Palette.SHADOW_GREY, width: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 삭제모드 - 약 봉투 체크박스 출력
          _isDeleteMode
              ? Checkbox(
                  value: isChecked, // 체크 여부
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _checkedPillBags
                            .add(medicineEnvelopSeq); // 체크하면 체크된 약 봉투 Seq에 추가
                      } else {
                        _checkedPillBags.remove(
                            medicineEnvelopSeq); // 체크 해제하면 체크된 약 봉투 Seq에서 제거
                      }
                    });
                  },
                )
              // 삭제모드가 아닐 때
              : Icon(
                  // Icons.folder_rounded,
                  Icons.folder_shared_outlined,
                  color: Color(int.parse(color)),
                  size: 30,
                ),

          Text(
            envelopName,
            style: const TextStyle(
              color: Palette.MAIN_BLACK,
              fontSize: 17,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500,
            ),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> pillBags = context.watch<PillBagStore>().pillBags;

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
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row(
              //   children: [
              //     Container(
              //       // padding: const EdgeInsets.only(left: 10),
              //       child: const Text(
              //         "약 봉투 목록",
              //         style: TextStyle(
              //             color: Palette.MAIN_BLACK,
              //             fontFamily: 'Pretendard',
              //             fontWeight: FontWeight.w700,
              //             fontSize: 24),
              //       ),
              //     ),
              //     const SizedBox(
              //       width: 10,
              //     ),
              //     // 봉투 이미지로 바꾸기
              //     Image.asset(
              //       'assets/images/pill.png',
              //       width: 30,
              //       height: 30,
              //     ),
              //     // 삭제 버튼 공간
              //     SizedBox(
              //       width: MediaQuery.of(context).size.width * 0.21,
              //     ),
              //     // 버튼 스타일 바꾸기!!!
              //     // 삭제 상태면 삭제 -> 확인
              //     BaseButton(
              //       onPressed: () {},
              //       text: "삭제",
              //       colorMode: "white",
              //       width: 85,
              //       height: 35,
              //     )
              //   ],
              // ),
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
                        // pillBag['accountSeq'],
                        pillBag['nickname'],
                        pillBag['color'],
                        // pillBag['isSavedMedicine'],
                        //     () {
                        //       // 약 봉투 클릭 시 이벤트
                        //       // Navigator.pushNamed(context, '/pillBagDetail');
                        //     },
                      )
                ],
              ),
            ],
          ),
        ),
      ),
      // 약 봉투 생성 버튼
      floatingActionButton: Container(
        width: 100,
        height: 43,
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
          child: const Padding(
            padding: EdgeInsets.only(right: 4.6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: Colors.white, size: 23),
                Text(
                  '약 봉투',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
