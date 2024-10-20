import 'package:flutter/material.dart';
import 'package:time_manage_client/page/login/widget/register_or_forgot.dart';

class ForgotPage extends StatelessWidget {
  const ForgotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const RegisterOrForgot(typeForm: TypeForm.forgot);
  }
}
