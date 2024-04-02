import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:yoyak/screen/Login/social_login.dart';

class KakaoLogin extends StatelessWidget implements SocialLogin {
  const KakaoLogin({super.key});

  @override
  Future<bool> login() async {
// 카카오톡 설치 여부 확인
// 카카오톡이 설치되어 있으면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
    if (await isKakaoTalkInstalled()) {
      try {
        var kakaoToken = await UserApi.instance.loginWithKakaoTalk();

        print('카카오톡 설치된 경우 카카오톡으로 로그인 성공');
        print("이게 accessTOken: ${kakaoToken.accessToken}");
        return true;
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');

        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          return false;
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          var abc = await UserApi.instance.loginWithKakaoAccount();
          print('aaaa카카오계정으로 로그인 성공');
          print(abc.accessToken);
          return true;
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
          return false;
        }
      }
    } else {
      try {
        var kakaoToken = await UserApi.instance.loginWithKakaoAccount();
        print('카톡 설치 안됐을 때 카카오계정으로 로그인 성공');
        print(kakaoToken.accessToken);
        // sendKakaoId(kakaoToken);

        return true;
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
        return false;
      }
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await UserApi.instance.unlink();
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
