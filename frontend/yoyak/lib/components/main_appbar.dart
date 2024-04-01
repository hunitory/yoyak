import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyak/auto_login/singleton_secure_storage.dart';
import 'package:yoyak/models/user/account_models.dart';
import 'package:yoyak/screen/Login/kakao_login_screen.dart';
import 'package:yoyak/screen/Mypage/mypage_screen.dart';
import 'package:yoyak/store/login_store.dart';

import 'main_appbar_button.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key, this.color});

  final Color? color; // 색상 타입을 명확히 지정합니다.

  @override
  Size get preferredSize => const Size.fromHeight(10 + kToolbarHeight);

  Future<String?> getAccessToken() async {
    var storage = SingletonSecureStorage().storage;
    var accessToken = await storage.read(key: 'accessToken');
    return accessToken;
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: false,
      backgroundColor: color,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset("assets/images/logo.png"),
          FutureBuilder<String?>(
            future: getAccessToken(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data == null) {
                  // 토큰이 없을 경우 로그인 버튼을 표시합니다.
                  return MainAppBarButton(
                      text: "로그인",
                      width: 90,
                      height: 36,
                      fontSize: 15,
                      colorMode: 'white',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const KakaoLoginScreen(),
                          ),
                        );
                      });
                } else {
                  // 토큰이 있을 경우 프로필 이미지를 표시합니다.
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MypageScreen()));
                    },
                    child: SizedBox(
                      width: 35,
                      height: 35,
                      child: Image.asset("assets/images/person2.png"),
                    ),
                  );
                }
              } else {
                // 데이터를 기다리는 동안 로딩 인디케이터를 표시할 수 있습니다.
                return const CircularProgressIndicator();
              }
            },
          ),
        ],
      ),
    );
  }
}
