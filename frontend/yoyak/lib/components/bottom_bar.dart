import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screen/Login/login_screen.dart';
import '../screen/Main/main_screen.dart';
import '../styles/colors/palette.dart';
import 'dialog.dart';

class BottomBar extends StatefulWidget {
  const BottomBar(
      {super.key, this.curTabIdx, this.setCurTabIdx, this.mainTabs});

  final curTabIdx;
  final setCurTabIdx;
  final mainTabs;

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  bool isLogined = false;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        backgroundColor: Palette.MAIN_WHITE,
        selectedLabelStyle: const TextStyle(color: Colors.blueAccent),
        unselectedLabelStyle: const TextStyle(color: Color(0xFFD3D3D3)),
        showUnselectedLabels: false,
        showSelectedLabels: false,
        currentIndex: widget.curTabIdx,
        onTap: (i) async {
          widget.setCurTabIdx(i);
          final prefs = await SharedPreferences.getInstance();
          if (prefs.getString('accessToken')!.isNotEmpty) {
            setState(() {
              isLogined = true;
            });
          } else {
            setState(() {
              isLogined = false;
            });
          }
          if (i == 2 && !isLogined) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const DialogUI(
                  destination: LoginScreen(
                    destination: MainScreen(),
                  ),
                );
              },
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            label: '알람',
            backgroundColor: Palette.MAIN_WHITE,
            icon: Icon(Icons.alarm, color: Color(0xFFD3D3D3)),
            activeIcon: Icon(Icons.alarm, color: Colors.blueAccent),
          ),
          BottomNavigationBarItem(
            label: '홈',
            backgroundColor: Palette.MAIN_WHITE,
            icon: Icon(Icons.home, color: Color(0xFFD3D3D3)),
            activeIcon: Icon(Icons.home_filled, color: Colors.blueAccent),
          ),
          BottomNavigationBarItem(
            label: '챌린지',
            backgroundColor: Palette.MAIN_WHITE,
            icon: Icon(Icons.outlined_flag, color: Color(0xFFD3D3D3)),
            activeIcon: Icon(Icons.flag, color: Colors.blueAccent),
          ),
        ]);
  }
}
