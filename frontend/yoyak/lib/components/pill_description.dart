// 알약 상세 정보에서의 상세 정보
import 'package:flutter/cupertino.dart';
import '../../styles/colors/palette.dart';

class PillDescription extends StatelessWidget {
  final String title;
  final String description;

  const PillDescription({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Palette.MAIN_BLACK,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
              fontSize: 17,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.width * 0.03),
          Text(
            description,
            style: const TextStyle(
              color: Palette.MAIN_BLACK,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
