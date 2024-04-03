import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yoyak/apis/url.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:yoyak/components/congratulation_dialog.dart';
import 'package:yoyak/screen/Main/main_screen.dart';

class ChallengeStore extends ChangeNotifier {
  var yoyakUrl = API.yoyakUrl;
  dynamic myChallengeCard = [];
  int challengeSeq = 0;
  String challengeContent = "";
  List<dynamic> myChallengeList = [];
  List<dynamic> othersChallengeList = [];
  List<dynamic> allChallengeList = [];
  var accessToken = "";
  bool isCheered = false;
  bool showCongratulationDialog = false;

  Future getMyChallengeList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');
      var response = await http.get(Uri.parse('$yoyakUrl/challenge'), headers: {
        'Authorization': 'Bearer $accessToken',
      });

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
        print("챌린지 덱 목록 조회 시 오류 : ${response.body}");
      }
    } catch (error) {
      print(error);
    }
  }

  Future getMyChallenge(String? accessToken) async {
    try {
      print("내 챌린지 목록에서 accessToken 잘 들어오나: $accessToken");
      var response =
          await http.get(Uri.parse('$yoyakUrl/challenge/article/my'), headers: {
        'Authorization': 'Bearer $accessToken',
      });
      print(yoyakUrl);
      print(response.body);
      print(accessToken);

      if (response.statusCode == 200) {
        print("내 챌린지 게시글 조회 성공");
        print("내 챌린지 게시글 : $myChallengeList");
        myChallengeList = json.decode(utf8.decode(response.bodyBytes));
        myChallengeList = myChallengeList.reversed.toList();
        notifyListeners();
      } else {
        print("내 챌린지 목록 조회 실패");
      }
    } catch (error) {
      print(error);
    }
  }

  Future registChallenge(String name, DateTime startDate, DateTime endDate,
      BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      String? accessToken = prefs.getString('accessToken');
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
        getMyChallengeList();
        Navigator.of(context).pop();
      } else {
        print("챌린지 등록 실패");
      }
// DateTime(int.parse(year), int.parse(month), int.parse(day)).toIso8601String()
    } catch (error) {
      print(error);
      print("챌린지 등록 실패");
    }
  }

  Future<void> uploadDailyChallenge(context, image) async {
    final prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    var dto = MultipartFile.fromString(
      json.encode({
        "challengeSeq": challengeSeq,
        "content": challengeContent,
      }),
      contentType: MediaType.parse('application/json'),
    );
    print("챌린지 등록시 accessToken 있나? $accessToken");
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
        Navigator.of(context).pop();
        await getMyChallengeList();
        await getMyChallenge(accessToken);
        int finishedCnt = 0;
        for (int i = 0; i < myChallengeList.length; i++) {
          if (myChallengeList[i]['createdDate'] == myChallengeCard['endDate']) {
            finishedCnt++;
            print("finishedCnt : $finishedCnt");
          }
        }

        showCongratulationDialog = finishedCnt == 1;
        notifyListeners();
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
  Future getOthersChallenge(String? accessToken) async {
    try {
      print("다른 사람 챌린지 목록에서 accessToken 잘 들어오나: $accessToken");
      var response =
          await http.get(Uri.parse('$yoyakUrl/challenge/article'), headers: {
        'Authorization': 'Bearer $accessToken',
      });

      print("챌린지 둘러보기 리스트: ${response.body}");

      if (response.statusCode == 200) {
        print("챌린지 둘러보기 조회 성공");
        othersChallengeList = json.decode(utf8.decode(response.bodyBytes));
        othersChallengeList = othersChallengeList.reversed.toList();
        notifyListeners();
      } else {
        print("챌린지 둘러보기 조회 실패");
      }
    } catch (error) {
      print(error);
    }
  }

  // 비 로그인 시 챌린지 둘러보기 get
  Future getAllChallenge() async {
    try {
      var response =
          await http.get(Uri.parse('$yoyakUrl/challenge/article/all'));

      print("All 챌린지 둘러보기 리스트: ${response.body}");

      if (response.statusCode == 200) {
        print("All 챌린지 둘러보기 조회 성공");
        allChallengeList = json.decode(utf8.decode(response.bodyBytes));
        allChallengeList = allChallengeList.reversed.toList();
        notifyListeners();
      } else {
        print("All 챌린지 둘러보기 조회 실패");
      }
    } catch (error) {
      print(error);
    }
  }

  // 응원하기
  Future cheerUp(var articleSeq) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');
      var response =
          await http.put(Uri.parse("$yoyakUrl/challenge/article/cheer-up"),
              headers: {
                'Authorization': 'Bearer $accessToken',
                'Content-Type': 'application/json',
              },
              body: json.encode({
                "challengeArticleSeq": articleSeq,
              }));
      print(response.statusCode);
      if (response.statusCode == 200) {
        print("챌린지 응원하기 성공");
        isCheered = !isCheered;
      } else {
        print("챌린지 응원하기 실패");
      }
// DateTime(int.parse(year), int.parse(month), int.parse(day)).toIso8601String()
    } catch (error) {
      print(error);
      print("챌린지 등록 실패");
    }
  }

  void clearChallenges() {
    myChallengeList.clear();
    myChallengeCard.clear();
    othersChallengeList.clear();
    notifyListeners(); // UI에 변경사항을 알림
  }
}
