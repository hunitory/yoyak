import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyak/apis/url.dart';
import 'package:http/http.dart' as http;
import 'package:yoyak/models/user/account_models.dart';
import '../auto_login/singleton_secure_storage.dart';

class LoginStore extends ChangeNotifier {
  dynamic userInfo = ""; // storage에 있는 유저 정보 저장
  final storage = SingletonSecureStorage().storage;
  List<AccountModel> accountList = [];

  String accessToken = '';
  String? deviceToken = "";

  var UserDetail; // 회원정보 페이지에 뿌려줄 데이터

  // 회원가입 정보
  String userName = '';
  String userEmail = '';
  String password = '';

  // 생년 월일
  String year = '';
  String month = '';
  String day = '';

  // 성별 : enum Type / 남자 : 'MAN', 여자 : 'WOMAN'
  String gender = '';
  String platform = 'ORIGIN';

  // device token 가져오기
  void getDeviceToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      deviceToken = token;
    });
  }

  Future login(BuildContext context, String email, String password,
      Widget destination) async {
    String url = "${API.yoyakUrl}/user/login/origin"; // 바꾸기
    print('$email $password');

    var response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'userId': email,
          'password': password,
          'deviceToken': context.read<LoginStore>().deviceToken,
        }));

    print('너 뭔데 정체가 ${response.body}');
    var accessToken = response.body; // 액세스 토큰 저장
    if (response.statusCode == 200) {
      // 로그인 성공 시 storage에 저장
      await storage.write(key: 'userId', value: email);
      await storage.write(key: 'password', value: password);
      await storage.write(key: 'accessToken', value: accessToken);
      // await storage.write(
      //     key: 'userNickname', value: userInfo['nickname']); // 수정 가능성 있음

      var tmpToken = await storage.read(key: 'accessToken');
      setAccessToken(tmpToken); // provider에 받은 토큰 저장

      storage.deleteAll(); // 기존 토큰 삭제
      storage.write(key: 'accessToken', value: accessToken); // accessToken 저장
      notifyListeners();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => destination),
        (route) => false,
      );
      // return accessToken;
    } else {
      print("회원정보가 없는경우");
      throw Error();
    }
  }

  Future<void> getAccountData() async {
    String yoyakURL = API.yoyakUrl; // 서버 URL
    String url = '$yoyakURL/account'; // 요청할 URL
    final storage = SingletonSecureStorage().storage;
    try {
      String? accesstoken = await storage.read(key: 'accessToken');
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accesstoken',
        },
      );

      if (response.statusCode == 200) {
        var decodedBody = utf8.decode(response.bodyBytes);
        List<dynamic> data = json.decode(decodedBody);
        accountList = data.map((json) => AccountModel.fromJson(json)).toList();
        await storage.write(
            key: 'userName',
            value: accountList.first.nickname); // storage에 유저 닉네임 저장
        notifyListeners();
      } else {
        // 오류 처리
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (error) {
      // 예외 처리
      print('An error occurred: $error');
    }
  }

  Future signUp(BuildContext context) async {
    print("회원가입 요청");
    String url = "${API.yoyakUrl}/user/signin"; // 회원가입 요청 url
    print('$userEmail $password $userName');

    var response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'userId': userEmail,
          'password': password,
          'name': userName,
          'nickname': userName,
          'gender': gender,
          'birth': DateTime(int.parse(year), int.parse(month), int.parse(day))
              .toIso8601String(),
          'platform': platform, // 카카오면 KAKAO, 일반이면 ORIGIN
        }));
    print("$userEmail $password $userName $gender $year $month $day $platform");
    print(response.statusCode);
    if (response.statusCode == 200) {
      print("회원가입 요청 성공");
    } else {
      print("회원가입 요청 실패");
      print(response.body);
      throw Error();
    }
  }

  setGender(String str) {
    gender = str;
  }

  setYear(String str) {
    year = str;
  }

  setMonth(String str) {
    month = str;
  }

  setDay(String str) {
    day = str;
  }

  setAccessToken(token) {
    accessToken = token;
    notifyListeners();
  }

  void clearAccounts() {
    accountList.clear();
    notifyListeners(); // UI에 변경사항을 알림
  }
}
