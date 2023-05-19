import 'package:e_mech/style/custom_text_style.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Text(
          "home",
          style: CustomTextStyle.font_30,
        ),
      ),
    );
  }
}
