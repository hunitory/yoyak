import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:yoyak/apis/url.dart';
import 'package:http/http.dart' as http;
import 'package:yoyak/models/user/account_models.dart';

class LoginStore extends ChangeNotifier {
  dynamic userInfo = ""; // storage에 있는 유저 정보 저장
  final storage = const FlutterSecureStorage();
  List<AccountModel> alarmAccounts = [];

  String accessToken = '';
  String? deviceToken = "";

  var UserDetail; // 회원정보 페이지에 뿌려줄 데이터

  // 회원가입 정보
  String userName = '성현';
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

    print(response.body);
    var accessToken = response.body; // 액세스 토큰 저장
    if (response.statusCode == 200) {
      print("로그인 성공");
      context
          .read<LoginStore>()
          .setAccessToken(accessToken); // provider에 받은 토큰 저장

      storage.deleteAll(); // 기존 토큰 삭제
      storage.write(key: 'accessToken', value: accessToken); // accessToken 저장
      storage.write(key: 'deviceToken', value: deviceToken); // deviceToken 저장
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

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        print('유저야 ${response.statusCode}.');
        var decodedBody = utf8.decode(response.bodyBytes);
        List<dynamic> data = json.decode(decodedBody);
        alarmAccounts =
            data.map((json) => AccountModel.fromJson(json)).toList();
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
}
