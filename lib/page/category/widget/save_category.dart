import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:time_manage_client/api/category_api.dart';
import 'package:time_manage_client/models/category_model/category_model.dart';
import 'package:time_manage_client/router/nav_ctrl.dart';
import 'package:time_manage_client/utils/index.dart';

class SaveCategory extends StatefulWidget {
  const SaveCategory({super.key, required this.category});
  final CategoryModel category;

  @override
  State<SaveCategory> createState() => _SaveCategoryState();
}

class _SaveCategoryState extends State<SaveCategory> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  void _submit(String? value) async {
    final bool valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;
    await CategoryApi.saveCategory(
      id: widget.category.id,
      name: value ?? '',
      parentID: widget.category.parentID,
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
                  widget.category.id != 0
                      ? context.locale.editCategory
                      : context.locale.addCategory,
                  style: TextStyle(
                    fontSize: 14.w,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 16.h),
                FormBuilderTextField(
                  autofocus: true,
                  initialValue: widget.category.name,
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
