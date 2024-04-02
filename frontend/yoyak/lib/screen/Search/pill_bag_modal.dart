import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:yoyak/components/rounded_rectangle.dart';
import 'package:yoyak/components/pill_bag.dart';
import 'package:yoyak/store/login_store.dart';
import 'package:yoyak/store/pill_bag_store.dart';
import 'package:yoyak/styles/screenSize/screen_size.dart';
import '../../styles/colors/palette.dart';
import 'package:yoyak/components/pill_bag_dialog.dart';

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
  @override
  Widget build(BuildContext context) {
    // 약 봉투 리스트 가져오기
    var pillBags = context.watch<PillBagStore>().pillBags;
    List<dynamic> pillBagList = pillBags["result"] ?? [];

    print('모달 pillBagList: $pillBags');
    print('다시 빌드?');

    // @ 모달 자체를 scroll 못하나?
    return RoundedRectangle(
      width: double.infinity,
      height: widget.sceenHeight * 0.75,
      color: Palette.MAIN_WHITE,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(
                    width: 50,
                  ),
                  const Text(
                    "약 봉투에 저장하기",
                    style: TextStyle(
                      color: Palette.MAIN_BLACK,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                    ),
                  ),
                  // const SizedBox(
                  //   width: 70,
                  // ),
                  // 클릭 시, 약 봉투 생성
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
                            return PillBagDialog(
                              medicineSeq: widget.medicineSeq,
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
              const SizedBox(
                height: 40,
              ),
              // 돌보미 필터

              // 약 봉투 리스트
              // @ 없을 때 분기 처리하기
              SizedBox(
                height: widget.sceenHeight * 0.35,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (pillBags["count"] != 0)
                        for (var pillBag in pillBagList)
                          PillBag(
                            medicineEnvelopSeq: pillBag["medicineEnvelopSeq"],
                            envelopName: pillBag["envelopName"],
                            medicineSeq: widget.medicineSeq,
                            accountSeq: pillBag["accountSeq"],
                            nickname: pillBag["nickname"],
                            isSavedMedicine: pillBag["isSavedMedicine"],
                            // 컬러코드로 받기
                            color: pillBag["color"],
                            onClick: () {
                              // 약 봉투에 저장하기 함수..?
                              print('클릭');
                            },
                          )
                      else
                        Column(
                          children: [
                            SizedBox(
                              height: ScreenSize.getHeight(context) * 0.1,
                            ),
                            const Center(
                              child: Text(
                                "등록된 약 봉투가 없어요.",
                                style: TextStyle(
                                  color: Palette.SUB_BLACK,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
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
