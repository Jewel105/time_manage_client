import 'package:animated_tree_view/tree_view/tree_node.dart';
import 'package:animated_tree_view/tree_view/tree_view.dart';
import 'package:flutter/material.dart';
import 'package:time_manage_client/api/category_api.dart';
import 'package:time_manage_client/common/app_style.dart';
import 'package:time_manage_client/models/category_model/category_model.dart';
import 'package:time_manage_client/utils/index.dart';
import 'package:time_manage_client/widget/tips_widget.dart';

class SelectCategory extends StatefulWidget {
  const SelectCategory({
    super.key,
    required this.categoryID,
    required this.onChanged,
    this.canSelectParent = false,
  });

  final int categoryID;
  final void Function(int) onChanged;
  final bool canSelectParent;

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
      widget.onChanged(node.data?.id ?? 0);
      return;
    }
    List<TreeNode<CategoryModel>> treeDate = res
        .map((CategoryModel e) =>
            TreeNode<CategoryModel>(data: e, key: e.id.toString()))
        .toList();
    node.addAll(treeDate);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(context.locale.selectCategory, style: AppStyle.h3),
        sampleTree.length == 0
            ? TipsWidget(
                icon: const Icon(Icons.no_backpack_outlined),
                tip: context.locale.noData,
              )
            : Expanded(
                child: TreeView.simple(
                  tree: sampleTree,
                  showRootNode: false,
                  expansionBehavior:
                      ExpansionBehavior.collapseOthersAndSnapToTop,
                  builder:
                      (BuildContext context, TreeNode<CategoryModel> node) {
                    return Container(
                      color: node.data?.id == widget.categoryID
                          ? Colors.amber
                          : null,
                      child: ListTile(
                        title: Text('${node.data?.name}'),
                      ),
                    );
                  },
                  onItemTap: getCategories,
                ),
              ),
      ],
    );
  }
}
