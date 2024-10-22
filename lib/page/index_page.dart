import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_manage_client/common/constant.dart';
import 'package:time_manage_client/models/category_model/category_model.dart';
import 'package:time_manage_client/page/category/category.dart';
import 'package:time_manage_client/page/mine/mine.dart';
import 'package:time_manage_client/page/statistics/statistics.dart';
import 'package:time_manage_client/page/task/task.dart';
import 'package:time_manage_client/router/nav_ctrl.dart';
import 'package:time_manage_client/router/routes.dart';
import 'package:time_manage_client/utils/index.dart';
import 'package:time_manage_client/widget/main_button.dart';
import 'package:time_manage_client/widget/tips_widget.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final ValueNotifier<int> _pageIndex = ValueNotifier<int>(0);
  late final PageController _pagecontroller;
  String? token;

  @override
  void initState() {
    super.initState();
    _pagecontroller = PageController(initialPage: _pageIndex.value);
    token = StorageUtil.get(Constant.TOKEN);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pagecontroller,
        children: !token.isEmptyOrNull
            ? <Widget>[
                const Task(),
                Category(parent: CategoryModel()),
                const Statistics(),
                const Mine(),
              ]
            : _buildNoLogin(context),
      ),
      bottomNavigationBar: ValueListenableBuilder<int>(
          valueListenable: _pageIndex,
          builder: (BuildContext context, int valueIndex, _) {
            return BottomNavigationBar(
              currentIndex: valueIndex,
              items: _buildTabbarList,
              onTap: (int value) {
                _pageIndex.value = value;
                _pagecontroller.jumpToPage(value);
              },
            );
          }),
    );
  }

  List<Widget> _buildNoLogin(BuildContext context) {
    return <Widget>[
      Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TipsWidget(
              icon: Icon(
                Icons.gpp_maybe_outlined,
                size: 48.w,
              ),
              tip: context.locale.loginTip,
            ),
            SizedBox(height: 16.w),
            MainButton(
              text: context.locale.login,
              onPressed: () {
                NavCtrl.push(Routes.login);
              },
            )
          ],
        ),
      ),
    ];
  }

  List<BottomNavigationBarItem> get _buildTabbarList {
    return <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: const Icon(Icons.account_balance_outlined),
        label: context.locale.task,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.layers_outlined),
        label: context.locale.category,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.monitor_heart_outlined),
        label: context.locale.statistics,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.settings_outlined),
        label: context.locale.mine,
      ),
    ];
  }
}
