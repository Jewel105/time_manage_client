import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:time_manage_client/common/app_color.dart';
import 'package:time_manage_client/utils/index.dart';
import 'package:time_manage_client/widget/tips_widget.dart';

typedef RefreshCallback = Future<void> Function();
typedef LoadMoreCallback = Future<void> Function();

class ListViewWrapper<T> extends StatefulWidget {
  final PageApiCall<T> pageApiCall;
  final IndexedWidgetBuilder itemBuilder;
  final bool shrinkWrap; // 是否反转滚动
  final double? itemExtent;
  final ScrollController? controller;
  final Widget? skeleton; // 刚刚加载时显示骨架屏
  final Widget? bottomWidget; // 底部widget
  final Widget? noDataWidget; // 底部widget
  final Color? backgroundColor; // 背景色

  const ListViewWrapper({
    super.key,
    required this.pageApiCall,
    required this.itemBuilder,
    this.shrinkWrap = true,
    this.controller,
    this.itemExtent,
    this.skeleton,
    this.bottomWidget,
    this.noDataWidget,
    this.backgroundColor,
  });

  @override
  State<ListViewWrapper<T>> createState() => _ListViewWrapperState<T>();
}

class _ListViewWrapperState<T> extends State<ListViewWrapper<T>> {
  late final ScrollController _controller;
  // 是否显示浮动按钮
  final ValueNotifier<bool> _showFloatingButton = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? ScrollController();
    // 监听滚动条位置
    _controller.addListener(() {
      if (_controller.offset > 800) {
        if (!_showFloatingButton.value) {
          _showFloatingButton.value = true;
        }
      } else {
        if (_showFloatingButton.value) {
          _showFloatingButton.value = false;
        }
      }
    });
  }

  Widget createListWidget() {
    int itemCount = widget.pageApiCall.items.length;
    return RefreshIndicator(
      onRefresh: () async {
        widget.pageApiCall.refresh();
        setState(() {});
        await widget.pageApiCall.loadMore();
        setState(() {});
      },
      child: Scrollbar(
          controller: _controller,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: widget.shrinkWrap,
            controller: _controller,
            itemExtent: widget.itemExtent, // 每个块的大小，使拖动滚动条更平滑
            itemCount: itemCount + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == itemCount) {
                if (widget.pageApiCall.hasMore) {
                  widget.pageApiCall.loadMore().then((_) {
                    setState(() {});
                  });
                  if (itemCount == 0 && widget.skeleton != null) {
                    return widget.skeleton;
                  }
                  return SpinKitThreeInOut(
                    color: AppColor.appMainColor,
                    size: 20.w,
                  );
                } else if (itemCount == 0) {
                  return widget.noDataWidget ??
                      Padding(
                        padding: EdgeInsets.only(top: 32.h),
                        child: TipsWidget(
                          icon: Icon(
                            Icons.no_backpack_outlined,
                            size: 40.w,
                          ),
                          tip: context.locale.noData,
                        ),
                      );
                } else {
                  return widget.bottomWidget ??
                      SafeArea(
                        minimum: const EdgeInsets.only(bottom: 16, top: 16),
                        child: Text(
                          context.locale.totalTip(itemCount),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColor.textDarkGreyColor,
                          ),
                        ),
                      );
                }
              }
              return widget.itemBuilder(context, index);
            },
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: widget.backgroundColor,
        body: createListWidget(),
        // 置顶按钮
        floatingActionButton: ValueListenableBuilder<bool>(
            valueListenable: _showFloatingButton,
            builder: (BuildContext context, bool value, _) {
              return Visibility(
                visible: value,
                child: SizedBox(
                  width: 40.w,
                  height: 40.w,
                  child: FloatingActionButton(
                    onPressed: _toTop,
                    child: const Icon(Icons.keyboard_double_arrow_up),
                  ),
                ),
              );
            }));
  }

  void _toTop() {
    // 滚动到顶部
    _controller.animateTo(-10,
        duration: const Duration(milliseconds: 500), curve: Curves.linear);
  }
}

class PageApiCall<T> {
  bool hasMore = true;
  int page = 1;
  final int size = 10;
  List<T> items = <T>[];
  final Future<List<T>> Function(Map<String, dynamic>) apiCall;
  Map<String, dynamic> params = <String, dynamic>{};

  PageApiCall({required this.apiCall, required this.params});

  Future<void> loadMore() async {
    try {
      params.addAll(<String, dynamic>{'page': page, 'size': size});
      List<T> res = await apiCall(params);
      items.addAll(res);
      hasMore = res.length == size; // 如果当前数据和size一样，那就说明还有很多数据
      if (hasMore) page++;
    } catch (e) {
      debugPrint(e.toString());
      hasMore = false;
    } finally {}
  }

  void refresh() async {
    items.clear();
    page = 1;
    hasMore = true;
  }
}
