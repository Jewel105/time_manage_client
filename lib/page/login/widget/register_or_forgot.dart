import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:time_manage_client/api/common_api.dart';
import 'package:time_manage_client/page/login/widget/code_input.dart';
import 'package:time_manage_client/router/nav_ctrl.dart';
import 'package:time_manage_client/router/routes.dart';
import 'package:time_manage_client/utils/index.dart';
import 'package:time_manage_client/widget/main_button.dart';

enum TypeForm { register, forgot }

class RegisterOrForgot extends StatefulWidget {
  const RegisterOrForgot({
    super.key,
    required this.typeForm,
  });
  final TypeForm typeForm;

  @override
  State<RegisterOrForgot> createState() => _RegisterOrForgotState();
}

class _RegisterOrForgotState extends State<RegisterOrForgot> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  String get title {
    switch (widget.typeForm) {
      case TypeForm.register:
        return context.locale.register;
      case TypeForm.forgot:
        return context.locale.forgotPassword;
    }
  }

  String get submitButtonText {
    switch (widget.typeForm) {
      case TypeForm.register:
        return context.locale.register;
      case TypeForm.forgot:
        return context.locale.submit;
    }
  }

  String get inputLabel {
    switch (widget.typeForm) {
      case TypeForm.register:
        return context.locale.password;
      case TypeForm.forgot:
        return context.locale.newPassword;
    }
  }

  void _submit() async {
    final bool valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;
    Map<String, dynamic> data =
        _formKey.currentState?.instantValue ?? <String, dynamic>{};
    if (widget.typeForm == TypeForm.register) {
      await CommonApi.register(data);
    } else {
      await CommonApi.forgotPassword(data);
    }
    // ignore: use_build_context_synchronously
    await DialogUtil.openDialog(content: context.locale.success);
    NavCtrl.push(Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 16.w),
              FormBuilderTextField(
                name: 'name',
                decoration: InputDecoration(labelText: context.locale.userName),
                validator: FormBuilderValidators.required(),
              ),
              SizedBox(height: 16.w),
              FormBuilderTextField(
                name: 'email',
                decoration: InputDecoration(labelText: context.locale.email),
                validator: FormBuilderValidators.email(),
              ),
              SizedBox(height: 16.w),
              CodeInput(formKey: _formKey),
              SizedBox(height: 16.w),
              FormBuilderTextField(
                name: 'password',
                decoration: InputDecoration(labelText: inputLabel),
                obscureText: true,
                validator: FormBuilderValidators.compose(
                  <FormFieldValidator<String>>[
                    FormBuilderValidators.required(),
                    FormBuilderValidators.password(),
                  ],
                ),
              ),
              SizedBox(height: 16.w),
              FormBuilderTextField(
                  name: 'confrimPassword',
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: context.locale.confirmPassword),
                  validator: (String? value) {
                    String password =
                        _formKey.currentState?.fields['password']?.value ?? '';
                    FormFieldValidator<String> fn =
                        FormBuilderValidators.compose(
                      <FormFieldValidator<String>>[
                        FormBuilderValidators.required(),
                        FormBuilderValidators.password(),
                        FormBuilderValidators.equal(
                          password,
                          errorText: context.locale.confirmPasswordTip,
                        ),
                      ],
                    );
                    return fn(value);
                  }),
              SizedBox(height: 32.w),
              MainButton(
                width: double.infinity,
                text: submitButtonText,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
