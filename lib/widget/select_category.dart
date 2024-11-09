import 'dart:convert';

import 'package:animated_tree_view/tree_view/tree_node.dart';
import 'package:animated_tree_view/tree_view/tree_view.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_manage_client/api/category_api.dart';
import 'package:time_manage_client/common/app_style.dart';
import 'package:time_manage_client/common/constant.dart';
import 'package:time_manage_client/models/category_model/category_model.dart';
import 'package:time_manage_client/router/nav_ctrl.dart';
import 'package:time_manage_client/utils/index.dart';
import 'package:time_manage_client/widget/main_button.dart';
import 'package:time_manage_client/widget/tips_widget.dart';

class SelectCategory extends StatefulWidget {
  const SelectCategory({
    super.key,
    this.categoryID = 0,
    this.onChanged,
    this.multiselect = false,
    this.categories,
  });

  final int categoryID;
  final ValueNotifier<List<CategoryModel>>? categories;
  final void Function(int)? onChanged;
  final bool multiselect;

  @override
  State<SelectCategory> createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  final TreeNode<CategoryModel> sampleTree = TreeNode<CategoryModel>.root();
  @override
  void initState() {
    super.initState();
    getCategories(sampleTree).then((_) {
      setState(() {});
    });
  }

  Future<void> getCategories(TreeNode<CategoryModel> node) async {
    if (node.childrenAsList.isNotEmpty) return;
    if (widget.categoryID == node.data?.id) return;
    List<CategoryModel> res =
        await CategoryApi.getCategories(parentID: node.data?.id ?? 0);
    if (res.isEmpty) {
      if (!widget.multiselect) widget.onChanged?.call(node.data?.id ?? 0);
      return;
    }
    List<TreeNode<CategoryModel>> treeDate = res
        .map((CategoryModel e) =>
            TreeNode<CategoryModel>(data: e, key: e.id.toString()))
        .toList();
    node.addAll(treeDate);
  }

  void _checkBoxClick(TreeNode<CategoryModel> node) {
    if (node.data == null || widget.categories == null) return;
    if (widget.categories!.value.contains(node.data)) {
      widget.categories!.value.remove(node.data);
    } else {
      widget.categories!.value.add(node.data!);
    }
    setState(() {});
  }

  void _confirmDefault() async {
    if (widget.categories!.value.isEmpty) {
      DialogUtil.openDialog(
          content: context.locale.pleaseSelect + context.locale.category);
      return;
    }
    await StorageUtil.set(
        Constant.CATEGORY, json.encode(widget.categories!.value));
    _confirm();
  }

  void _confirm() {
    if (widget.categories!.value.isEmpty) {
      DialogUtil.openDialog(
          content: context.locale.pleaseSelect + context.locale.category);
      return;
    }
    List<CategoryModel> a = widget.categories!.value;
    widget.categories!.value = <CategoryModel>[];
    widget.categories!.value = a;
    NavCtrl.back(arguments: true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(context.locale.selectCategory, style: AppStyle.h3),
            Text('( ${context.locale.selectCategoryTip} )',
                style: AppStyle.tip),
          ],
        ),
        SizedBox(height: 8.w),
        sampleTree.length == 0
            ? TipsWidget(
                icon: const Icon(Icons.no_backpack_outlined),
                tip: context.locale.noData,
              )
            : Container(
                constraints: BoxConstraints(
                  maxHeight: widget.multiselect ? 0.8.sh : 0.5.sh,
                ),
                child: TreeView.simple(
                  tree: sampleTree,
                  showRootNode: false,
                  shrinkWrap: true,
                  builder:
                      (BuildContext context, TreeNode<CategoryModel> node) {
                    return Container(
                      color: widget.categoryID == node.data?.id
                          ? Theme.of(context).primaryColorLight
                          : null,
                      child: ListTile(
                        title: Text('${node.data?.name}'),
                        trailing: widget.multiselect
                            ? IconButton(
                                icon: Icon(
                                    widget.categories!.value.contains(node.data)
                                        ? Icons.check_box
                                        : Icons.check_box_outline_blank),
                                onPressed: () {
                                  _checkBoxClick(node);
                                },
                              )
                            : null,
                      ),
                    );
                  },
                  onItemTap: (TreeNode<CategoryModel> node) {
                    EasyThrottle.throttle(
                      'button-throttle',
                      const Duration(milliseconds: 1000),
                      () => getCategories(node),
                    );
                  },
                ),
              ),
        if (widget.multiselect)
          Column(
            children: [
              MainButton(
                width: double.infinity,
                text: context.locale.confirm,
                onPressed: _confirm,
              ),
              SizedBox(height: 8.w),
              MainButton(
                width: double.infinity,
                text: context.locale.confirmDefault,
                onPressed: _confirmDefault,
              )
            ],
          ),
      ],
    );
  }
}
