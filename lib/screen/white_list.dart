import 'dart:async';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets.dart';
import '../router/routes.dart';
import '../store/store.dart';
import '../models.dart';
import '../l10n/applocalization.dart';

class AddWhiteList extends StatefulWidget {
  
  @override
  State<AddWhiteList> createState() => new AddWhiteListState();
}
class AddWhiteListState extends State<AddWhiteList> {
  
  String name;
  String phoneNumber;

  TextEditingController nameController;
  TextEditingController phoneNumberController;
  ValueNotifier<AnyItem> operatorController;

  bool enable = false;

  @override
  void initState() {
    
    super.initState();

    nameController = new TextEditingController()..addListener((){
      checkEnable();
    });

    phoneNumberController = new TextEditingController()..addListener((){
      checkEnable(); 
    });

    operatorController = new ValueNotifier(new AnyItem(
      value: 3,
      valueText: 'Staff'
    ))..addListener((){
      checkEnable();
    });
  }

  @override
  Widget build(BuildContext context) => new Scaffold(
    appBar: new AppBar(
      title: new Text(AppLocalizations.of(context).addWhiteList),
      elevation: elevation,
      actions: <Widget>[
        new FlatButton(
          textColor: Colors.white, 
          child: new Text(AppLocalizations.of(context).save),
          onPressed: enable ? () {
            onSave();
          } : null,
        )
      ],
    ),
    body: new Padding(
      padding: padding,
      child: new ListView(
        children: <Widget>[
          new TextField(
            keyboardType: TextInputType.text,
            controller: nameController,
            decoration: new InputDecoration(
              labelText: AppLocalizations.of(context).name
            ),
            onChanged: (value) => name = value,
          ),
          new SizedBox(height: 20.0),
          new AnyFormField.dialog(
            controller: operatorController,
            items: [
              new AnyItem(
                value: 3,
                valueText: AppLocalizations.of(context).staff
              ),
              new AnyItem(
                value: 4,
                valueText: AppLocalizations.of(context).operatorText
              )
            ],
          ),
          new SizedBox(height: 20.0),
          new TextField(
            controller: phoneNumberController,
            keyboardType: TextInputType.phone,
            decoration: new InputDecoration(
              hintText: '+971',
              labelText: AppLocalizations.of(context).phoneNumber,
              helperText: 'ex: +971557199188'
            ),
            onChanged: (value) => phoneNumber = value,
          ) 
        ],
      ),
    )
  );

  checkEnable() {
    setState(() {
      if (nameController.text != null && nameController.text.isNotEmpty && phoneNumberController.text != null && phoneNumberController.text.isNotEmpty && operatorController.value != null) {
        enable = true;
      } else {
        enable = false;
      }
    });
  }

  Future<void> onSave() async {
    String _tempNumber = phoneNumber;
    if (!_tempNumber.contains('+971')) {
      _tempNumber = '+971' + phoneNumber;
    }
    Store.instance.whiteList.document(new Uuid().v1()).setData({'name': name, 'phoneNumber': _tempNumber, 'category': operatorController.value.value, 'isAdmin': false});
    Navigator.of(context).pop();
  }
}
class WhiteListPage extends StatefulWidget {
  
  WhiteListPage(this.userData);

  final UserModel userData;

  @override
  State<WhiteListPage> createState() => new WhiteListPageState();
}

class WhiteListPageState extends State<WhiteListPage> {

  Stream<QuerySnapshot> stream;

  @override
  void initState() {
    
    super.initState();

    stream = Store.instance.whiteList.snapshots();
  }

  @override
  void dispose() {
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => new Scaffold(
    appBar: new AppBar(
      title: new Text(AppLocalizations.of(context).whiteList),
      elevation: elevation,
      actions: widget.userData.category == 4 ? <Widget>[
        new IconButton(
          icon: new Icon(Icons.add),
          onPressed: () {
            addList();
          },
        )
      ] : null,
    ),
    body: streamBody,
  );

  Widget get streamBody => new StreamBuilder<QuerySnapshot>(
    stream: stream,
    builder: (_, AsyncSnapshot<QuerySnapshot> snapshot){
      if (!snapshot.hasData) return new Center(child: new CircularProgressIndicator());

      return buildList(snapshot.data.documents);
    },
  );

  Widget buildList(List<DocumentSnapshot> list){
    return list != null && list.isNotEmpty ? new ListView.separated(
      itemCount: list.length,
      separatorBuilder: (_, index) => new Divider(),
      itemBuilder: (_, index){
        return new ListTile(
          title: new Text(list[index].data['phoneNumber']),
          subtitle: new Text(list[index].data['name']),
          trailing: new IconButton(
            icon: new Icon(Icons.delete),
            onPressed: () {
              delItem(list[index].documentID);
            },
          ),
        );
      },
    ) : new Center(child: new Text(AppLocalizations.of(context).noData));
  }

  void addList() {
    Routes.instance.navigateTo(context, Routes.instance.addWhiteList, transition: TransitionType.inFromRight);
  }

  Future<void> delItem(id) async {
    return Store.instance.whiteList.document(id).delete();
  }
}