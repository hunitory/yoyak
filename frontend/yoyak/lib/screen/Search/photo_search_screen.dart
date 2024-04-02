import 'package:flutter/material.dart';
import 'package:yoyak/components/base_button.dart';
import 'dart:io';
import 'package:yoyak/components/rounded_rectangle.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:yoyak/screen/Search/photo_result_screen.dart';
import 'package:yoyak/store/camera_store.dart';
import '../../styles/colors/palette.dart';
import 'package:lottie/lottie.dart';

class PhotoSearchScreen extends StatefulWidget {
  const PhotoSearchScreen({super.key});

  @override
  State<PhotoSearchScreen> createState() => _PhotoSearchScreenState();
}

class _PhotoSearchScreenState extends State<PhotoSearchScreen> {
  // 로딩 다이얼로그
  Future<void> showLoadingDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // 다른 곳을 터치해도 닫히지 않음
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Palette.WHITE_BLUE,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  'assets/lotties/loading.json',
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.15,
                  height: MediaQuery.of(context).size.height * 0.10,
                  fit: BoxFit.fill,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                const Text(
                  "AI로 분석하는 중입니다..",
                  style: TextStyle(
                      color: Palette.MAIN_BLACK,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w700,
                      fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 초기 데이터 로드
  @override
  void initState() {
    super.initState();
    // 이미지변수 초기화
    // context.read<CameraStore>().clearImage();
    // 프레임이 렌더링된 직후에 코드가 실행
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CameraStore>().clearImage();
    });
  }

  @override
  Widget build(BuildContext context) {
    var sendImageToServer = context.read<CameraStore>().sendImageToServer;
    var getImage = context.read<CameraStore>().getImage; // 이미지를 가져오는 함수를 가져오기
    var image = context.watch<CameraStore>().image;
    var photoResults = context.watch<CameraStore>().photoResults;

    double rectangleWidth = MediaQuery.of(context).size.width * 0.8;
    double rectangleHeight = MediaQuery.of(context).size.width * 0.5;

    return Scaffold(
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
      body: Container(
        width: double.infinity,
        color: Palette.BG_BLUE,
        padding: const EdgeInsets.all(40),
        // padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: const Text(
                "사진으로 알약 검색",
                style: TextStyle(
                    color: Palette.MAIN_BLACK,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w700,
                    fontSize: 24),
              ),
            ),
            const Text(
              "인식률을 높이기 위해, ",
              style: TextStyle(
                  color: Palette.MAIN_BLACK,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                  fontSize: 14),
            ),
            const Text(
              "밝은 곳에서 알약의 문자가 잘 보이게 촬영해 주세요.",
              style: TextStyle(
                  color: Palette.MAIN_BLACK,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                  fontSize: 14),
            ),
            // 가이드 사진
            Container(
              margin: const EdgeInsets.only(top: 30, bottom: 40),
              child: RoundedRectangle(
                width: rectangleWidth,
                height: rectangleHeight,
                boxShadow: const [
                  BoxShadow(
                    color: Palette.SHADOW_GREY,
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  )
                ],
                // 가이드 사진 && 사진 미리보기
                child: image != null // 사용자가 사진을 선택한 후!
                    ? Image.file(File(image.path))
                    : const Image(
                        image: AssetImage('assets/images/guide.png'),
                      ),
              ),
            ),
            // 이미지, 카메라 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  margin: const EdgeInsets.only(),
                  child: Column(
                    children: [
                      RoundedRectangle(
                        width: MediaQuery.of(context).size.width * 0.30,
                        height: MediaQuery.of(context).size.width * 0.30,
                        boxShadow: const [
                          BoxShadow(
                            color: Palette.SHADOW_GREY,
                            blurRadius: 3,
                            offset: Offset(0, 2),
                          )
                        ],
                        child: Center(
                          // 이미지 크기 조절
                          child: Image.asset(
                            'assets/images/mountain.png',
                            width: rectangleHeight * 0.45,
                            fit: BoxFit.cover,
                          ),
                        ),
                        onTap: () {
                          print("갤러리 열기");
                          getImage(ImageSource.gallery);
                        },
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "이미지 업로드",
                        style: TextStyle(
                            color: Palette.MAIN_BLACK,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  margin: const EdgeInsets.only(),
                  child: Column(
                    children: [
                      RoundedRectangle(
                          width: MediaQuery.of(context).size.width * 0.30,
                          height: MediaQuery.of(context).size.width * 0.30,
                          boxShadow: const [
                            BoxShadow(
                              color: Palette.SHADOW_GREY,
                              blurRadius: 3,
                              offset: Offset(0, 2),
                            )
                          ],
                          child: Center(
                            child: Image.asset(
                              'assets/images/camera.png',
                              fit: BoxFit.cover,
                              width: rectangleHeight * 0.45,
                            ),
                          ),
                          onTap: () {
                            print("카메라 열기");
                            getImage(ImageSource.camera);
                            // 데이터가 담기면 다음 페이지로 이동
                          }),
                      const SizedBox(height: 10),
                      const Text(
                        "촬영하기",
                        style: TextStyle(
                            color: Palette.MAIN_BLACK,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            //  검색하기 버튼
            if (image != null) ...[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.06,
              ),
              Center(
                child: BaseButton(
                  onPressed: () async {
                    // 로딩 다이얼로그 표시
                    showLoadingDialog(context);
                    // 함수가 완료 될 때까지 기다렸다가 결과 페이지로 이동 async await
                    await sendImageToServer(context);

                    // 로딩 다이얼로그 닫기
                    Navigator.of(context).pop();
                    // 약 검색 결과 담기면 사진 결과 페이지로 이동 -> sendImageToServer 에서 네비게이터까지 처리
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PhotoResultScreen(
                                  photoResults: photoResults,
                                )));

                    // 결과페이지로 이동하면 원래 img는 초기화
                    image = null;
                  },
                  text: "검색하기",
                  colorMode: "white",
                ),
              )
            ],
          ],
        ),
      ),
    );
  }
}
