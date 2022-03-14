import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final Stream<String>? stream;
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final String? labelText;
  final TextStyle errorStyle = TextStyle(
    fontSize: 12,
    color: Colors.redAccent,
    backgroundColor: Colors.white.withOpacity(0.8),
  );
  final bool obscureText;
  final TextInputType? keyboardType;
  final double height;

  InputField(
      {Key? key,
      this.stream,
      required this.controller,
      this.onChanged,
      this.labelText,
      this.obscureText = false,
      this.keyboardType,
      this.height = 95})
      : super(key: key);

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: StreamBuilder<String>(
        stream: widget.stream,
        builder: (context, snapshot) => TextField(
          controller: widget.controller,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
              labelText: widget.labelText,
              errorText: snapshot.error?.toString(),
              errorStyle: widget.errorStyle),
          obscureText: widget.obscureText,
          keyboardType: widget.keyboardType,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
