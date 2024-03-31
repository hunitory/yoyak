import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:yoyak/apis/url.dart';
import 'package:http/http.dart' as http;
import 'package:yoyak/hooks/goto_screen.dart';
import 'package:yoyak/screen/Main/main_screen.dart';
import 'package:http_parser/http_parser.dart';

class ChallengeStore extends ChangeNotifier {
  var yoyakUrl = API.yoyakUrl;
  dynamic myChallengeCard = {};
  bool hasOwnChallenge = false; // 챌린지 시작했는지 여부
  int challengeSeq = 0;
  String challengeContent = "";
  List<dynamic> myChallengeList = [];
  List<dynamic> othersChallengeList = [];
  setHasOwnChallenge() {
    hasOwnChallenge = true;
  }

  Future getMyChallengeList(accessToken) async {
    try {
      var response = await http.get(Uri.parse('$yoyakUrl/challenge'), headers: {
        'Authorization': 'Bearer $accessToken',
      });
      print(yoyakUrl);
      print(response.body);
      print(accessToken);

      if (response.statusCode == 200) {
        print("내 챌린지 덱 조회 성공");
        var responseBody = utf8.decode(response.bodyBytes);
        myChallengeCard = json.decode(responseBody);
        challengeSeq = myChallengeCard['challengeSeq'];
        print('챌린지 덱: $myChallengeCard');
        print('챌린지 시퀀스: $challengeSeq');

        notifyListeners();
      } else {
        print("내 챌린지 덱 목록 조회 실패");
        hasOwnChallenge = false;
      }
    } catch (error) {
      print(error);
    }
  }

  Future getMyChallenge(accessToken) async {
    try {
      var response =
          await http.get(Uri.parse('$yoyakUrl/challenge/article/my'), headers: {
        'Authorization': 'Bearer $accessToken',
      });
      print(yoyakUrl);
      print(response.body);
      print(accessToken);

      if (response.statusCode == 200) {
        print("내 챌린지 게시글 조회 성공");
        myChallengeList = json.decode(utf8.decode(response.bodyBytes));
        notifyListeners();
      } else {
        print("내 챌린지 목록 조회 실패");
      }
    } catch (error) {
      print(error);
    }
  }

  Future registChallenge(String name, DateTime startDate, DateTime endDate,
      String accessToken, BuildContext context) async {
    try {
      String startMonth = "${startDate.month}".padLeft(2, "0");
      String startDay = "${startDate.day}".padLeft(2, "0");
      String endMonth = "${endDate.month}".padLeft(2, "0");
      String endDay = "${endDate.day}".padLeft(2, "0");

      var response = await http.post(Uri.parse("$yoyakUrl/challenge"),
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'title': name,
            'startDate': '${startDate.year}-$startMonth-$startDay',
            'endDate': '${endDate.year}-$endMonth-$endDay',
          }));
      print(response.statusCode);
      if (response.statusCode == 200) {
        print("챌린지 등록 성공");
        setHasOwnChallenge();
        goToScreen(context, const MainScreen());
      } else {
        print("챌린지 등록 실패");
      }
// DateTime(int.parse(year), int.parse(month), int.parse(day)).toIso8601String()
    } catch (error) {
      print(error);
      print("챌린지 등록 실패");
    }
  }

  Future<void> uploadDailyChallenge(context, image, String accessToken) async {
    var dto = MultipartFile.fromString(
      json.encode({
        "challengeSeq": challengeSeq,
        "content": challengeContent,
      }),
      contentType: MediaType.parse('application/json'),
    );

    var dio = Dio();
    MultipartFile file =
        MultipartFile.fromFileSync(image.path, filename: image.name);

    var formData = FormData.fromMap(
      {"image": file, "challengeArticleCreateDto": dto},
      ListFormat.multiCompatible,
    );

    try {
      dio.options.maxRedirects.isFinite;

      var response = await dio.post(
        '$yoyakUrl/challenge/article',
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
        }),
        data: formData,
      );

      if (response.statusCode == 200) {
        print("일일 챌린지 등록 성공");
        print("일일 챌린지 등록 후 내 챌린지 리스트:  $myChallengeList");
        goToScreen(context, const MainScreen());
      } else {
        print("일일 챌린지 등록 실패");
        // 응답 본문을 출력하기 위해 response.stream을 bytes로 변환한 후, 문자열로 디코딩합니다.
      }

      return response.data;
    } catch (error) {
      print(error);
    }
  }

  // 챌린지 둘러보기 get
  Future getOthersChallenge(accessToken) async {
    try {
      var response =
      await http.get(Uri.parse('$yoyakUrl/challenge/article'), headers: {
        'Authorization': 'Bearer $accessToken',
      });

      print("챌린지 둘러보기 리스트: ${response.body}");

      if (response.statusCode == 200) {
        print("챌린지 둘러보기 조회 성공");
        othersChallengeList = json.decode(utf8.decode(response.bodyBytes));
        notifyListeners();
      } else {
        print("챌린지 둘러보기 조회 실패");
      }
    } catch (error) {
      print(error);
    }
  }



}
