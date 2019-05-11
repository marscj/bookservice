import 'package:flutter/material.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';

import '../l10n/authlocalization.dart';

class PhoneVerifyView extends StatefulWidget{

  PhoneVerifyView ({
    Key key,
    @required this.country,
    @required this.errorText,
    @required this.onChange,
    this.phoneNumber,
  }) : super(key:key);

  final String errorText;
  final Country country;
  final String phoneNumber;
  final ValueChanged onChange;

  @override
  State<PhoneVerifyView> createState() => new PhoneVerifyViewState();
}

class PhoneVerifyViewState extends State<PhoneVerifyView> {

  TextEditingController _phoneNumberController;

  @override
  void initState() {
    
    super.initState();

    _phoneNumberController = new TextEditingController(text: widget.phoneNumber);
    _phoneNumberController.addListener((){
      widget.onChange(_phoneNumberController.text);
    });
  }

  @override
  void dispose() {
    
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => new Padding(
    padding: const EdgeInsets.all(16.0),
    child:  new Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        new TextField(
          controller: _phoneNumberController,
          keyboardType: TextInputType.phone,
          autocorrect: false,
          decoration: new InputDecoration(
            labelText: AuthLocalizations.of(context).phoneNumberLabel,
            prefixText: widget.country != null ? '+' + widget.country.dialingCode + '\r\r' : null,
            prefixIcon: new CountryPicker(
              onChanged: widget.onChange,
              size: new Size(24.0, 24.0),
              country: widget.country,
            ),
            errorText: widget.errorText,
            errorMaxLines: 6,
            border: OutlineInputBorder(),
            suffixIcon: const Icon(Icons.phone)
          ),
        ),
        const SizedBox(height: 20.0),
      ],
    ),
  );

  String getInputNumber() {
    return '+' + widget.country.dialingCode + _phoneNumberController.text;
  }
}