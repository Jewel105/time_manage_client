import 'package:flutter/material.dart';

class TipsPage extends StatelessWidget {
  const TipsPage({super.key, required this.icon, required this.tip});

  final Widget icon;
  final String tip;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: <Widget>[
        icon,
        Text(tip),
      ],
    ));
  }
}
