import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yoyak/models/user/account_models.dart';
import 'package:yoyak/screen/Login/login_screen.dart';
import 'package:yoyak/screen/Mypage/mypage_screen.dart';
import 'package:yoyak/store/login_store.dart';
import 'main_appbar_button.dart';

class MainAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MainAppBar({super.key, this.color});

  final Color? color;

  @override
  State<MainAppBar> createState() => _MainAppBarState();

  @override
  Size get preferredSize => throw UnimplementedError();
}

class _MainAppBarState extends State<MainAppBar> with WidgetsBindingObserver {
  String accessToken = '';

  Size get preferredSize => const Size.fromHeight(10 + kToolbarHeight);

  @override
  void initState() {
    super.initState();
    loadUserData();
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      accessToken =
          prefs.getString('accessToken') ?? ''; // accessToken state 업데이트
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print('resumed123');
        break;
      case AppLifecycleState.inactive:
        print('inactive123');
        break;
      case AppLifecycleState.detached:
        print('detached123');
        // DO SOMETHING!
        break;
      case AppLifecycleState.paused:
        print('paused123');
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    loadUserData();
    LoginStore loginStore = context.read<LoginStore>();
    Widget profileWidget; // 사용자 프로필 위젯

    if (loginStore.accountList.isNotEmpty) {
      // 로그인 상태일 때
      AccountModel account = loginStore.accountList[0];
      profileWidget = GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MypageScreen()),
          );
        },
        child: SizedBox(
          width: 35,
          height: 35,
          child: Image.asset(
              "assets/images/profiles/profile${account.profileImg}.png"),
        ),
      );
    } else {
      profileWidget = GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        },
        child: SizedBox(
          width: 35,
          height: 35,
          child: Image.asset("assets/images/person1.png"),
        ),
      );
    }
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: false,
      backgroundColor: widget.color,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset("assets/images/logo.png"),
          if (accessToken.isEmpty) // 로그인 여부에 따라 다른 위젯을 표시
            MainAppBarButton(
                text: "로그인",
                width: 90,
                height: 36,
                fontSize: 15,
                colorMode: 'white',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                })
          else
            profileWidget
        ],
      ),
    );
  }
}
