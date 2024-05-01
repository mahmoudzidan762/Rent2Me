import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rent2me/constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class customTextFormField extends StatelessWidget {
  customTextFormField(
      {this.controller,
      this.validator,
      this.keyboardType,
      this.onChanged,
      this.icon,
      this.textSize,
      this.obscureText = false,
      required this.text,
      this.borderSide = BorderSide.none,
      this.color = Colors.white,
      this.textColor = Colors.grey});

  String text;
  Color color, textColor;
  void Function(String)? onChanged;
  String? Function(String?)? validator;
  TextEditingController? controller;
  BorderSide? borderSide;
  TextInputType? keyboardType;
  bool obscureText;
  double? textSize;
  IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.white,
        height: 7.h,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                icon,
                color: kPrimaryColor,
              ),
            ),
            Expanded(
              child: TextFormField(
                obscureText: obscureText,
                keyboardType: keyboardType,
                controller: controller,
                validator: validator,
                onChanged: onChanged,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: color,
                  hintText: text,
                  hintStyle: TextStyle(color: textColor, fontSize: textSize),
                  border: OutlineInputBorder(
                    borderSide: borderSide!,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
