import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyak/store/challenge_store.dart';
import 'package:yoyak/styles/screenSize/screen_size.dart';
import '../styles/colors/palette.dart';

class ChallengeCard extends StatelessWidget {
  const ChallengeCard({super.key, this.challenge});
  final challenge;

  @override
  Widget build(BuildContext context) {
    var myChallengeCard = context.read<ChallengeStore>().myChallengeCard;
    double cardWidth = ScreenSize.getWidth(context) * 0.4;
    String curProgressDate = DateTime.parse(challenge?['createdDate']).difference(DateTime.parse(myChallengeCard['startDate'])).inDays.toString();
    return Padding(
      padding: const EdgeInsets.only(top: 15, right: 10),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(width: 0.4, color: Palette.SHADOW_GREY),
          ),
          width: cardWidth,
          // height: 270,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ), // 둥근 모서리 반경 설정
                child: Image.network(
                  challenge?['imgUrl'],
                  width: 200,
                  height: 110,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // 오류 발생 시 대체할 이미지
                    return Image.asset("assets/images/pillbox.jpg", width: 200, height: 110,);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      challenge?['title'] ?? "챌린지 이름",
                      style: const TextStyle(
                        color: Palette.MAIN_BLACK,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ), // 게시물 제목
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${int.parse(curProgressDate) + 1}일 차" ?? "챌린지 업로드 날짜",
                          style: TextStyle(
                            color: Palette.MAIN_BLUE.withOpacity(0.7),
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon(Icons.favorite_rounded, color: Palette.MAIN_RED.withOpacity(0.5),),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            "${challenge?['cheerCnt']}명이 응원했어요",
                            style: const TextStyle(
                              color: Palette.SUB_BLACK,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
