import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'l10n/authlocalization.dart';

enum ProvidersTypes { email, google, facebook, twitter, phone }

ProvidersTypes stringToProvidersType(String value) {
  if (value.toLowerCase().contains('facebook')) return ProvidersTypes.facebook;
  if (value.toLowerCase().contains('google')) return ProvidersTypes.google;
  if (value.toLowerCase().contains('password')) return ProvidersTypes.email;
  if (value.toLowerCase().contains('twitter')) return ProvidersTypes.twitter;
  if (value.toLowerCase().contains('phone')) return ProvidersTypes.phone;
  return null;
}

// Description button
class ButtonDescription extends StatelessWidget {
  final String label;
  final Color labelColor;
  final Color color;
  final String logo;
  final String name;
  final VoidCallback onSelected;

  const ButtonDescription(
      {@required this.logo,
      @required this.label,
      @required this.name,
      this.onSelected,
      this.labelColor = Colors.grey,
      this.color = Colors.white});

  ButtonDescription copyWith({
    String label,
    Color labelColor,
    Color color,
    String logo,
    String name,
    VoidCallback onSelected,
  }) {
    return new ButtonDescription(
        label: label ?? this.label,
        labelColor: labelColor ?? this.labelColor,
        color: color ?? this.color,
        logo: logo ?? this.logo,
        name: name ?? this.name,
        onSelected: onSelected ?? this.onSelected);
  }

  @override
  Widget build(BuildContext context) {
    VoidCallback _onSelected = onSelected ?? () => {};
    return new Padding(
      padding: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 16.0),
      child: new RaisedButton(
          color: color,
          child: new Row(
            children: <Widget>[
              new Container(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 32.0, 16.0),
                  child: new Image.asset('assets/$logo')),
              new Expanded(
                child: new Text(
                  label,
                  style: new TextStyle(color: labelColor),
                ),
              )
            ],
          ),
          onPressed: _onSelected),
    );
  }
}

Future<Null> showErrorDialog(BuildContext context, String message, {String title}) {
  return showDialog<Null>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) => new AlertDialog(
      title: title != null ? new Text(title) : null,
      content: new SingleChildScrollView(
        child: new ListBody(
          children: <Widget>[
            new Text(message ?? AuthLocalizations.of(context).errorOccurred),
          ],
        ),
      ),
      actions: <Widget>[
        new FlatButton(
          child: new Row(
            children: <Widget>[
              new Text(AuthLocalizations.of(context).cancelButtonLabel),
            ],
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );
} 

Future<bool> showEmailVerifyDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false, 
    builder: (BuildContext context) => new AlertDialog(
      content: new Text(AuthLocalizations.of(context).verifyEmailTitle),
      actions: <Widget>[
        new FlatButton(
          child: new Text(AuthLocalizations.of(context).skipLabel),
          onPressed: () {
            Navigator.of(context).pop(false);
          }
        ),
        new FlatButton(
          child: new Text(AuthLocalizations.of(context).verifyInLabel),
          onPressed: () {
            Navigator.of(context).pop(true);
          }
        ),
      ],
    ),
  );
}

Future<bool> showVerifyErrorDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false, 
    builder: (BuildContext context) => new AlertDialog(
      content: new Text(AuthLocalizations.of(context).verifyEmailErrorText),
      actions: <Widget>[
        new FlatButton(
          child: new Text(AuthLocalizations.of(context).skipLabel),
          onPressed: () {
            Navigator.of(context).pop(false);
          }
        ),
        new FlatButton(
          child: new Text(AuthLocalizations.of(context).reSendLabel),
          onPressed: () {
            Navigator.of(context).pop(true);
          }
        ),
      ],
    ),
  );
}

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

Map<dynamic, dynamic> getClaims(idToken) {
    String token = _check(idToken.split('.')[1]);
    var decode = base64.decode(token);
    return json.decode(new String.fromCharCodes(decode));
  }

  String _check(form) {
    String to = form;

    while (to.length % 4 != 0){
      to += '=';
    }

    return to;
  }

  String getClaim(idToken, String value) {
    return idToken != null ? getClaims(idToken)[value] : idToken;
  }

