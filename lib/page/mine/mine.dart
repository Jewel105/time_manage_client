import 'package:flutter/material.dart';
import 'package:time_manage_client/utils/index.dart';

class Mine extends StatelessWidget {
  const Mine({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.locale.mine),
      ),
      body: Container(),
    );
  }
}
