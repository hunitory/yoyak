import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyak/components/bottom_bar.dart';
import 'package:yoyak/main.dart';
import 'package:yoyak/screen/Alarm/alarm_screen.dart';
import 'package:yoyak/screen/Challenge/challenge_screen.dart';
import 'package:yoyak/store/alarm_store.dart';
import 'package:yoyak/store/login_store.dart';
import '../../store/challenge_store.dart';
import '../Home/home_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  final storage = const FlutterSecureStorage(); // FlutterSecureStorage storage 저장

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

  void requestPermission() async{
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
    if(settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      String? deviceToken = await messaging.getToken();
    }else{
      print("알림 권한이 거부되었습니다");
    }
  }

  @override
  void initState() {
    super.initState();
    requestPermission();
    setupFirebaseMessaging();
    // 비동기로 flutter secure storage 정보를 불러오는 작업
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  _asyncMethod() async {
    // read 함수로 key값에 맞는 정보를 불러오고 데이터타입은 String 타입
    // 데이터가 없을때는 null을 반환
    dynamic userInfo = context.read<LoginStore>().userInfo = await storage.read(key:'accessToken');
    // user의 정보가 있다면 로그인 후 들어가는 첫 페이지로 넘어가게 합니다.
    if (userInfo != null) {
      print("로그인된 상태입니다. 자동 로그인 성공");
      print(userInfo);
    } else {
      print('로그인 풀렸어요 자동 로그인 실패');
    }
  }

  @override
  Widget build(BuildContext context) {
    String accessToken = context.read<LoginStore>().accessToken;
    context.read<LoginStore>().getAccountData();
    context.read<AlarmStore>().getAlarmDatas(context);
    context.read<LoginStore>().getDeviceToken();
    context.read<ChallengeStore>().getMyChallengeList(accessToken);
    print(context.read<LoginStore>().accessToken);
    print("device 토큰 : ${context.read<LoginStore>().deviceToken}");

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
