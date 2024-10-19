import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:time_manage_client/common/app_color.dart';
import 'package:time_manage_client/utils/extension_util.dart';
import 'package:time_manage_client/widget/main_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

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
                name: 'email',
                decoration:
                    InputDecoration(labelText: context.locale.nameOrEmail),
                validator: FormBuilderValidators.compose(
                  <FormFieldValidator<String>>[
                    FormBuilderValidators.required(),
                  ],
                ),
              ),
              SizedBox(height: 16.w),
              FormBuilderTextField(
                name: 'password',
                decoration: InputDecoration(labelText: context.locale.password),
                obscureText: true,
                validator: FormBuilderValidators.compose(
                  <FormFieldValidator<String>>[
                    FormBuilderValidators.required(),
                    FormBuilderValidators.minLength(6),
                  ],
                ),
              ),
              SizedBox(height: 8.w),
              GestureDetector(
                onTap: () {},
                child: Text(context.locale.forgotPassword),
              ),
              SizedBox(height: 64.w),
              MainButton(
                width: double.infinity,
                text: context.locale.login,
                onPressed: () {
                  _formKey.currentState?.validate();
                  debugPrint(_formKey.currentState?.instantValue.toString());
                },
              ),
              SizedBox(height: 16.w),
              MainButton(
                bgColor: AppColor.bgGreyColor,
                width: double.infinity,
                text: context.locale.register,
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
