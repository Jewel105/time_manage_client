import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:time_manage_client/common/app_color.dart';
import 'package:time_manage_client/utils/index.dart';
import 'package:time_manage_client/widget/tips_widget.dart';

typedef RefreshCallback = Future<void> Function();
typedef LoadMoreCallback = Future<void> Function();

class ListViewWrapper extends StatefulWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final RefreshCallback? onRefresh; // 下拉刷新回调 与reverse:true时不能同时生效
  final bool hasMore; // 是否还有数据
  final bool reverse; // 是否反转滚动
  final bool shrinkWrap; // 是否反转滚动

  final LoadMoreCallback? loadMore; // 上拉加载更多回调
  final double? itemExtent;
  final ScrollController? controller;
  final Widget? skeleton; // 刚刚加载时显示骨架屏
  final Widget? bottomWidget; // 底部widget
  final Widget? noDataWidget; // 底部widget
  final Color? backgroundColor; // 背景色

  const ListViewWrapper(
      {super.key,
      required this.itemCount,
      required this.itemBuilder,
      this.onRefresh,
      this.hasMore = true,
      this.reverse = false,
      this.shrinkWrap = true,
      this.controller,
      this.itemExtent,
      this.loadMore,
      this.skeleton,
      this.bottomWidget,
      this.noDataWidget,
      this.backgroundColor});

  @override
  State<ListViewWrapper> createState() => _ListViewWrapperState();
}

class _ListViewWrapperState extends State<ListViewWrapper> {
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
    Widget listWidget = Scrollbar(
        controller: _controller,
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: widget.shrinkWrap,
          reverse: widget.reverse,
          controller: _controller,
          itemExtent: widget.itemExtent, // 每个块的大小，使拖动滚动条更平滑
          itemCount: widget.itemCount + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == widget.itemCount) {
              if (widget.hasMore && widget.loadMore != null) {
                if (widget.itemCount != 0) widget.loadMore?.call();
                if (widget.itemCount == 0 && widget.skeleton != null) {
                  return widget.skeleton;
                }
                return SpinKitThreeInOut(
                  color: AppColor.appMainColor,
                );
              } else if (widget.itemCount == 0) {
                return widget.noDataWidget ??
                    TipsWidget(
                      icon: const Icon(Icons.abc_outlined),
                      tip: context.locale.noData,
                    );
              } else {
                return widget.bottomWidget ??
                    SafeArea(
                      minimum: const EdgeInsets.only(bottom: 16, top: 16),
                      child: Text(
                        context.locale.totalTip(widget.itemCount),
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
        ));
    if (widget.reverse || widget.onRefresh == null) {
      return listWidget;
    } else {
      return RefreshIndicator(onRefresh: widget.onRefresh!, child: listWidget);
    }
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
                visible: value && !widget.reverse,
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
  final Future<ListEntity> Function(Map<String, dynamic>) _apiCall;

  PageApiCall(this._apiCall);

  Future<void> loadMore({
    Map<String, dynamic> params = const <String, dynamic>{},
  }) async {
    try {
      params.addAll(<String, dynamic>{"page": page, "size": size});
      ListEntity res = await _apiCall(params);
      items.addAll(res.items as List<T>);
      hasMore = items.length < res.total;
      if (hasMore) {
        page++;
      }
    } catch (e) {
      debugPrint(e.toString());
      hasMore = false;
    } finally {}
  }

  void refresh() {
    items.clear();
    page = 1;
    hasMore = true;
  }
}
