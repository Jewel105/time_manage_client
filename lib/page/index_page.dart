import 'package:flutter/material.dart';
import 'package:time_manage_client/utils/string_util.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.locale.home),
      ),
      body: Text("data"),
    );
  }
}
