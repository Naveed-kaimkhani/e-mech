import 'package:flutter/material.dart';

class RadioButton extends StatefulWidget {
  const RadioButton({super.key});

  @override
  _RadioButtonState createState() => _RadioButtonState();
}

class _RadioButtonState extends State<RadioButton> {
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Radio Button Example'),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('Option 1'),
            leading: Radio(
              value: 'option1',
              groupValue: selectedOption,
              onChanged: (value) {
                setState(() {
                  selectedOption = value.toString();
                });
              },
            ),
          ),
          ListTile(
            title: Text('Option 2'),
            leading: Radio(
              value: 'option2',
              groupValue: selectedOption,
              onChanged: (value) {
                setState(() {
                  selectedOption = value.toString();
                });
              },
            ),
          ),
          SizedBox(height: 16),
          Text('Selected Option: $selectedOption'),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: RadioButton(),
  ));
}
