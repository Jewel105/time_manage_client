import 'package:flutter/material.dart';
import 'package:time_manage_client/common/constant.dart';
import 'package:time_manage_client/router/nav_ctrl.dart';
import 'package:time_manage_client/router/routes.dart';
import 'package:time_manage_client/utils/index.dart';
import 'package:time_manage_client/widget/main_button.dart';

class Mine extends StatelessWidget {
  const Mine({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.locale.mine),
      ),
      body: Column(
        children: <Widget>[
          Container(),
          MainButton(
            text: "Log Out",
            onPressed: () async {
              await StorageUtil.remove(Constant.TOKEN);
              NavCtrl.switchTab(Routes.home);
            },
          )
        ],
      ),
    );
  }
}
