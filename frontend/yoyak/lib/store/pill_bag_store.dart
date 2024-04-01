import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyak/apis/url.dart';
import 'package:yoyak/auto_login/singleton_secure_storage.dart';
import 'package:yoyak/store/login_store.dart';

class PillBagStore extends ChangeNotifier {
  Map<String, dynamic> pillBags = {}; // 약 봉투 목록
  var storage = SingletonSecureStorage().storage;

  // 약 봉투 목록 가져오기 api
  Future<void> getPillBagDatas(BuildContext context, {int? medicineSeq}) async {
    String yoyakURL = API.yoyakUrl; // 서버 URL
    String modifiedUrl = yoyakURL.substring(8, yoyakURL.length - 4);
    String path = '/api/medicineEnvelop'; // path
    String? accessToken = await storage.read(key: 'accessToken');

    print("modified  : $modifiedUrl");
    print(accessToken);

    final uri = Uri.https(modifiedUrl, path, {"medicineSeq": "$medicineSeq"});
    // final uri = Uri.https(
    //     "192.168.219.100:8080", path, {"medicineSeq": "$medicineSeq"});

    // print("api 어디로감 ... : $uri");

    // API 호출
    try {
      final response = await http.get(
        // Uri.parse(url),
        uri,
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
        // pillBagList = json.decode(decodedBody); // type이 맞나?
        pillBags = jsonDecode(decodedBody); // type이 맞나?

        // 상태변경 업데이트
        notifyListeners();
        // print("쿼리잘갔니? : $medicineSeq");
        // print("주소를 보자!!!! : $uri");
        // print("약 봉투 데이터 api 호출 성공 잘 담김 : $pillBags.");
        print("되니.... : ${pillBags.runtimeType}");
        print("되니.... : $pillBags");
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
    BuildContext context,
    int accountSeq,
    String name,
  ) async {
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
        notifyListeners(); // 상태 변경
      } else {
        print("약 봉투 생성 실패: ${response.body}");
      }
    } catch (e) {
      print("약 봉투 생성 에러: $e");
    }
  }

  // 약 봉투 약 저장 api
  Future<void> saveMedicine(
    BuildContext context,
    int accountSeq,
    int medicineSeq,
    int envelopeSeq,
  ) async {
    String yoyakURL = API.yoyakUrl; // 호스트 URL
    String? accessToken = await storage.read(key: 'accessToken');
    String url = '$yoyakURL/medicineSaved'; // path

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode({
          "accountSeq": accountSeq,
          "medicineSeq": medicineSeq,
          "envelopeSeq": envelopeSeq,
        }),
      );

      if (response.statusCode == 200) {
        print("약 저장 성공");
        // 약 봉투 목록 다시 불러오기 -
        await getPillBagDatas(context, medicineSeq: medicineSeq);
        print('약봉투 목록 다시 불러왔나? - 저장');
      } else {
        print("약 저장 실패: ${response.body}");
        print("어카운트 : $accountSeq, 메디슨 :$medicineSeq, 약 봉투 이름: $envelopeSeq");
      }
    } catch (e) {
      print("약 저장 에러: $e");
    }
    notifyListeners(); //  상태 변경
  }

  // 약 봉투 약 삭제 api
  Future<void> deleteMedicine(
    BuildContext context,
    int accountSeq,
    int medicineSeq,
    int envelopeSeq,
  ) async {
    String yoyakURL = API.yoyakUrl; // 호스트 URL
    String? accessToken = await storage.read(key: 'accessToken');
    String url = '$yoyakURL/medicineSaved'; // path

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode({
          "accountSeq": accountSeq,
          "medicineSeq": medicineSeq,
          "envelopeSeq": envelopeSeq,
        }),
      );

      if (response.statusCode == 200) {
        print("약 삭제 성공");
        await getPillBagDatas(context, medicineSeq: medicineSeq);
        print('약봉투 목록 다시 불러왔나? - 삭제');
      } else {
        print("약 삭제 실패: ${response.body}");
      }
    } catch (e) {
      print("약 삭제 에러: $e");
    }
    notifyListeners();
  }

  // 약 봉투 삭제 api
  Future<void> deletePillBag(
    BuildContext context,
    int medicineEnvelopSeq,
  ) async {
    String yoyakURL = API.yoyakUrl; // 호스트 URL
    String? accessToken = await storage.read(key: 'accessToken');
    String url = '$yoyakURL/medicineEnvelop/$medicineEnvelopSeq'; // path

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        print("약 봉투 삭제 성공");
        await getPillBagDatas(context, medicineSeq: 0);
        print('약봉투 목록 다시 불러왔나? - 약 봉투 삭제');
      } else {
        print("약 봉투 삭제 실패: ${response.body}");
      }
    } catch (e) {
      print("약 봉투 삭제 에러: $e");
    }
    notifyListeners();
  }

  // 약 봉투 저장된 약 목록 조회 api
  Future<void> getPillBagDetail(
    BuildContext context,
    int medicineEnvelopSeq,
  ) async {
    String yoyakURL = API.yoyakUrl; // 호스트 URL
    String? accessToken = await storage.read(key: 'accessToken');
    String url = '$yoyakURL/medicineEnvelop/$medicineEnvelopSeq'; // path

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        print("약 봉투 저장된 약 목록 조회 성공 : ${response.body}");
      } else {
        print("약 봉투 저장된 약 목록 조회 오류: ${response.body}");
      }
    } catch (e) {
      print("약 봉투 저장된 약 목록 조회 에러: $e");
    }
    notifyListeners();
  }
}
