import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../inputfields.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              width: 200,
              color: Colors.black,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 200,
              width: 200,
              color: Colors.black,
            ),
            SizedBox(
              height: 20,
            ),
           TextFormField(
            
           ),
            Container(
              height: 200,
              width: 200,
              color: Colors.black,
            ),
            Container(
              height: 200,
              width: 200,
              color: Colors.black,
            ),
            Container(
              height: 200,
              width: 200,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
