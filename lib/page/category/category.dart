import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:time_manage_client/api/category_api.dart';
import 'package:time_manage_client/models/category_model/category_model.dart';
import 'package:time_manage_client/router/nav_ctrl.dart';
import 'package:time_manage_client/router/routes.dart';
import 'package:time_manage_client/utils/index.dart';

class Category extends StatefulWidget {
  const Category({super.key, this.parentID = 0});
  final int parentID;

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  void _addSubCategory() async {
    bool? res = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SaveCategory(parentID: widget.parentID);
      },
    );
    if (res == true) {
      setState(() {});
    }
  }

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
          future: CategoryApi.getCategories(parentID: widget.parentID),
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
                  trailing:
                      item.level >= 4 ? null : const Icon(Icons.chevron_right),
                  onTap: () {
                    if (item.level >= 4) return;
                    NavCtrl.push(Routes.category, arguments: item);
                  },
                );
              },
            );
          }),
    );
  }
}

class SaveCategory extends StatefulWidget {
  const SaveCategory({super.key, this.id = 0, this.parentID = 0});
  final int parentID;
  final int id;

  @override
  State<SaveCategory> createState() => _SaveCategoryState();
}

class _SaveCategoryState extends State<SaveCategory> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  void _submit(String? value) async {
    final bool valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;
    await CategoryApi.saveCategories(
      id: widget.id,
      name: value ?? '',
      parentID: widget.parentID,
    );
    NavCtrl.back(arguments: true);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: EdgeInsets.all(16.w),
      child: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  widget.id != 0
                      ? context.locale.editCategory
                      : context.locale.addCategory,
                  style: TextStyle(
                    fontSize: 14.w,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 16.h),
                FormBuilderTextField(
                  name: 'name',
                  decoration: InputDecoration(
                    labelText: context.locale.categoryName,
                  ),
                  validator: FormBuilderValidators.required(),
                  onSubmitted: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
