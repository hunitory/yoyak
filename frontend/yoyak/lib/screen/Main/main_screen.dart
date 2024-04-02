import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyak/components/bottom_bar.dart';
import 'package:yoyak/main.dart';
import 'package:yoyak/screen/Alarm/alarm_screen.dart';
import 'package:yoyak/screen/Challenge/challenge_screen.dart';
import 'package:yoyak/store/alarm_store.dart';
import 'package:yoyak/store/login_store.dart';
import '../Home/home_screen.dart';

// MainScreen
// - AlarmScreen, HomeScreen, ChallengeScreen을 담고 있는 Screen
// BottomBar를 여기에 둬서 사용자가 탭할 때 index를 변화시켜 이동시킬 것임
// bottomBar는 재사용성을 위해 Component로 뺐음.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var curTabIdx = 1;
  final mainTabs = [
    const AlarmScreen(),
    const HomeScreen(),
    const ChallengeScreen(),
  ];

  // tabIdx 수정
  setCurTabIdx(int idx) {
    setState(() {
      print(idx);
      curTabIdx = idx;
    });
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      print("알림 권한이 거부되었습니다");
    }
  }

  @override
  void initState() {
    super.initState();
    requestPermission();
    setupFirebaseMessaging();
  }

  @override
  Widget build(BuildContext context) {
    context.read<LoginStore>().getAccountData();
    context.read<AlarmStore>().getAlarmDatas(context);
    context.read<LoginStore>().getDeviceToken();
    return Scaffold(
      body: mainTabs[curTabIdx],
      bottomNavigationBar: BottomBar(
        curTabIdx: curTabIdx,
        setCurTabIdx: setCurTabIdx,
        mainTabs: mainTabs,
      ),
    );
  }
}
