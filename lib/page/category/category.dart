import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_manage_client/api/category_api.dart';
import 'package:time_manage_client/models/category_model/category_model.dart';
import 'package:time_manage_client/router/nav_ctrl.dart';
import 'package:time_manage_client/router/routes.dart';
import 'package:time_manage_client/utils/index.dart';

class Category extends StatelessWidget {
  const Category({
    super.key,
    this.parentID = 0,
  });
  final int parentID;

  void _addSubCategory() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.locale.category),
        actions: <Widget>[
          IconButton(
            onPressed: _addSubCategory,
            icon: const Icon(Icons.add_circle_outline),
            iconSize: 24.w,
          ),
          SizedBox(width: 10.w),
        ],
      ),
      body: FutureBuilder<List<CategoryModel>>(
          future: CategoryApi.getCategories(parentID: parentID),
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
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    if (item.level >= 4) return;
                    NavCtrl.push(Routes.category, arguments: item.id);
                  },
                );
              },
            );
          }),
    );
  }
}
