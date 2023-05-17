import 'package:e_mech/style/styling.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputField extends StatelessWidget {
  String? hint_text;
  FocusNode? currentNode;
  FocusNode? nextNode;
  bool? obsecureText;
  FocusNode? focusNode;
  IconData? icon;
  Widget? preicon;
  dynamic validator;
  TextInputType? keyboardType;
  // bool? visiblity;
  Function()? onIconPress;
  TextEditingController? controller;
  InputField({
    required this.hint_text,
    required this.currentNode,
    required this.focusNode,
    required this.nextNode,
    required this.controller,
    this.validator,
    this.icon,
    this.preicon,
    this.onIconPress,
    this.obsecureText,
    this.keyboardType,
    // this.visiblity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      width: 371.w,
      decoration: BoxDecoration(
          color: Styling.textfieldsColor,
          borderRadius: BorderRadius.circular(7.r)),
      child: TextFormField(
        style: const TextStyle(
            color: Color(0xff7FCFCF), fontFamily: "Sansita", fontSize: 12),
        keyboardType: keyboardType ?? TextInputType.text,
        obscureText: obsecureText ?? false,
        controller: controller,
        cursorColor: Colors.black,
        focusNode: focusNode,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(12),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7.r),
            borderSide: BorderSide(color: Styling.primaryColor, width: 1.0),
          ),
          border: InputBorder.none,
          hintText: hint_text,
          hintStyle: TextStyle(
            color: Color.fromARGB(255, 112, 102, 102),
            fontSize: 17.sp,
          ),
          prefixIcon: preicon,
          suffixIcon: InkWell(
            child: Icon(
              icon,
              color: Color.fromARGB(255, 65, 61, 61),
            ),
            onTap: onIconPress,
          ),
        ),
        validator: validator,
      ),
    );
  }
}
