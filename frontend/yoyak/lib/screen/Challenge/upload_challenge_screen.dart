import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:yoyak/components/base_button.dart';
import 'package:yoyak/store/challenge_store.dart';
import 'package:yoyak/store/login_store.dart';
import 'package:yoyak/styles/screenSize/screen_size.dart';
import '../../store/camera_store.dart';
import '../../styles/colors/palette.dart';

class UploadChallengeScreen extends StatefulWidget {
  const UploadChallengeScreen({super.key});

  @override
  State<UploadChallengeScreen> createState() => _UploadChallengeScreenState();
}

class _UploadChallengeScreenState extends State<UploadChallengeScreen> {
  String content = '';
  TextEditingController challengeContentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var image = context.watch<CameraStore>().image;
    var accessToken = context.read<LoginStore>().accessToken;
    return Scaffold(
        appBar: AppBar(
          leading: const Icon(Icons.arrow_back_ios, size: 24),
          title: const Text(
            "챌린지 업로드",
            style: TextStyle(
              color: Palette.MAIN_BLACK,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20,),
              image != null
                  ? Center(
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: ScreenSize.getWidth(context) * 0.8,
                        maxHeight: ScreenSize.getWidth(context) * 0.7,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          File(image.path),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  )
                  : Lottie.asset('assets/lotties/loading.json',
                      width: 120, height: 120),
              const SizedBox(height: 40,),
              // 글 쓰는 곳
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20), // 아래 라인 제거를 위해 top 제외
                child: Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 30), // 내용물과 외곽선 사이에 간격 추가
                  child: TextField(
                    controller: challengeContentController,
                    onChanged: (value) {
                      setState(() {
                        content = challengeContentController.text;
                      });
                    },
                    keyboardType: TextInputType.multiline, // 여러 줄 입력 가능하도록 설정
                    maxLines: null, // null로 설정하면 자동으로 줄의 개수에 맞게 텍스트 필드 크기 조절
                    decoration: const InputDecoration.collapsed(
                      hintText: '간단히 설명해주세요...', // 힌트 텍스트
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      bottomNavigationBar: BottomAppBar(
        color: Palette.MAIN_WHITE,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BaseButton(
            onPressed: () {
              context.read<ChallengeStore>().challengeContent = content; // 챌린지 업로드 내용 저장
              // 일일 챌린지 업로드 함수 호출
              context.read<ChallengeStore>().uploadDailyChallenge(context, image, accessToken);
            },
            text: "완료",
            colorMode: "BLUE",
            width: ScreenSize.getWidth(context),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
