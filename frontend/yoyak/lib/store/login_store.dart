import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyak/apis/url.dart';
import 'package:http/http.dart' as http;
import 'package:yoyak/models/user/account_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginStore extends ChangeNotifier {
  dynamic userInfo = ""; // storage에 있는 유저 정보 저장
  List<AccountModel> accountList = [];
  var loginedUser;
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
      print('deviceToken: $deviceToken');
    });
  }

  // Future<void> testSave() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   var testId = prefs.getString('userId');
  //   var testPassword = prefs.getString('password');
  //   var accessToken = prefs.getString('accessToken');
  //
  //   print("testId : $testId");
  //   print("testPassword : $testPassword");
  //   print("accessToken $accessToken");
  // }

  Future<void> saveUserData(
      String userId, String password, String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', userId); // 정수 저장
    prefs.setString('password', password); // 불리언 저장
    prefs.setString('accessToken', token); // 문자열 저장
  }

  Future<void> saveAccountList(List<AccountModel> accountList) async {
    final prefs = await SharedPreferences.getInstance();
    // AccountModel 리스트를 JSON 문자열 리스트로 변환
    List<String> accountStringList =
        accountList.map((account) => jsonEncode(account.toJson())).toList();
    // 변환된 리스트를 SharedPreferences에 저장
    prefs.setStringList('accountList', accountStringList);
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

    var accessToken = response.body; // 액세스 토큰 저장
    if (response.statusCode == 200) {
      print("로그인 성공");
      // 로그인 성공 시 storage에 저장
      await saveUserData(email, password, accessToken);
      // 아이디, 비밀번호, accessToken 이 SharedPreference에 저장 완료
      notifyListeners();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => destination),
        (route) => false,
      );
      // return accessToken;
    } else {
      return false;
    }
  }

  Future<void> getAccountData() async {
    final prefs = await SharedPreferences.getInstance();
    String yoyakURL = API.yoyakUrl; // 서버 URL
    String url = '$yoyakURL/account'; // 요청할 URL
    try {
      String? accessToken = prefs.getString('accessToken');
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        var decodedBody = utf8.decode(response.bodyBytes);
        List<dynamic> data = json.decode(decodedBody);
        accountList = data.map((json) => AccountModel.fromJson(json)).toList();
        loginedUser = accountList.first;
        print('유저: ${response.body}.');

        notifyListeners();
      } else {
        print('유저 네임 받아오기 실패: ${response.statusCode}.');
      }
    } catch (error) {
      print(error);
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
