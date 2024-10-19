import 'package:flutter/material.dart';
import 'package:time_manage_client/utils/string_util.dart';

class Category extends StatelessWidget {
  const Category({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.locale.category),
      ),
      body: Container(),
    );
  }
}
