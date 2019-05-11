import 'package:flutter/material.dart';

import '../l10n/authlocalization.dart';

class PhoneSignInView extends StatefulWidget{

  PhoneSignInView({
    Key key,
    @required this.errorText,
    @required this.reSend
  }) : super(key:key);

  final String errorText;
  final VoidCallback reSend;

  @override
  State<PhoneSignInView> createState() => new PhoneSignInViewState();
}

class PhoneSignInViewState extends State<PhoneSignInView> {
  
  TextEditingController smsCodeController;

  @override
  void initState() {
    
    super.initState();

    smsCodeController = new TextEditingController();
  }

  @override
  void dispose() {
    
    smsCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => new Padding(
    padding: const EdgeInsets.all(16.0),
    child: new Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        new TextField(
          autofocus: true,
          controller: smsCodeController, 
          keyboardType: TextInputType.phone,
          autocorrect: false,
          maxLength: 6,
          decoration: new InputDecoration(
            labelText: AuthLocalizations.of(context).smsCodeLabel,
            errorText: widget.errorText,
            errorMaxLines: 6,
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20.0),
      ],
    ),
  );
}