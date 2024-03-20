import 'package:flutter/material.dart';
import 'package:yoyak/components/MainAppBar.dart';
import 'package:yoyak/components/RoundedRectangle.dart';
import 'package:yoyak/screen/Alarm/alarm_screen.dart';
import 'package:yoyak/styles/colors/palette.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double rectangleSize = MediaQuery.of(context).size.width * 0.44;

    return Scaffold(
      appBar: const MainAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: screenWidth,
              height: 180,
              color: Colors.blueAccent,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "성현님 건강하세요",
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Pretendard',
                      ),
                    ),
                    RichText(
                        text: const TextSpan(children: [
                      TextSpan(
                        text: '오늘 드실 약은 ',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                      TextSpan(
                        text: '3개',
                        style: TextStyle(
                          fontSize: 23,
                          color: Colors.yellow,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                      TextSpan(
                        text: '에요',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                    ])),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.blueAccent,
              child: Container(
                  decoration: BoxDecoration(
                    color: Palette.BG_BLUE,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    border: Border.all(
                      width: 0.1,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                  ),
                  width: screenWidth,
                  height: 560,
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 40),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),
                          RoundedRectangle(
                              width: rectangleSize,
                              height: rectangleSize,
                              onTap: () => (),
                              child: Container(
                                child: const Text(""),
                              )),
                          const Spacer(),
                          RoundedRectangle(
                              width: rectangleSize,
                              height: rectangleSize,
                              onTap: () => (),
                              child: Container(
                                child: const Text(""),
                              )),
                          const Spacer(),
                        ],
                      ),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
