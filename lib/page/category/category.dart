import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_manage_client/api/category_api.dart';
import 'package:time_manage_client/common/app_color.dart';
import 'package:time_manage_client/models/category_model/category_model.dart';
import 'package:time_manage_client/page/category/widget/save_category.dart';
import 'package:time_manage_client/router/nav_ctrl.dart';
import 'package:time_manage_client/router/routes.dart';
import 'package:time_manage_client/utils/index.dart';

class Category extends StatefulWidget {
  const Category({super.key, required this.parent});
  final CategoryModel parent;

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category>
    with AutomaticKeepAliveClientMixin {
  void _addSubCategory({required CategoryModel category}) async {
    bool? res = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SaveCategory(category: category);
      },
    );
    if (res == true) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(context.locale.category),
        actions: <Widget>[
          if (widget.parent.level < 3)
            IconButton(
              onPressed: () {
                _addSubCategory(
                    category: CategoryModel(parentID: widget.parent.id));
              },
              icon: const Icon(Icons.add_circle_outline),
              iconSize: 24.w,
            ),
          SizedBox(width: 10.w),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: FutureBuilder<List<CategoryModel>>(
            future: CategoryApi.getCategories(parentID: widget.parent.id),
            builder: (
              BuildContext context,
              AsyncSnapshot<List<CategoryModel>> snapshot,
            ) {
              List<CategoryModel> list = snapshot.data ?? <CategoryModel>[];
              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  CategoryModel item = list[index];
                  return ListTile(
                    leading: const Icon(Icons.category_outlined),
                    title: Text(item.name),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          iconSize: 24.w,
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: () {
                            _addSubCategory(category: item);
                          },
                        ),
                        IconButton(
                          iconSize: 24.w,
                          icon: const Icon(
                            Icons.delete_outline,
                            color: AppColor.textErrorColor,
                          ),
                          onPressed: () async {
                            await CategoryApi.deleteCategory(item.id);
                            setState(() {});
                          },
                        ),
                        if (item.level < 4) const Icon(Icons.chevron_right),
                      ],
                    ),
                    onTap: () {
                      if (item.level >= 4) return;
                      NavCtrl.push(Routes.category, arguments: item);
                    },
                  );
                },
              );
            }),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
