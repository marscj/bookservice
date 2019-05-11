import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/date_format.dart';
import '../widgets.dart';
import '../models.dart';
import './config_booking.dart';
import '../store/store.dart';
import '../storage/storage.dart';
import '../router/routes.dart';
import '../l10n/applocalization.dart';

class Validator {

  String validatorRequired(context, value) {
    if (value == null) {
      return AppLocalizations.of(context).required;
    } else if( value.value == null) {
      return AppLocalizations.of(context).required;
    }
    return null;
  }

  String validatorFromTime(context, from, to) {

    if (from == null) {
      return AppLocalizations.of(context).required;
    } 

    if(from != null) {
      DateTime dateTimeTo = new DateTime(2018, 1, 1, to.value.hour, to.value.minute);
      DateTime dateTimeFrom = new DateTime(2018, 1, 1, from.value.hour, from.value.minute);
      
      if (dateTimeTo.isBefore(dateTimeFrom)) {
        return AppLocalizations.of(context).timeError;
      }

      if(from.value.hour < 8) {
        return AppLocalizations.of(context).workFromTimeError;
      }
    }
    return null;
  }

  String validatorToTime(context, from, to) {

    if (to == null) {
      return AppLocalizations.of(context).required;
    } 

    if(from != null) {
      DateTime dateTimeTo = new DateTime(2018, 1, 1, to.value.hour, to.value.minute);
      DateTime dateTimeFrom = new DateTime(2018, 1, 1, from.value.hour, from.value.minute);
      
      if (dateTimeTo.isBefore(dateTimeFrom)) {
        return AppLocalizations.of(context).timeError;
      }

      if(to.value.hour > 18) {
        return AppLocalizations.of(context).workToTimeError;
      }
    }
    return null;
  }

  String validatorDate(context, value, same) {

    if (value == null) {
      return AppLocalizations.of(context).required;
    } 

    if (same) {
      if(DateTime.now().hour > 12) {
        return AppLocalizations.of(context).sameDateError;
      }
    }
    return null;
  }

  String validatorOther(context, subinfo, other) {
    if (subinfo != null){
      if (subinfo.value == -1 && other == '') {
        return AppLocalizations.of(context).required;
      }
    } 
    return null;
  }
}

class ChooseServiceSchedule extends StatefulWidget {

  ChooseServiceSchedule({
    this.onFrom,
    this.onTo
  });

  // final BookingModel model;
  final ValueChanged onFrom;
  final ValueChanged onTo;

  @override
  State<ChooseServiceSchedule> createState() => new ChooseServiceScheduleState();
}

class ChooseServiceScheduleState extends State<ChooseServiceSchedule> with Validator{
  
  ValueNotifier<AnyItem> dateTimeController;
  ValueNotifier<AnyItem> fromController;
  ValueNotifier<AnyItem> toController;
  bool sameDay = false;

  @override
  void initState() {
    
    super.initState();

    dateTimeController = new ValueNotifier(null);
    fromController = new ValueNotifier(null);
    toController = new ValueNotifier(null);
  }

  @override
  Widget build(BuildContext context) => new ListBody(
    children: <Widget>[
      new Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          new Flexible(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: new Text(AppLocalizations.of(context).sameday),
              subtitle: new Text(AppLocalizations.of(context).earliest),
              leading: new Radio(
                value: true,
                groupValue: sameDay,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onChanged: (value) {
                  setState(() {
                    sameDay = value;
                    dateTimeController.value = new AnyItem(value: DateTime.now(), valueText: DateFormat.yMMMd().format(DateTime.now()));
                  });
                }
              ),
            ),
          ),
          new Flexible(
            child: ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: new Text(AppLocalizations.of(context).scheduled),
              subtitle: new Text(AppLocalizations.of(context).after24),
              leading: new Radio(
                value: false,
                groupValue: sameDay,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onChanged: (value) {
                  setState(() {
                    sameDay = value;
                    dateTimeController.value = null;
                  });
                }
              ),
            ),
          ),
        ],
      ),
      new AnyFormField.date(
        enabled: !sameDay,
        controller: dateTimeController,
        lableText: AppLocalizations.of(context).selectDate,
        validator: (value) => validatorRequired(context, value),
      ),
      new SizedBox(height: 10.0),
      new Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          new Flexible(
            child: new AnyFormField.time(
              controller: fromController,
              lableText: AppLocalizations.of(context).from,
              onSaved: (value){
                widget.onFrom(transformDateTime(value));
              },
              validator: (value) {
                return validatorFromTime(context, value, toController.value);
              },
            )
          ),
          new SizedBox(width: 2.0),
          new Flexible(
            child: new AnyFormField.time(
              controller: toController,
              lableText: AppLocalizations.of(context).to,
              onSaved: (value){
                widget.onTo(transformDateTime(value));
              },
              validator: (value) {
                return validatorToTime(context, fromController.value, value);
              },
            )
          )
        ],
      )
    ],
  );

  transformDateTime(value) {
    DateTime dateTime = dateTimeController.value.value;
    return new DateTime(dateTime.year, dateTime.month, dateTime.day, value.value.hour, value.value.minute);
  }
}

class AdditionalInfo extends StatefulWidget{

  AdditionalInfo({
    this.category,
    this.onInfo,
    this.onSubInfo,
    this.onUrl,
    this.onOther
  });

  final Category category;
  final ValueChanged onInfo;
  final ValueChanged onSubInfo;
  final ValueChanged onUrl;
  final ValueChanged onOther;

  @override
  State<AdditionalInfo> createState() => new AdditionalInfoState();
}

class AdditionalInfoState extends State<AdditionalInfo> with Validator {
  
  ValueNotifier<AnyItem> _controller1 = new ValueNotifier<AnyItem>(null);
  ValueNotifier<AnyItem> _controller2 = new ValueNotifier<AnyItem>(null);

  @override
  void initState() {
    
    super.initState();

    _controller1 = new ValueNotifier<AnyItem>(new AnyItem(
      value: null,
      valueText: 'Choose need or issue'
    ))..addListener((){
      if (mounted) {
        setState(() {
          _controller2.value = ConfigBooking.of(context).additionalSecondIssue[widget.category.value][_controller1?.value?.value ?? 0];
        });
      }
    });

    _controller2 = new ValueNotifier<AnyItem>(null)..addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) => new ListBody(
    mainAxis: Axis.vertical,
    children: <Widget>[
      new AnyFormField.menu(
        controller: _controller1,
        lableText: AppLocalizations.of(context).additionalInfo,
        items: ConfigBooking.of(context).additionalFirst[widget.category.value],
        onSaved: widget.onInfo,
        validator: (value) => validatorRequired(context, value),
      ),
      new SizedBox(height: 10.0),
      new AnyFormField.menu(
        controller: _controller2,
        lableText: '',
        enabled: _controller1?.value?.value != null,
        items: ConfigBooking.of(context).additionalSecond[widget.category.value][_controller1?.value?.value ?? 0],
        onSaved: widget.onSubInfo,
        validator: (value) => validatorRequired(context, value),
      ),
      new SizedBox(height: 10.0),
      new Visibility( 
        visible: _controller2?.value?.value != null ? _controller2.value.value == -1 : false,
        child: new TextFormField(
          keyboardType: TextInputType.text,
          maxLength: 250,
          decoration: new InputDecoration(
            labelText: AppLocalizations.of(context).otherIns,
          ),
          onSaved: widget.onOther,
          validator: (value) {
            return validatorOther(context, _controller2.value, value);
          },
        ),
      ),
      new SizedBox(height: 10.0),
      new Visibility( 
        visible: true,//_controller2?.value?.value != null ? _controller2.value.value == -1 : false,
        child: new UploadFile(
          onChange: widget.onUrl
        ),
      )
    ],
  );
}

class Addr extends StatefulWidget {

  Addr({
    this.userData,
    this.onAddr
  });

  final UserModel userData;
  final ValueChanged onAddr;

  @override
  State<Addr> createState() => new AddrState(this.userData);
}

class AddrState extends State<Addr> with Validator{

  AddrState(this.userData);

  UserModel userData;

  ValueNotifier<AnyItem> _controller;

  @override
  void initState() {
    
    super.initState();

    _controller = new ValueNotifier<AnyItem>(
      _getList() != null && _getList().where((item) => item.uuid == userData.defAddr).isNotEmpty ? new AnyItem(
        value: _getList().firstWhere((item) => item.uuid == userData.defAddr),
        valueText: _getList().firstWhere((item) => item.uuid == userData.defAddr)?.toAllTitle()
      ): null
    );
  }

  List<dynamic> _getList() {
    if (widget.userData.category == 0) {
      return widget.userData.customerData;
    } else if (widget.userData.category == 1) {
      return widget.userData.companyData;
    }
    return null; 
  }

  @override
  Widget build(BuildContext context) {
    return new ListBody(
      children: <Widget>[
        new AnyFormField.menu(
          lableText: AppLocalizations.of(context).selectAddress,
          controller: _controller,
          items: _getList()?.map((item) { 
            return new AnyItem(
              value: item,
              icon: userData.defAddr == item.uuid ? Icon(Icons.check) : null,
              valueText: item.toAllTitle()
            );
          })?.toList() ?? [],
          onSaved: widget.onAddr,
          validator: (value) => validatorRequired(context, value),
        ),
        new Container(
          alignment: Alignment.bottomRight,
          padding: new EdgeInsets.all(8.0),
          child: new GestureDetector(
            child: new Text(AppLocalizations.of(context).addNewAddr, style: new TextStyle(color: Theme.of(context).accentColor)),
            onTap: () {  
              showDialog(
                context: context,
                builder: (_){
                  return new SimpleDialog(
                    children: ListTile.divideTiles(
                      context: context,
                      tiles: [
                        new ListMenu(
                          value: 0,
                          title: AppLocalizations.of(context).enterManually,
                          callback: () {
                            Navigator.of(context).pop();
                            addAddr(0);
                          }
                        ),
                        new ListMenu(
                          value: 1,
                          title: AppLocalizations.of(context).location,
                          callback: () {
                            Navigator.of(context).pop();
                            addAddr(1);
                          }
                        )
                      ].map((f){
                        return new ListTile(
                          title: new Text(f.title),
                          onTap: f.callback
                        );
                      })
                    ).toList()
                  );
                }
              );
            }
          ) 
        )
      ],
    );
  }

  addAddr(type) {
    Routes.instance.navigateTo(context, _getRoute(), transition: TransitionType.nativeModal, object: {
      'addrType': type
    }).then((onValue){
      if (onValue != null) {
        _addAddress(onValue);
      }
    });
  }
  
  _getRoute() {
    if (userData.category == 0) {
      return Routes.instance.addAddressCustomer;
    } else if (userData.category == 1) {
      return Routes.instance.addAddressCompany;
    }
    return null;
  }

  Future<void> _addAddress(value) async {
    if (widget.userData.category == 0) {
      widget.userData.customerData ??= new List<CustomerAddressModel>();
      widget.userData.customerData.add(value);                                                                            
      return Store.instance.userRef.setData({'customerData': List.generate(widget.userData.customerData.length, (index) => json.decode(json.encode(widget.userData.customerData[index])))}, merge: true);
    } else if (widget.userData.category == 1) {
      widget.userData.companyData ??= new List<CompanyAddressModel>();
      widget.userData.companyData.add(value);
      return Store.instance.userRef.setData({'companyData': List.generate(widget.userData.companyData.length, (index) => json.decode(json.encode(widget.userData.companyData[index])))}, merge: true);
    }
  }
}

class BookingCreatePage extends StatefulWidget {

  BookingCreatePage(this.category, this.userData);

  final Category category;
  final UserModel userData;

  @override
  State<BookingCreatePage> createState() => BookingCreatePageState();
}

class BookingCreatePageState extends State<BookingCreatePage>{

  BookingModel bookingModel; 

  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    bookingModel = new BookingModel();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => new Scaffold(
    appBar: appBar,
    body: streamBody,
  );

  AppBar get appBar => new AppBar(
    elevation: elevation,
    title: new Text(widget.category.name),
  );

  Widget get streamBody => new BackGroundView(
    body: body,
    background: new Image.asset('assets/background.png')
  );

  Widget get body => new Padding(
    padding: padding,
    child: new Form(
      key: _formKey,
      child: new ListView(
        children: <Widget>[
          new AnyFormField.menu(
            lableText: AppLocalizations.of(context).bookingInformation,
            initialValue: new AnyItem(
              value: widget.category.value,
              valueText: widget.category.name,
            ),
            enabled: false,
            items: null,
            onSaved: (value) => bookingModel.cagetory = value.value,
          ),
          new SizedBox(height: 10.0),
          new ChooseServiceSchedule(
            onFrom: (value) {
              bookingModel.fromDate = formatDate(value, [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn]);
            }, 
            onTo: (value) {
              bookingModel.toDate = formatDate(value, [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn]);
            }
          ),
          new SizedBox(height: 10.0),
          new Addr(userData: widget.userData, onAddr: (value){
            bookingModel.addr = value.valueText;
            bookingModel.place = value?.value?.place;
          }),
          new SizedBox(height: 10.0),
          new AdditionalInfo(category: widget.category,
            onInfo: (value) {
              bookingModel.info = value.value;
            },
            onSubInfo: (value) {
              bookingModel.subInfo = value.value;
            },
            onUrl: (value) {
              if (value != null) {
                bookingModel.url = value;
              }
              
            },
            onOther: (value) {
              bookingModel.otherInfo = value;
            }
          ),
          new SizedBox(height: 10.0),
          new ButtonBar(
            children: <Widget>[
              new RaisedButton(
                colorBrightness: Brightness.dark,
                onPressed: () {
                  _save();
                },
                child: new Text(AppLocalizations.of(context).book),
              )
            ],
          )
        ]
      )
    )
  );

  String validator(DateTime value) {
    if (value == null) {
      return AppLocalizations.of(context).required;
    }
    return null;
  }

  void _save() {
    FormState formState = _formKey.currentState;

    if (formState.validate()){
      formState.save();

      bookingModel.userId = widget.userData.profile.userId;
      bookingModel.userName = widget.userData.profile.displayName;
      bookingModel.userNumber = widget.userData.profile.phoneNumber;
      bookingModel.userEmail = widget.userData.profile.email;

      asyncDialog( 
        context: context,
        future: Store.instance.bookingRef.document(bookingModel.id).setData(json.decode(json.encode(bookingModel)))
      ).then((onValue){
        Routes.instance.navigateTo(context, Routes.instance.bookingDetail, replace: true, transition: TransitionType.inFromRight, object: {'data':bookingModel, 'userData': widget.userData});
      });
    }
  }
}