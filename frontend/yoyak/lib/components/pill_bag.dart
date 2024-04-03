import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyak/store/pill_bag_store.dart';
import 'package:yoyak/styles/colors/palette.dart';

class PillBag extends StatefulWidget {
  final int medicineEnvelopSeq;
  final String envelopName;
  final int medicineSeq; // 필요한가? 해당 약이 들어있는지 check할 때 사용
  final int accountSeq;
  final String nickname;
  final String color;
  bool isSavedMedicine; // 해당 약이 들어있는지 true/false로 check
  final VoidCallback onClick; // 선택 시 실행할 콜백 함수

  PillBag({
    super.key,
    required this.medicineEnvelopSeq,
    required this.envelopName,
    required this.medicineSeq,
    required this.accountSeq,
    required this.nickname,
    required this.color,
    required this.isSavedMedicine,
    required this.onClick,
  });

  @override
  State<PillBag> createState() => _PillBagState();
}

class _PillBagState extends State<PillBag> {
  late bool ischecked; // 체크되어있는지 여부

  @override
  void initState() {
    super.initState();
    ischecked = widget.isSavedMedicine; // 초기값을 위젯에서 받아옴
  }

  // 약이 봉투에 저장되어있는지 check toggle
  Future<void> _toggleSavedMedicine(bool value) async {
    // 약 저장 (value가 true일 때)
    if (value) {
      // 약 저장하는 post 요청
      context.read<PillBagStore>().saveMedicine(
            context,
            widget.accountSeq,
            widget.medicineSeq,
            widget.medicineEnvelopSeq,
          );
      print(
          "어카운트 : ${widget.accountSeq}, 메디슨 :${widget.medicineSeq}, 약 봉투: ${widget.medicineEnvelopSeq}");
    } else {
      // 체크되어있을 때는 약 삭제하는 delete 요청
      context.read<PillBagStore>().deleteMedicine(
            context,
            widget.accountSeq,
            widget.medicineSeq,
            widget.medicineEnvelopSeq,
          );
    }

    // 상태 업데이트 (체크박스 상태 변경)
    setState(() {
      ischecked = value;
      widget.isSavedMedicine = ischecked;
    });
    print("흠흠 : widget.isSavedMedicine : ${widget.isSavedMedicine}");
    // 부모 위젯에 이벤트 알림
    widget.onClick();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      // padding: const EdgeInsets.only(bottom: 5),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Palette.MAIN_BLACK, width: 0.1),
        ),
      ),
      child: ListTile(
        leading: Transform.scale(
          scale: 1.5, // 체크박스 크기 조절
          child: Checkbox(
            // value: ischecked,
            value: context
                .watch<PillBagStore>()
                .isMedicineSaved(widget.medicineEnvelopSeq),
            // 체크 박스
            // 필터 변경 시 PillBagModal 내부에서 상태가 업데이트
            onChanged: (bool? value) {
              _toggleSavedMedicine(value!);
              context
                  .read<PillBagStore>()
                  .toggleSavedMedicine(widget.medicineEnvelopSeq, value);
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            side: const BorderSide(
              color: Palette.SUB_BLACK,
              width: 1,
            ),
            activeColor: Palette.MAIN_BLUE,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        // title: Text(widget.envelopName),
        // subtitle: Text(widget.nickname),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.envelopName,
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
                  color: Color(int.parse(widget.color)),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                widget.nickname,
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
}
