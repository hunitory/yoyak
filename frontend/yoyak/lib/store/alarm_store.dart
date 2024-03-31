import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyak/apis/url.dart';
import 'package:yoyak/models/alarm/alarm_models.dart';
import 'package:yoyak/store/login_store.dart';

class AlarmStore extends ChangeNotifier {
  List<AlarmModel> alarms = [];

  Future<void> getAlarmDatas(BuildContext context) async {
    String yoyakURL = API.yoyakUrl; // 서버 URL
    String accessToken = context.read<LoginStore>().accessToken;
    String url = '$yoyakURL/noti/time'; // 요청할 URL

    try {
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
        alarms = data.map((json) => AlarmModel.fromJson(json)).toList();
        notifyListeners();
      } else {
        // 오류 처리
        print('알림 데이터야 ${response.statusCode}.');
      }
    } catch (error) {
      // 예외 처리
      print('알림 데이터야 $error');
    }
  }
}
