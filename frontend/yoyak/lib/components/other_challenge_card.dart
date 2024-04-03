import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yoyak/components/all_challenge_card.dart';
import 'package:yoyak/components/rounded_rectangle.dart';
import 'package:yoyak/styles/screenSize/screen_size.dart';
import '../store/challenge_store.dart';
import '../styles/colors/palette.dart';
import 'look_around_challenge_card.dart';

class OtherChallengeCard extends StatefulWidget {
  const OtherChallengeCard(
      {super.key,
      this.subTitle,
      this.title,
      this.imagePath,
      this.titleImagePath});

  final subTitle, title, imagePath, titleImagePath;

  @override
  State<OtherChallengeCard> createState() => _OtherChallengeCardState();
}

class _OtherChallengeCardState extends State<OtherChallengeCard> with WidgetsBindingObserver {
  String accessToken = '';

  Future<void> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      accessToken =
          prefs.getString('accessToken') ?? ''; // accessToken state 업데이트
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    double cardListWidth = MediaQuery.of(context).size.width * 0.9;
    var othersChallengeList = context.watch<ChallengeStore>().othersChallengeList;
    var allChallengeList = context.watch<ChallengeStore>().allChallengeList;
    context.watch<ChallengeStore>().isCheered;
    // 응원했으면 배경 색, 글씨 색 바꾸기
    return RoundedRectangle(
      width: ScreenSize.getWidth(context),
      height: 400,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (widget.subTitle != null)
            Text(
              "${widget.subTitle}",
              style: const TextStyle(
                  fontFamily: "Pretendard",
                  color: Palette.SUB_BLACK,
                  fontWeight: FontWeight.w500,
                  fontSize: 15),
            ),
          Row(
            children: [
              Text(
                "${widget.title}",
                style: const TextStyle(
                    fontFamily: "Pretendard",
                    color: Palette.MAIN_BLACK,
                    fontWeight: FontWeight.w600,
                    fontSize: 19),
              ),
              if (widget.titleImagePath != null)
                Image.asset(
                  widget.titleImagePath,
                  width: 50,
                  height: 50,
                ),
            ],
          ),
          // Spacer 제거 또는 SizedBox로 변경
          const SizedBox(height: 10), // 예시로 추가한 SizedBox
          if (widget.imagePath != null)
            Image.asset(
              widget.imagePath,
              width: 70,
              height: 70,
            ),

          // 챌린지 시작했을 때, 안했을 때 분기
          SizedBox(
            width: cardListWidth,
            height: 290,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: accessToken != '' ? othersChallengeList.length : allChallengeList.length, // 개수 고치기 배열의 길이로
                itemBuilder: (context, i) {
                  if (accessToken != '') {
                    return LookAroundChallengeCard(
                        challenge: othersChallengeList[i]);
                  } else {
                    return AllChallengeCard(
                        challenge: allChallengeList[i]);
                  }
                }),
          )
        ]),
      ),
    );
  }
}
