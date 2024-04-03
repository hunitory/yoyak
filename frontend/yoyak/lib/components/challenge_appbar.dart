import 'package:flutter/material.dart';
import '../styles/colors/palette.dart';

class ChallengeaAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChallengeaAppBar({super.key, this.color});

  final color;

  @override
  Size get preferredSize => const Size.fromHeight(10 + kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: color,
        elevation: 0,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.asset("assets/images/logo.png"),
            Text(
              '챌린지',
              style: TextStyle(
                color: Palette.MAIN_BLACK,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
            // 챌린지 등록을 안했다면


          ],
        ));
  }
}
