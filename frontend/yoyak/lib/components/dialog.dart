import 'package:flutter/material.dart';
import '../hooks/goto_screen.dart';
import '../styles/colors/palette.dart';

class DialogUI extends StatelessWidget {
  const DialogUI({super.key, required this.destination});
  final Widget destination;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Container(
        width: 300,
        height: 200,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              '로그인이 필요한 서비스입니다.\n 로그인 하시겠어요?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Palette.MAIN_BLACK,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
                fontSize: 17,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Palette.SUB_BLACK,
                  ),
                  child: const Text(
                    '아니요',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // 로그인 처리
                    goToScreen(context, destination);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Palette.MAIN_BLUE,
                  ),
                  child: const Text(
                    '로그인하기',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
