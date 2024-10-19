import 'package:flutter/material.dart';
import 'package:time_manage_client/page/category/category.dart';
import 'package:time_manage_client/page/mine/mine.dart';
import 'package:time_manage_client/page/statistics/statistics.dart';
import 'package:time_manage_client/page/task/task.dart';
import 'package:time_manage_client/utils/string_util.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final ValueNotifier<int> _pageIndex = ValueNotifier<int>(0);
  late final PageController _pagecontroller;

  @override
  void initState() {
    super.initState();
    _pagecontroller = PageController(initialPage: _pageIndex.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pagecontroller,
        children: const <Widget>[
          Task(),
          Category(),
          Statistics(),
          Mine(),
        ],
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
