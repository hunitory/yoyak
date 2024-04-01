import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../styles/colors/palette.dart';

class PillBagDetailScreen extends StatefulWidget {
  const PillBagDetailScreen({super.key});

  @override
  State<PillBagDetailScreen> createState() => _PillBagDetailScreenState();
}

class _PillBagDetailScreenState extends State<PillBagDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.BG_BLUE,
      appBar: AppBar(
        title: const Text(
          '알약 검색',
          style: TextStyle(
            color: Palette.MAIN_BLACK,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        backgroundColor: Palette.BG_BLUE,
        centerTitle: true,
        toolbarHeight: 55,
      ),
    );
  }
}
