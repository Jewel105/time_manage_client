import 'package:flutter/material.dart';
import 'package:time_manage_client/page/login/widget/register_or_forgot.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const RegisterOrForgot(typeForm: TypeForm.register);
  }
}
