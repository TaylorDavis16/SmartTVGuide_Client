import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final Stream<String>? stream;
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final String? labelText;
  final TextStyle? labelStyle;
  final TextStyle errorStyle = TextStyle(
    fontSize: 12,
    color: Colors.redAccent,
    backgroundColor: Colors.white.withOpacity(0.8),
  );
  final bool obscureText;
  final TextInputType? keyboardType;
  final double height;
  final double? width;

  InputField(
      {Key? key,
      this.stream,
      required this.controller,
      this.onChanged,
      this.labelText,
      this.labelStyle,
      this.obscureText = false,
      this.keyboardType,
      this.height = 95,
      this.width})
      : super(key: key);

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: widget.stream == null
          ? _textField()
          : StreamBuilder<String>(
              stream: widget.stream,
              builder: (context, snapshot) => _textField(snapshot: snapshot),
            ),
    );
  }

  _textField({AsyncSnapshot? snapshot}) => TextField(
        controller: widget.controller,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
            labelText: widget.labelText,
            labelStyle: widget.labelStyle,
            errorText: snapshot?.error?.toString(),
            errorStyle: widget.errorStyle),
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        style: const TextStyle(fontSize: 20),
      );
}
