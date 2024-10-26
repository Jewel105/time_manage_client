import 'package:animated_tree_view/tree_view/tree_node.dart';
import 'package:animated_tree_view/tree_view/tree_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_manage_client/api/category_api.dart';
import 'package:time_manage_client/common/app_style.dart';
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
    this.categoryIDs = const <int>[],
  });

  final int categoryID;
  final List<int> categoryIDs;
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
    if (node.data?.id == null) return;
    if (widget.categoryIDs.contains(node.data?.id)) {
      widget.categoryIDs.remove(node.data?.id);
    } else {
      widget.categoryIDs.add(node.data?.id ?? 0);
    }
    setState(() {});
  }

  void _confirm() {
    if (widget.categoryIDs.isEmpty) {
      DialogUtil.openDialog(
          content: context.locale.pleaseSelect + context.locale.category);
      return;
    }
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
                          ? Colors.amber
                          : null,
                      child: ListTile(
                        title: Text('${node.data?.name}'),
                        trailing: widget.multiselect
                            ? IconButton(
                                icon: Icon(
                                    widget.categoryIDs.contains(node.data?.id)
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
                  onItemTap: getCategories,
                ),
              ),
        if (widget.multiselect)
          MainButton(
            width: double.infinity,
            text: context.locale.confirm,
            onPressed: _confirm,
          )
      ],
    );
  }
}
