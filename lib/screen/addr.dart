import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:card_settings/card_settings.dart';
import 'package:google_places_picker/google_places_picker.dart';

import '../router/routes.dart';
import '../models.dart';
import '../store/store.dart';
import '../widgets.dart';
import './config_addr.dart';
import '../l10n/applocalization.dart';

class CustomerAddressPage extends StatefulWidget {

  CustomerAddressPage(this.addrType, this.addressData);

  final int addrType;
  final CustomerAddressModel addressData;

  @override
  State<CustomerAddressPage> createState() => new _CustomerAddressPageState();
}

class _CustomerAddressPageState extends State<CustomerAddressPage> with AfterLayoutMixin<CustomerAddressPage> {

  CustomerAddressModel addressData;

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  ValueNotifier<AnyItem> _controller = new ValueNotifier<AnyItem>(null);

  @override
  void afterFirstLayout(BuildContext context) {
    if(widget.addressData != null && widget.addressData.type != null) {
      setState(() {
        _controller.value = ConfigAddr.of(context).typeItems[widget.addressData.type];
      });
    }
  }

  @override
  void initState() {
    
    super.initState();

    addressData = widget.addressData != null ? CustomerAddressModel.fromJson(json.decode(json.encode(widget.addressData))) : new CustomerAddressModel();
    addressData.addrType = widget.addrType;

    _controller = new ValueNotifier<AnyItem>(new AnyItem(
      value: null,
      valueText: 'Choose type'
    ));
  }

  @override
  Widget build(BuildContext context) => new Scaffold(
    appBar: new AppBar(
      title: new Text(AppLocalizations.of(context).addNewAddr),
      elevation: elevation,
      actions: <Widget>[
        new FlatButton(
          textColor: Colors.white,
          child: new Text('Save'),
          onPressed: () => _save()
        )
      ],
    ),
    body: new Form(
      key: _formKey,
      child: body,
    ),
  );

  Widget get body => new ListView(
    padding: new EdgeInsets.all(12.0),
    children: <Widget>[
      new Visibility(
        visible: widget.addrType == 0,
        child:  new ListBody(
          children: <Widget>[
            new TextFormField(
              initialValue: addressData.city,
              validator: (value) => validator(value),
              onSaved: (value) => addressData.city = value,
              decoration: new InputDecoration(
                labelText: '${AppLocalizations.of(context).city}:',
              )
            ),
            new TextFormField(
              initialValue: addressData.community,
              validator: validator,
              onSaved: (value) => addressData.community = value,
              decoration: new InputDecoration(
                labelText: '${AppLocalizations.of(context).community}:',
              )
            ),
            new TextFormField(
              initialValue: addressData.streetName,
              validator: validator,
              onSaved: (value) => addressData.streetName = value,
              decoration: new InputDecoration(
                labelText: '${AppLocalizations.of(context).street}:',
              )
            ),
            new TextFormField(
              initialValue: addressData.villaNo,
              validator: validator,
              onSaved: (value) => addressData.villaNo = value,
              decoration: new InputDecoration(
                labelText: '${AppLocalizations.of(context).villaNo}:', 
              )
            ),
            new AnyFormField.menu(
              controller: _controller,
              lableText: '${AppLocalizations.of(context).type}:',
              items: ConfigAddr.of(context).typeItems,
              onSaved: (value) {
                addressData.type = value.value;
              },
              validator: (value)  {
                return validatorType(value);
              }
            ),
          ],
        ) 
      ),
      new Visibility(
        visible: widget.addrType == 1,
        child: new ListBody(
          children: <Widget>[
            addressData.place == null ? new CardSettingsFieldState( 
              label: '${AppLocalizations.of(context).map}:', 
              contentOnNewLine: false, 
              validator: (value) => validatorLocation(addressData?.place),
              pickerIcon: new Icon(Icons.map),
              onPressed: () {
                PluginGooglePlacePicker.showPlacePicker().then((onValue){
                  setState(() {
                    addressData.place = new PlaceModel()..id = onValue.id..address = onValue.address..latitude = onValue.latitude..longitude = onValue.longitude..name = onValue.name;
                  });
                });
              },
            ) : new CardSettingsFieldState( 
              label: '${AppLocalizations.of(context).map}:', 
              pickerIcon: new IconButton(
                icon: new Icon(Icons.map),
                onPressed: () {
                  PluginGooglePlacePicker.showPlacePicker().then((onValue){
                    setState(() {
                      addressData.place = new PlaceModel()..id = onValue.id..address = onValue.address..latitude = onValue.latitude..longitude = onValue.longitude..name = onValue.name;
                    });
                  });
                },
              ),
              validator: (value) => validatorLocation(addressData?.place),
              contentOnNewLine: true, 
              content: new Text(addressData.place.toString()),
              onPressed: () {
                Routes.instance.navigateTo(context, Routes.instance.map, transition: TransitionType.inFromRight, object: addressData.place);
              }
            )
          ]
        )
      )
    ]
  );
 
  String validator(value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context).required;
    }
    return null;
  }

  String validatorLocation(value) {
    if (value == null) {
      return AppLocalizations.of(context).required;
    }
    return null;
  }

  String validatorType(value) {
    if (value == null || value.value == null) {
      return AppLocalizations.of(context).required;
    }
    return null;
  }

  _save() {
    FormState state = _formKey.currentState;

    if(state.validate()){
      state.save();

      Navigator.of(context).pop(addressData);
    }
  }
}

class CompanyAddressPage extends StatefulWidget {

  CompanyAddressPage(this.addrType, this.addressData);

  final addrType;
  final CompanyAddressModel addressData;

  @override
  State<CompanyAddressPage> createState() => new _CompanyAddressPageState();
}

class _CompanyAddressPageState extends State<CompanyAddressPage> {

  CompanyAddressModel addressData;

  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    
    super.initState();

    addressData = widget.addressData != null ? CompanyAddressModel.fromJson(json.decode(json.encode(widget.addressData))) : new CompanyAddressModel();
    addressData.addrType = widget.addrType;
  }

  @override
  Widget build(BuildContext context) => new Scaffold(
    appBar: new AppBar(
      title: new Text(AppLocalizations.of(context).addNewAddr),
      elevation: elevation,
      actions: <Widget>[
        new FlatButton(
          textColor: Colors.white,
          child: new Text('Save'),
          onPressed: () => _save()
        )
      ]
    ),
    body: new Form(
      key: _formKey,
      child: body,
    ),
  );

  Widget get body => new ListView(
    padding: new EdgeInsets.all(12.0),
    children: <Widget>[
      new Visibility(
        visible: widget.addrType == 0,
        child: new ListBody(
          children: <Widget>[
            new TextFormField(
              initialValue: addressData.city,
              validator: validator,
              onSaved: (value) => addressData.city = value,
              decoration: new InputDecoration(
                labelText: '${AppLocalizations.of(context).city}:'
              )
            ),
            new TextFormField(
              initialValue: addressData.community,
              validator: validator,
              onSaved: (value) => addressData.community = value,
              decoration: new InputDecoration(
                labelText: '${AppLocalizations.of(context).community}:'
              )
            ),
            new TextFormField(
              initialValue: addressData.streetName,
              validator: validator,
              onSaved: (value) => addressData.streetName = value,
              decoration: new InputDecoration(
                labelText: '${AppLocalizations.of(context).street}:'
              )
            ),
            new TextFormField(
              initialValue: addressData.buildingName,
              validator: validator,
              onSaved: (value) => addressData.buildingName = value,
              decoration: new InputDecoration(
                labelText: '${AppLocalizations.of(context).buildName}:'
              )
            ),
            new TextFormField(
              initialValue: addressData.officeNo,
              validator: validator,
              onSaved: (value) => addressData.officeNo = value,
              decoration: new InputDecoration(
                labelText: '${AppLocalizations.of(context).officeNo}:'
              )
            )
          ]
        )
      ),
      new Visibility(
        visible: widget.addrType == 1,
        child: new ListBody(
          children: <Widget>[
            addressData.place == null ? new CardSettingsFieldState( 
              label: '${AppLocalizations.of(context).map}:', 
              contentOnNewLine: false, 
              validator: validator,
              pickerIcon: new Icon(Icons.map),
              onPressed: () {
                PluginGooglePlacePicker.showPlacePicker().then((onValue){
                  setState(() {
                    addressData.place = new PlaceModel()..id = onValue.id..address = onValue.address..latitude = onValue.latitude..longitude = onValue.longitude..name = onValue.name;
                  });
                });
              },
            ) : new CardSettingsFieldState( 
              label: '${AppLocalizations.of(context).map}:', 
              contentOnNewLine: true, 
              pickerIcon: new IconButton(
                icon: new Icon(Icons.map),
                onPressed: () {
                  PluginGooglePlacePicker.showPlacePicker().then((onValue){
                    setState(() {
                      addressData.place = new PlaceModel()..id = onValue.id..address = onValue.address..latitude = onValue.latitude..longitude = onValue.longitude..name = onValue.name;
                    });
                  });
                },
              ),
              content: new Text(addressData.place.toString()),
              onPressed: () {
                Routes.instance.navigateTo(context, Routes.instance.map, transition: TransitionType.inFromRight, object: addressData.place);
              },
            ),
          ],
        ),
      ),
    ],
  );
 
  String validator(value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context).required;
    }
    return null;
  }

  _save() {
    FormState state = _formKey.currentState;

    if(state.validate()){
      state.save();

      Navigator.of(context).pop(addressData);
    }
  }
}

class AddrPage extends StatefulWidget {
  
  AddrPage(this.userData);

  final UserModel userData;

  @override
  State<AddrPage> createState() => new _AddrPageState();
}

class _AddrPageState extends State<AddrPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => new Scaffold(
    appBar: appBar,
    body: body,
  );

  AppBar get appBar => new AppBar(
    elevation: elevation,
    title: new Text(AppLocalizations.of(context).address),
    actions: ((_getList() != null && _getList().length < 5) || _getList() == null ? true : false) ? [
      new IconButton(
        icon: new Icon(Icons.add),
        onPressed: () {
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
        },
      )
    ] : null,
  ); 

  Widget get body => _getList() != null && _getList().length > 0 ? new CardSettings.sectioned(
    showMaterialIOS: true,
    children: _getList().map((item){
      return new CardSettingsSection(
        showMaterialIOS: true,
        header: new CardSettingsHeaderEx(
          label: item.uuid == widget.userData.defAddr ? new Text(AppLocalizations.of(context).defaultText) : new IconButton(
            icon: new Icon(Icons.radio_button_unchecked, color:  Colors.white),
            onPressed: () {
              _defAddress(item);
            },
          ),
          icon: new IconButton(
            icon: new Icon(Icons.delete, color: Colors.white,),
            onPressed: () {
              _delAddress(item);
            },
          ),
        ),
        children: <Widget> [
          new CardSettingsField(
            label: AppLocalizations.of(context).address,
            contentOnNewLine: true, 
            content: new Text(item.toAllTitle()),
          ),
          new CardSettingsButton(
            label: AppLocalizations.of(context).clickDetail,
            bottomSpacing: 4.0,
            backgroundColor: Theme.of(context).cardColor,
            textColor: Theme.of(context).accentColor,
            onPressed: () {
              Routes.instance.navigateTo(context, _getRoute(), transition: TransitionType.nativeModal, object: {
                'addrType': item.addrType ,'data': item
              }).then((onValue){
                _updateAddress(onValue);
              });
            }
          )
        ]
      );
    }).toList()
    // children: _getList().map((item){
    //   return new ListBody(
    //       children: <Widget>[
    //         new CardSettingsHeaderEx(
    //             label: item.uuid == widget.userData.defAddr ? new Text(AppLocalizations.of(context).defaultText) : new IconButton(
    //               icon: new Icon(Icons.radio_button_unchecked, color:  Colors.white),
    //               onPressed: () {
    //                 _defAddress(item);
    //               },
    //             ),
    //             icon: new IconButton(
    //               icon: new Icon(Icons.delete, color: Colors.white,),
    //               onPressed: () {
    //                 _delAddress(item);
    //               },
    //             ),
    //           ),
    //           new CardSettingsField(
    //             label: AppLocalizations.of(context).address,
    //             contentOnNewLine: true, 
    //             content: new Text(item.toAllTitle()),
    //           ),
    //           new CardSettingsButton(
    //             label: AppLocalizations.of(context).clickDetail,
    //             bottomSpacing: 4.0,
    //             backgroundColor: Theme.of(context).cardColor,
    //             textColor: Theme.of(context).accentColor,
    //             onPressed: () {
    //               Routes.instance.navigateTo(context, _getRoute(), transition: TransitionType.nativeModal, object: {
    //                 'addrType': item.addrType ,'data': item
    //               }).then((onValue){
    //                 _updateAddress(onValue);
    //               });
    //             }
    //           )
    //       ]
    //     );
    // }).toList()
  ) : new Center(child: new Text(AppLocalizations.of(context).noData));
 
  addAddr(type) {
    Routes.instance.navigateTo(context, _getRoute(), transition: TransitionType.nativeModal, object: {
      'addrType': type
    }).then((onValue){
      if (onValue != null) {
        _addAddress(onValue);
      }
    });
  }

  List<dynamic> _getList() {  
    if (widget.userData.category == 0) {
      return widget.userData.customerData;
    } else if (widget.userData.category == 1) {
      return widget.userData.companyData;
    }
    return null;
  }

  _getRoute() {
    if (widget.userData.category == 0) {
      return Routes.instance.addAddressCustomer;
    } else if (widget.userData.category == 1) {
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

  Future<void> _updateAddress(value) async {
    if (value == null) {
      return null;
    }
    if (widget.userData.category == 0) {
      var j = 0;
      var index = 0;
      widget.userData.customerData.forEach((f){
        print(f.uuid);
        print(value.uuid);
        if (f.uuid == value.uuid){
          index = j;
        } else {
          j ++;
        }
      });

      widget.userData.customerData[index] = value;
      return Store.instance.userRef.setData({'customerData': List.generate(widget.userData.customerData.length, (index) => json.decode(json.encode(widget.userData.customerData[index])))}, merge: true);
    } else if (widget.userData.category == 1) {
      var j = 0;
      var index = 0;
      widget.userData.companyData.forEach((f){
        print(f.uuid);
        print(value.uuid);
        if (f.uuid == value.uuid){
          index = j;
        } else {
          j ++;
        }
      });

      widget.userData.companyData[index] = value;
      return Store.instance.userRef.setData({'companyData': List.generate(widget.userData.companyData.length, (index) => json.decode(json.encode(widget.userData.companyData[index])))}, merge: true);
    }
  }

  Future<void> _delAddress(value) async{
    setState(() {});
    
    if (widget.userData.category == 0) {
      widget.userData.customerData.remove(value);
      return Store.instance.userRef.setData({'customerData': List.generate(widget.userData.customerData.length, (index) => json.decode(json.encode(widget.userData.customerData[index])))}, merge: true);
    } else if (widget.userData.category == 1) {
      widget.userData.companyData.remove(value);
      return Store.instance.userRef.setData({'companyData': List.generate(widget.userData.companyData.length, (index) => json.decode(json.encode(widget.userData.companyData[index])))}, merge: true);
    }
  }

  Future<void> _defAddress(value) {
    setState(() {
      widget.userData.defAddr = value.uuid;
    });
    return Store.instance.userRef.setData({'defAddr': value.uuid}, merge: true);
  }
}