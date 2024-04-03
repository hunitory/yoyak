import 'package:flutter/material.dart';
import 'package:yoyak/styles/colors/palette.dart';

class SelectedDay extends StatefulWidget {
  final String day;
  final List<String> selectedDays;

  const SelectedDay({
    super.key,
    required this.day,
    required this.selectedDays,
  });

  @override
  State<SelectedDay> createState() => _SelectedDayState();
}

class _SelectedDayState extends State<SelectedDay> {
  late bool isSelected;

  @override
  void initState() {
    super.initState();
    isSelected = widget.selectedDays.contains(widget.day);
  }

  void toggleSelection() {
    setState(() {
      isSelected = !isSelected;
    });

    if (isSelected) {
      widget.selectedDays.add(widget.day);
    } else {
      widget.selectedDays.remove(widget.day);
    }
  }

  @override
  Widget build(BuildContext context) {
    String displayText = getDayLabel(widget.day);

    return GestureDetector(
      onTap: toggleSelection,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        // 애니메이션 지속 시간 설정
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: isSelected ? Palette.MAIN_BLUE : Palette.WHITE_BLUE,
        ),
        child: Center(
          child: Text(
            displayText,
            style: TextStyle(
              color: isSelected ? Palette.MAIN_WHITE : Palette.MAIN_BLACK,
              fontSize: 16,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  String getDayLabel(String day) {
    switch (day) {
      case 'MONDAY':
        return '월';
      case 'TUESDAY':
        return '화';
      case 'WEDNESDAY':
        return '수';
      case 'THURSDAY':
        return '목';
      case 'FRIDAY':
        return '금';
      case 'SATURDAY':
        return '토';
      case 'SUNDAY':
        return '일';
      default:
        return '';
    }
  }
}
