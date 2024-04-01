import 'package:flutter/material.dart';
import 'package:yoyak/components/account_item.dart';
import 'package:yoyak/components/rounded_rectangle.dart';
import 'package:yoyak/models/user/account_models.dart';

class AccountList extends StatelessWidget {
  final List<AccountModel> accountList;

  const AccountList({
    super.key,
    required this.accountList,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: accountList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: RoundedRectangle(
            width: double.infinity,
            height: 80,
            boxShadow: const [],
            child: AccountItem(accountitem: accountList[index]),
          ),
        );
      },
      separatorBuilder: (context, index) => Container(),
    );
  }
}
