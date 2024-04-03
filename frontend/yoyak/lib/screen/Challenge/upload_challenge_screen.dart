import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:yoyak/components/base_button.dart';
import 'package:yoyak/store/challenge_store.dart';
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

    void showSnackbar(String message, String color) {
      final snackbar = SnackBar(
        backgroundColor: color == 'red' ? Palette.MAIN_RED : Palette.MAIN_BLUE,
        content: Text(
          message,
          style: const TextStyle(
            color: Palette.MAIN_WHITE,
            fontSize: 14,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w400,
          ),
        ),
        duration: const Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 24),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
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
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
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
                      maxLines: 1, // null로 설정하면 자동으로 줄의 개수에 맞게 텍스트 필드 크기 조절
                      maxLength: 8,
                      decoration: const InputDecoration.collapsed(
                        hintText: '한 줄 설명...', // 힌트 텍스트
                      ),
                      // 엔터 키를 누를 때 포커스 해제
                      onSubmitted: (_) {
                        FocusScope.of(context).unfocus();
                      },

                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      bottomNavigationBar: BottomAppBar(
        color: Palette.MAIN_WHITE,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BaseButton(
            onPressed: () {
              context.read<ChallengeStore>().challengeContent =
                  content; // 챌린지 업로드 내용 저장
              // 일일 챌린지 업로드 함수 호출
              context
                  .read<ChallengeStore>()
                  .uploadDailyChallenge(context, image);
              showSnackbar("챌린지가 등록되었습니다.", 'blue');
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
