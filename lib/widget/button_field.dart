import 'package:flutter/material.dart';

class ButtonField extends StatelessWidget {
  final Color color;
  final Widget? child;
  final Function()? onPressed;
  final double? height;
  final double? width;

  const ButtonField(
      {Key? key, this.color = Colors.blue, this.child, this.onPressed, this.height = 50, this.width = 120})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(60.0),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(color),
          ),
          child: child,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
