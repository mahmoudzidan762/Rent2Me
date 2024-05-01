import 'package:flutter/material.dart';

class customButton extends StatelessWidget {
  customButton(
      {required this.onPressed,
      this.color,
      this.height,
      this.width,
      required this.texts});

  void Function() onPressed;
  Color? color;
  double? height, width;
  List<Widget> texts;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: MaterialButton(
        onPressed: onPressed,
        color: color,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: texts,
        ),
      ),
    );
  }
}
