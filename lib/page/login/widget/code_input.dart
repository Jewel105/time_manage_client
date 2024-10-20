import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:time_manage_client/api/common_api.dart';
import 'package:time_manage_client/utils/index.dart';
import 'package:time_manage_client/widget/main_button.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class CodeInput extends StatefulWidget {
  const CodeInput({
    super.key,
    required this.formKey,
  });
  final GlobalKey<FormBuilderState> formKey;

  @override
  State<CodeInput> createState() => _CodeInputState();
}

class _CodeInputState extends State<CodeInput> {
  CountdownController controller = CountdownController();

  void _sendCode() async {
    bool emailValid =
        widget.formKey.currentState?.fields['email']?.validate() ?? false;
    if (!emailValid) return;
    String email = widget.formKey.currentState?.fields['email']?.value ?? '';
    await CommonApi.sendCode(email);
    controller.restart();
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: 'code',
      decoration: InputDecoration(
        labelText: context.locale.emailCode,
        suffixIcon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Countdown(
            controller: controller,
            seconds: 120,
            build: (BuildContext context, double time) {
              String seconds = time.toInt().toString();
              bool isRunning = time > 0 && time < 120;
              return MainButton(
                height: 30.w,
                text: context.locale.sendCode + (isRunning ? seconds : ''),
                onPressed: isRunning ? null : _sendCode,
              );
            },
          ),
        ),
      ),
      validator: FormBuilderValidators.required(),
    );
  }
}
