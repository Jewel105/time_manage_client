import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:time_manage_client/api/common_api.dart';
import 'package:time_manage_client/common/app_color.dart';
import 'package:time_manage_client/common/constant.dart';
import 'package:time_manage_client/router/nav_ctrl.dart';
import 'package:time_manage_client/router/routes.dart';
import 'package:time_manage_client/utils/index.dart';
import 'package:time_manage_client/widget/main_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  void _toForgotPassword() {}

  void _toRegister() {
    NavCtrl.push(Routes.register);
  }

  void _submit() async {
    final bool valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;
    Map<String, dynamic> data =
        _formKey.currentState?.instantValue ?? <String, dynamic>{};
    String token = await CommonApi.login(data);
    await StorageUtil.set(Constant.TOKEN, token);
    NavCtrl.switchTab(Routes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.locale.login),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              SizedBox(height: 32.w),
              FormBuilderTextField(
                name: 'name',
                decoration:
                    InputDecoration(labelText: context.locale.nameOrEmail),
                validator: FormBuilderValidators.required(),
              ),
              SizedBox(height: 16.w),
              FormBuilderTextField(
                name: 'password',
                decoration: InputDecoration(labelText: context.locale.password),
                obscureText: true,
                validator: FormBuilderValidators.compose(
                  <FormFieldValidator<String>>[
                    FormBuilderValidators.required(),
                    FormBuilderValidators.password()
                  ],
                ),
              ),
              SizedBox(height: 8.w),
              GestureDetector(
                onTap: _toForgotPassword,
                child: Text(context.locale.forgotPassword),
              ),
              SizedBox(height: 64.w),
              MainButton(
                width: double.infinity,
                text: context.locale.login,
                onPressed: _submit,
              ),
              SizedBox(height: 16.w),
              MainButton(
                bgColor: AppColor.bgGreyColor,
                width: double.infinity,
                text: context.locale.register,
                onPressed: _toRegister,
              )
            ],
          ),
        ),
      ),
    );
  }
}
