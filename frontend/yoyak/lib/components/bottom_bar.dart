import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedLabelStyle: const TextStyle(color: Colors.blueAccent),
        unselectedLabelStyle: const TextStyle(color: Color(0xFFD3D3D3)),
        showUnselectedLabels: false,
        showSelectedLabels: false,
        currentIndex: widget.curTabIdx,
        onTap: (i) {
          widget.setCurTabIdx(i);
        },
        items: const [
          BottomNavigationBarItem(
            label: '알람',
            backgroundColor: Colors.white,
            icon: Icon(Icons.alarm, color: Color(0xFFD3D3D3)),
            activeIcon: Icon(Icons.alarm, color: Colors.blueAccent),
          ),
          BottomNavigationBarItem(
            label: '홈',
            backgroundColor: Colors.white,
            icon: Icon(Icons.home, color: Color(0xFFD3D3D3)),
            activeIcon: Icon(Icons.home_filled, color: Colors.blueAccent),
          ),
          BottomNavigationBarItem(
            label: '챌린지',
            backgroundColor: Colors.white,
            icon: Icon(Icons.outlined_flag, color: Color(0xFFD3D3D3)),
            activeIcon: Icon(Icons.flag, color: Colors.blueAccent),
          ),
        ]);
  }
}
