import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yoyak/models/user/account_models.dart';
import 'package:yoyak/screen/Mypage/updateaccount_Screen.dart';
import 'package:yoyak/styles/colors/palette.dart';

class AccountItem extends StatefulWidget {
  final AccountModel accountitem;

  const AccountItem({
    super.key,
    required this.accountitem,
  });

  @override
  State<AccountItem> createState() => _AccountItemState();
}

class _AccountItemState extends State<AccountItem> {
  void goToAccountUpdate(AccountModel accountitem) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateAccountScreen(
          accountitem: widget.accountitem,
          isUser: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        goToAccountUpdate(widget.accountitem);
      },
      child: Container(
        width: 70,
        height: 70,
        decoration: const BoxDecoration(
          color: Palette.MAIN_WHITE,
          border: Border(
            bottom: BorderSide(
              color: Palette.SUB_WHITE,
              width: 1.0,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Image(
                    width: 50,
                    height: 50,
                    image: AssetImage(
                        'assets/images/profiles/profile${widget.accountitem.profileImg}.png'),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    widget.accountitem.nickname ?? '없음',
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'pretendard',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
