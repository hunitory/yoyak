import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyak/apis/url.dart';
import 'package:yoyak/store/login_store.dart';

class PillBagStore extends ChangeNotifier {
  Map<String, dynamic> pillBag = {}; // 약 봉투 목록
  final storage = FlutterSecureStorage();

  Future<void> getPillBagDatas(BuildContext context) async {
    String yoyakURL = API.yoyakUrl; // 서버 URL
    String? accessToken = await storage.read(key: 'accessToken');
    String url = '$yoyakURL/medicineEnvelop'; // path

    // API 호출
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        print("약 봉투 데이터 api 호출 성공");
        var decodedBody = utf8.decode(response.bodyBytes);
        // Map<String, dynamic>으로 변환
        // API 호출 결과를 pillBag에 저장
        pillBag = json.decode(decodedBody); // type이 맞나?
        // 상태변경 업데이트
        notifyListeners();
        print("약 봉투 데이터 api 호출 성공 잘 담김 : $pillBag.");
      } else {
        // 오류 처리
        print('약 봉투 데이터 api 오류 ${response.statusCode}, $response');
      }
    } catch (error) {
      // 예외 처리
      print('약 봉투 데이터 api 에러 $error');
    }
  }

  // 약 봉투 생성 api
  Future<void> createPillBag(
      BuildContext context, int accountSeq, String name) async {
    String yoyakURL = API.yoyakUrl; // 호스트 URL
    String? accessToken = await storage.read(key: 'accessToken');
    String url = '$yoyakURL/medicineEnvelop'; // path
    // 색상 리스트
    List<String> colors = [
      "0XffBED1CF",
      "0xffE78895",
      "0xffBBE2EC",
      "0xffFFE4C9"
    ];

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode({
          "accountSeq": accountSeq,
          "name": name,
          // 남은 일 : color
          // @
          //color 어떻게 바꾸지?
          "color": colors[accountSeq % 4],
        }),
      );

      if (response.statusCode == 200) {
        print("약 봉투 생성 성공");
        Navigator.pop(context);
      } else {
        print("약 봉투 생성 실패: ${response.body}");
      }
    } catch (e) {
      print("약 봉투 생성 에러: $e");
    }
  }
}
