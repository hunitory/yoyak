import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingStore extends ChangeNotifier {
  // 테스트용
  Future<void> showLoadingDialogCuper(BuildContext context) async {
    return showCupertinoDialog(
      context: context,
      barrierDismissible: false, // 다른 곳을 터치해도 닫히지 않음
      builder: (BuildContext context) {
        return const Center(
          child: CupertinoActivityIndicator(),
        );
      },
    );
  }

  Future<void> showLoadingDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // 다른 곳을 터치해도 닫히지 않음
      builder: (BuildContext context) {
        return Dialog(
            child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/lotties/loading.json',
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.750,
                height: MediaQuery.of(context).size.height * 0.40,
                // fit: BoxFit.fill,
              ),
              const SizedBox(
                width: 20,
              ),
              const Text("로딩 중..."),
            ],
          ),
        ));
      },
    );
  }
}
