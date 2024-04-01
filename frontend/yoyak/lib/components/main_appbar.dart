import 'package:flutter/material.dart';
import 'package:yoyak/screen/Mypage/mypage_screen.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key, this.color});
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset("assets/images/logo.png"),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const MypageScreen()));
              },
              child: SizedBox(
                  width: 30,
                  height: 30,
                  child: Image.asset("assets/images/person-image.png")),
            ),
          ],
        ));
  }
}
