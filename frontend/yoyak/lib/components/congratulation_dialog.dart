import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../styles/colors/palette.dart';

class CongratulationDialogUI extends StatelessWidget {
  const CongratulationDialogUI({super.key, required this.destination});
  final Widget destination;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Palette.MAIN_WHITE,
      child: Container(
        width: 300,
        height: 400,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Lottie.asset('assets/lotties/congratulation.json',
                width: 120, height: 120),
            const SizedBox(height: 30),
            const Text(
              '챌린지를 완료했어요!\n 항상 건강하세요!',
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
                    backgroundColor: Palette.MAIN_BLUE,
                  ),
                  child: const Text(
                    '확인하기',
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
