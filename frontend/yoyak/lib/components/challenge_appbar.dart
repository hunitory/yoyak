import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:yoyak/components/dialog.dart';
import 'package:yoyak/hooks/goto_screen.dart';
import 'package:yoyak/screen/Challenge/regist_challenge_screen.dart';
import 'package:yoyak/screen/Challenge/upload_challenge_screen.dart';
import 'package:yoyak/screen/Login/login_screen.dart';
import 'package:yoyak/screen/Mypage/mypage_screen.dart';
import 'package:yoyak/store/login_store.dart';

import '../store/camera_store.dart';
import '../store/challenge_store.dart';
import '../styles/colors/palette.dart';
import 'base_button.dart';

class ChallengeaAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChallengeaAppBar({super.key, this.color});

  final color;

  @override
  Size get preferredSize => const Size.fromHeight(10 + kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    var storage = context.read<LoginStore>().storage;
    var getImageAndNavigate = context.read<CameraStore>().getImageAndNavigate;
    Map<dynamic, dynamic> myChallengeCard = context.watch<ChallengeStore>().myChallengeCard;
    return AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: color,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset("assets/images/logo.png"),

            // 챌린지 등록을 안했다면

            myChallengeCard.isEmpty
                ? GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MypageScreen()));
                    },
                    child: SizedBox(
                        width: 120,
                        height: 33,
                        child: BaseButton(
                          height: 40,
                          fontSize: 15,
                          onPressed: () {
                            // print("tqtqtqtq: ${storage.read(key: 'accessToken')}");
                            storage.read(key: 'accessToken') != null ? goToScreen(context, const RegistChallengeScreen()) // 로그인 되어있다면
                                : showDialog(context: context, builder: (context) { // 로그인 안되어있을 경우
                                  return const DialogUI(destination: LoginScreen(destination: RegistChallengeScreen(),),);
                            });
                          },
                          text: "시작하기",
                          colorMode: 'white',
                          borderWidth: 1.0,
                          borderRadius: BorderRadius.circular(20),
                        )),
                  )
                : GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MypageScreen()));
                    },
                    child: SizedBox(
                        width: 130,
                        height: 33,
                        child: BaseButton(
                          height: 40,
                          fontSize: 15,
                          onPressed: () {
                            // 모달 창 나옴
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    height: 170,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 20),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              // 사진 촬영 기능 구현
                                              getImageAndNavigate(
                                                  ImageSource.camera, context);
                                            },
                                            child: const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '사진 촬영',
                                                  style: TextStyle(
                                                    color: Palette.MAIN_BLUE,
                                                    fontFamily: 'Pretendard',
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 19,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const Divider(
                                          height: 0.1,
                                          color: Palette.SHADOW_GREY,
                                        ),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              // 이미지 업로드 기능 구현
                                              getImageAndNavigate(
                                                  ImageSource.gallery, context);
                                              // Navigator.pop(context);
                                            },
                                            child: const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '이미지 업로드',
                                                  style: TextStyle(
                                                    color: Palette.MAIN_BLUE,
                                                    fontFamily: 'Pretendard',
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 19,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          },
                          text: "챌린지 올리기",
                          colorMode: 'white',
                          borderWidth: 1.0,
                          borderRadius: BorderRadius.circular(20),
                        )),
                  )
          ],
        ));
  }
}
