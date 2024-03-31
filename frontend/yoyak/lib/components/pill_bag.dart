import 'package:flutter/material.dart';
import 'package:yoyak/styles/colors/palette.dart';

class PillBag extends StatefulWidget {
  final String envelopName;
  final int medicineSeq; // 필요한가? 해당 약이 들어있는지 check할 때 사용
  final int accountSeq;
  final String nickname;
  final String color;
  final bool isSavedMedicine; // 해당 약이 들어있는지 true/false로 check
  final VoidCallback onClick; // 선택 시 실행할 콜백 함수

  const PillBag({
    super.key,
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
  late bool isSavedMedicine; // 상태 관리

  @override
  void initState() {
    super.initState();
    isSavedMedicine = widget.isSavedMedicine; // 초기값을 위젯에서 받아옴
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.only(bottom: 5),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Palette.SHADOW_GREY, width: 0.5),
        ),
      ),
      child: ListTile(
        leading: Transform.scale(
          scale: 1.5, // 체크박스 크기 조절
          child: Checkbox(
            value: isSavedMedicine,
            // 체크 박스
            onChanged: (bool? value) {
              // 체크박스 클릭할때마다 상태 변경
              // api 연결해서 수정하기 !
              setState(() {
                isSavedMedicine = value!;
              });
              widget.onClick(); // 부모 위젯에 이벤트 알림
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            side: const BorderSide(
              color: Palette.SHADOW_GREY,
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
                border: Border.all(color: Color(int.parse(widget.color))),
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
