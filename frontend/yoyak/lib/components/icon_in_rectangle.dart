import 'package:flutter/material.dart';
import '../styles/colors/palette.dart';

class IconInRectangle extends StatelessWidget {
  const IconInRectangle({super.key, this.subTitle, this.title, this.imagePath});
  final subTitle, title, imagePath;

  @override
  Widget build(BuildContext context) {
    double cardListWidth = MediaQuery.of(context).size.width * 0.85;
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("$subTitle", style: const TextStyle(
                fontFamily: "Pretendard",
                color: Palette.SUB_BLACK,
                fontWeight: FontWeight.w500,
                fontSize: 15),),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("$title", style: const TextStyle(
                    fontFamily: "Pretendard",
                    color: Palette.MAIN_BLACK,
                    fontWeight: FontWeight.w600,
                    fontSize: 19),),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset(imagePath, width: 70, height: 70,),
              ],
            )
            // Container(
            //   width: cardListWidth,
            //   height: 250,
            //   child: ListView.builder(
            //     scrollDirection: Axis.horizontal,
            //       shrinkWrap: true,
            //       itemCount: 6, // 개수 고치기 배열의 길이로
            //       itemBuilder: (context, i) {
            //         return ChallengeCard();
            //       }
            //   ),
            // )

          ]
      ),
    );
  }
}
