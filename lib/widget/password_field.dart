import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    this.controller,
    this.hintText,
    this.labelText,
    this.helperText,
    this.filled,
    this.fillColor,
    this.border,
    this.onObscure,
  });

  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final String helperText;
  final bool filled;
  final Color fillColor;
  final InputBorder border;
  final ValueChanged<bool> onObscure;

  @override
  _PasswordFieldState createState() => new _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return new TextField(
      controller: widget.controller,
      obscureText: _obscureText,
      maxLength: 8,
      autocorrect: false,
      decoration: new InputDecoration(
        border: widget.border,
        filled: widget.filled,
        fillColor: widget.fillColor,
        hintText: widget.hintText,
        labelText: widget.labelText,
        helperText: widget.helperText,
        suffixIcon: new GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
              if (widget.onObscure != null) {
                widget.onObscure(_obscureText);
              }
            });
          },
          child: new Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
        ),
      ),
    );
  }
}