import 'package:flutter/material.dart';

class ButtonField extends StatelessWidget {
  final Color color;
  final Widget? child;
  final Function()? onPressed;

  const ButtonField({Key? key, this.color = Colors.blue, this.child, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 120,
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
