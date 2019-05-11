import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:bookservice/widget/form_field.dart';
import 'package:bookservice/widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../firestore_helpers/firestore_helpers.dart';
import 'package:card_settings/card_settings.dart';

import '../utils/date_format.dart';
import './config_users.dart';
import '../widgets.dart';
import '../models.dart';
import '../router/routes.dart';
import '../store/store.dart';
import '../l10n/applocalization.dart';

class JobPage extends StatefulWidget {

  JobPage(this.job);

  final JobModel job;

  _JobState createState() => _JobState();
}

class _JobState extends State<JobPage> {
  
  JobModel job;
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  ValueNotifier<AnyItem> dateTimeController;

  @override
  void initState() {
    super.initState();

    job = widget.job ?? new JobModel();

    dateTimeController = new ValueNotifier(null);
  }

  @override
  Widget build(BuildContext context) => new Scaffold(
    appBar: new AppBar(
      elevation: elevation,
      title: new Text('Add Job'),
      actions: <Widget>[
        new FlatButton(
          textColor: Colors.white, 
          child: new Text(AppLocalizations.of(context).save),
          onPressed: () {
            onSave();
          },
        )
      ]
    ),
    body: body,
  );

  Widget get body => new Form(
    key: _formKey,
    child: new ListView(
      padding: new EdgeInsets.all(10.0),
      children: <Widget>[ 
        new AnyFormField.date(
          lableText:'Date:',
          initialValue: job.date != null  ? new AnyItem(
            value: DateTime.parse(job.date), 
            valueText: DateFormat.yMd("en_US").format(DateTime.parse(job.date))
          ) : null,
          controller: dateTimeController,
          onSaved: (value) => job.date = formatDate(value.value, [yyyy, '', mm, '', dd, ''])
        ),
        new TextFormField(
          initialValue: job.card,
          validator: validator,
          onSaved: (value) => job.card = value,
          decoration: new InputDecoration(
            labelText: 'Job Card:'
          )
        ),
        new CardSettingsFieldState(
          style: true,
          label: '${AppLocalizations.of(context).type}:', 
          contentOnNewLine: false, 
          pickerIcon: new Icon(Icons.arrow_drop_down),
          validator: validatorType,
          initialValue: job.type == null ? null : ConfigUsers.of(context).visits[job.type].value,
          onSaved: (value) => job.type = ConfigUsers.of(context).visits[job.type].value,
          content: new Text(job.type == null ? '' : ConfigUsers.of(context).visits[job.type].title),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_){
                return new SimpleDialog(
                  children: ListTile.divideTiles(context: context, tiles: ConfigUsers.of(context).visits.map((item){
                    return new ListTile(
                      title: new Text(item.title),
                      onTap: () {
                        Navigator.of(context).pop(item);
                      },
                    );
                  })).toList()
                );
              }
            ).then((onValue){
              if (onValue != null){
                setState(() {
                  job.type = onValue.value;
                });
              }
            });
          },
        ),
        new TextFormField(
          validator: validator,
          initialValue: job.unit,
          keyboardType: TextInputType.number,
          onSaved: (value) => job.unit = value, 
          decoration: new InputDecoration(
            labelText: 'No. of Units:'
          )
        ),
        new TextFormField(
          initialValue: job.notes,
          maxLines: 3,
          onSaved: (value) => job.notes = value,
          decoration: new InputDecoration(
            labelText: 'Notes(Optional):'
          )
        ),
      ],
    ),
  );

  String validator(value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context).required;
    }
    return null;
  }

  String validatorDate(value) {
    if (value == null) {
      return AppLocalizations.of(context).required;
    }
    return null;
  }
  
  String validatorType(value) {
    if (job.type == null) {
      return AppLocalizations.of(context).required;
    }
    return null;
  }

  onSave() {
    FormState formState = _formKey.currentState;

    if(formState.validate()){
      formState.save();
      Navigator.of(context).pop(job);
    }
  }
}

class ContractPage extends StatefulWidget {
  
  ContractPage(this.viewData, this.userData);

  final UserModel viewData;
  final UserModel userData;

  @override
  State<ContractPage> createState() => new ContractPageState();
}

class ContractPageState extends State<ContractPage> {

  ContractModel contract;
  List<JobModel> jobs;

  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  List<TextEditingController> _listControl = new List<TextEditingController>();

  @override
  void initState() {
    
    super.initState();

    contract = widget.viewData.contract != null ? ContractModel.fromJson(json.decode(json.encode(widget.viewData.contract))) : widget.userData.category == 4 ? new ContractModel() : null;
    jobs = widget.viewData?.contract?.jobs ?? new List<JobModel> ();

    if (contract != null){
      for(int i = 0; i < 6; i++){
        _listControl.add(new TextEditingController(text: '${contract?.visits[i] ?? 0}'));
      }
    }
  }

  @override
  Widget build(BuildContext context) => new Scaffold(
    appBar: new AppBar(
      elevation: elevation,
      title: new Text(AppLocalizations.of(context).contract),
      actions: widget.userData.category == 4 ? <Widget>[
        new FlatButton(
          textColor: Colors.white, 
          child: new Text(AppLocalizations.of(context).save),
          onPressed: () {
            onSave();
          },
        )
      ] : null,
    ),
    body: body,
  );

  TextStyle _buildLabelStyle(BuildContext context) {
    TextStyle labelStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16.0,
    );

    return labelStyle.merge(Theme.of(context).inputDecorationTheme.labelStyle);
  }

  Widget get body => new Form(
    key: _formKey,
    child: widget.userData.category == 4 ? new ListView(
      padding: new EdgeInsets.all(10.0),
      children: <Widget>[
        new CardSettingsFieldState(
          style: true,
          label: 'Package:',
          contentOnNewLine: false,
          pickerIcon: new Icon(Icons.arrow_drop_down),
          content: contract.option != null ? new Text(ConfigUsers.of(context).options[contract.option].title) : new Container(),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) {
                return new SimpleDialog(
                  children: ConfigUsers.of(context).options.map((item){
                    return new ListTile(
                      title: new Text(item.title),
                      onTap: () {
                        Navigator.of(context).pop(item.value);
                      },
                    );
                  }).toList()
                );
              }
            ).then((onValue){
              if (onValue != null) {
                setState(() {
                  contract.option = onValue;
                });
              }
            });
          },
          validator: (value) => validator(contract.option)
        ),
        new AnyFormField.date(
          lableText: '${AppLocalizations.of(context).dateOfIssue}:',
          initialValue: contract.dateOfIssue != null  ? new AnyItem(
            value: DateTime.parse(contract.dateOfIssue), 
            valueText: DateFormat.yMd("en_US").format(DateTime.parse(contract.dateOfIssue))
          ) : null,
          onSaved: (value) => contract.dateOfIssue = formatDate(value.value, [yyyy, '', mm, '', dd, ''])
        ),
        new AnyFormField.date(
          lableText: '${AppLocalizations.of(context).dateOfExpiry}:',
          initialValue: contract.dateOfExpiry != null  ? new AnyItem(
            value: DateTime.parse(contract.dateOfExpiry), 
            valueText: DateFormat.yMd("en_US").format(DateTime.parse(contract.dateOfExpiry))
          ) : null,
          onSaved: (value) => contract.dateOfExpiry = formatDate(value.value, [yyyy, '', mm, '', dd, ''])
        ),
        new Container(
          padding: new EdgeInsets.all(14.0),        
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: 1.0, color: Theme.of(context).dividerColor)),
          ),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text('No. of Visits:', style: _buildLabelStyle(context)),
              new ListBody(
                children: ConfigUsers.of(context).visits.map((f){
                  return new Row(
                    children: <Widget>[
                      new Container(
                        width: 85.0,
                        child: new Text(f.title + ':', textAlign: TextAlign.right, style: new TextStyle(fontSize: 12.0)),
                      ),
                      new Container(
                        width: 120.0,
                        padding: new EdgeInsets.all(4.0),
                        child: new TextFormField(
                          controller: _listControl[f.value],
                          keyboardType: TextInputType.number,
                          decoration: new InputDecoration(
                            isDense: true,
                            contentPadding:  new EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
                            border: OutlineInputBorder(
                              borderSide: new BorderSide(
                                style: BorderStyle.none
                              )
                            )
                          ),
                          validator: (value) => validatorNum(value),
                          onSaved: (value) => contract.visits[f.value] = int.tryParse(value),
                        ),
                      )
                    ],
                  );
                }).toList()
              )
            ],
          )
        ),
        
        new CardSettingsFieldState(
          label: 'Jobs:',
          pickerIcon: new IconButton(
            padding: const EdgeInsets.all(0.0),
            icon: new Icon(Icons.add),
            onPressed: () {
              Routes.instance.navigateTo(context, 'job', transition: TransitionType.inFromRight, object: null).then((onValue){
                if (onValue != null){
                  setState(() {
                    jobs.add(onValue);
                  });
                }
              });
            } 
          ),
          content: new ListBody(
            children: jobs.map((f){
              return new ListTile(
                title: new Text(f.card ?? ''),
                subtitle: new Text(f.date ?? ''),
                onTap: () {
                  Routes.instance.navigateTo(context, 'job', transition: TransitionType.inFromRight, object: f);
                },
              );
            })?.toList() ?? [],
          ),
        )
      ],
    ) : contract == null ? new Center(
      child: new Text(AppLocalizations.of(context).noData),
    ) : new ListView(
      padding: padding,
      children: <Widget>[
        new ListTile(
          contentPadding: EdgeInsets.zero,
          title: new Text('Package:'),
          subtitle: new Text(ConfigUsers.of(context).options[contract.option].title ?? ''),
        ),
        new Divider(),
        new ListTile(
          contentPadding: EdgeInsets.zero,
          title: new Text('Date Of Issue:'),
          subtitle: new Text(contract.dateOfIssue ?? ''),
        ),
        new Divider(),
        new ListTile( 
          contentPadding: EdgeInsets.zero,
          title: new Text('Date Of Expiry:'),
          subtitle: new Text(contract.dateOfExpiry ?? ''),
        ),
        new Divider(),
        new ListTile( 
          contentPadding: EdgeInsets.zero,
          title: new Text('No. of Visits:'),
          subtitle: new Text('${contract.visits[contract.option]}' ?? ''),
        ),
      ],
    )
  );

  validator(value) {
    if (value == null){
      return AppLocalizations.of(context).required;
    }
    return null;
  }

  validatorNum(String value) {
    if (value != null && value.isNotEmpty) {
      var number = int.tryParse(value);
      if (number == null || number < 0) {
        return 'error number';
      }
    }
    return null;
  }

  onSave() {
    FormState formState = _formKey.currentState;

    if(formState.validate()){
      formState.save();
      
      Map<String, dynamic> _map = contract.toJson();
      _map['jobs'] = List.generate(jobs.length, (index) => json.decode(json.encode(jobs[index])));
      Store.instance.usersRef.document(widget.viewData.profile.userId).setData({'contract': _map}, merge: true);
      Navigator.of(context).pop(contract);
    }
  }
}

class UserDetail extends StatefulWidget {

  UserDetail({
    @required this.userId,
    @required this.userData,
  });

  final String userId;
  final UserModel userData;

  @override
  State<UserDetail> createState() => new UserDetailState();
}

class UserDetailState extends State<UserDetail> {
  Stream<DocumentSnapshot> stream;

  @override
  void initState() {
    
    super.initState();

    stream = getQurey;
  }

  Stream<DocumentSnapshot> get getQurey => Store.instance.usersRef.document(widget.userId).snapshots();

  @override
  Widget build(BuildContext context) => new Scaffold(
    appBar: new AppBar(
      title: new Text(AppLocalizations.of(context).userDetail),
      elevation: elevation,
      actions: widget.userData.isAdmin ?  <Widget>[
        new FlatButton(
          textColor: Colors.white, 
          child: new Text(AppLocalizations.of(context).delete),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) {
                return new AlertDialog(
                  content: new Text(AppLocalizations.of(context).sure),
                  actions: <Widget>[
                    new FlatButton(
                      onPressed: (){
                        Navigator.of(context).pop(false);
                      },
                      child: new Text(AppLocalizations.of(context).no),
                    ),
                    new FlatButton(
                      onPressed: (){
                        Navigator.of(context).pop(true);
                      },
                      child: new Text(AppLocalizations.of(context).delete),
                    )
                  ],
                );
              }
            ).then((onValue){
              if (onValue != null && onValue){
                Store.instance.usersRef.document(widget.userId).delete();
                Navigator.of(context).pop();
              }
            });
          } ,
        )
      ] : null,
    ),
    body: streamBody,
  );

  Widget get streamBody => new StreamBuilder<DocumentSnapshot>(
    stream: stream,
    builder: (_, AsyncSnapshot<DocumentSnapshot> snapshot){
      if (!snapshot.hasData) return new Center(child: new CircularProgressIndicator());

      return body(UserModel.fromJson(json.decode(json.encode(snapshot.data.data))));
    },
  );

  Widget body(UserModel userData) { 
    return new CardSettings.sectioned(
      showMaterialIOS: true,
      children: <CardSettingsSection> [
        new CardSettingsSection(
          header: new CardSettingsHeader(label: AppLocalizations.of(context).userProfile, showMaterialIOS: true),
          children: <Widget>[
            new CardSettingsField(
              label: '${AppLocalizations.of(context).displayName}:',
              content: new Text(userData.profile?.displayName ?? AppLocalizations.of(context).unknow),
            ),
            new CardSettingsField(
              label: '${AppLocalizations.of(context).phoneNumber}:',
              content: new Text(userData.profile?.phoneNumber ?? AppLocalizations.of(context).unknow),
            ),
            new CardSettingsField(
              label: '${AppLocalizations.of(context).email}:',
              content: new Text(userData.profile?.email ?? AppLocalizations.of(context).unknow),
            ),
            new Visibility(
              visible: userData.category < 2,
              child: new CardSettingsFieldState(
                label: '${AppLocalizations.of(context).contract}:',
                contentOnNewLine: false,
                pickerIcon: new Icon(Icons.arrow_drop_down),
                content: new Text(userData.contract != null ? ConfigUsers.of(context).options[userData.contract.option].title : AppLocalizations.of(context).none),
                onPressed: (){
                  Routes.instance.navigateTo(context, Routes.instance.contract, transition: TransitionType.inFromRight, object: {'viewData': userData, 'userData': widget.userData});
                },
              ),
            ),
            new Visibility(
              visible: userData.category == 4,
              child: new CardSettingsField( 
                label: '${AppLocalizations.of(context).admin}:',
                content: new Text(userData.isAdmin != null ? userData.isAdmin ? AppLocalizations.of(context).yes : AppLocalizations.of(context).no : AppLocalizations.of(context).unknow),
              ),
            ),
            new Visibility(
              visible: userData.category < 4,
              child: new ListBody(
                children: <Widget>[
                  new CardSettingsFieldState(
                    label: '${AppLocalizations.of(context).bookings}:',
                    contentOnNewLine: false,
                    pickerIcon: new Icon(Icons.arrow_drop_down),
                    onPressed: () {
                      Routes.instance.navigateTo(context, Routes.instance.bookingList, transition: TransitionType.inFromRight, object: {'viewData': userData, 'userData': widget.userData});
                    },
                  ),
                ],
              )
            ),
          ]
        ),
        userData.customerData != null ? new CardSettingsSection(
          showMaterialIOS: true,
          header: new CardSettingsHeader(label: AppLocalizations.of(context).customerData, showMaterialIOS: true),
          children: <Widget> [
            new CardSettingsFieldState(
              contentOnNewLine: true,
              label: '${AppLocalizations.of(context).address}:',
              content: new ListBody(
                children: userData.customerData.map((item){
                  return new ListTile(
                    leading: new Checkbox(
                      value: item.uuid == userData.defAddr,
                      onChanged: (value){},
                    ),
                    title: new Text(item.toAllTitle()),
                  );
                }).toList(),
              )
            )
          ]
        ) : new CardSettingsSection(),
        userData.companyData != null ? new CardSettingsSection(
          header: new CardSettingsHeader(label: AppLocalizations.of(context).companyData, showMaterialIOS: true),
          children: [
            new CardSettingsFieldState(
              contentOnNewLine: true,
              label: '${AppLocalizations.of(context).address}:',
              content: new ListBody(
                children: userData.companyData.map((item){
                  return new ListTile(
                    leading: new Checkbox(
                      value: item.uuid == userData.defAddr,
                      onChanged: (value){},
                    ),
                    title: new Text(item.toAllTitle()),
                  );
                }).toList(),
              )
            ),
          ]
        ) : new CardSettingsSection(),
        userData.freelancerData != null ? new CardSettingsSection(
          showMaterialIOS: true,
          header: new CardSettingsHeader(label: AppLocalizations.of(context).freelancerData, showMaterialIOS: true),
          children: <Widget> [
            new CardSettingsFieldState(
              label: '${AppLocalizations.of(context).address}:',
              content: new ListTile(
                title: new Text(userData.freelancerData.toAllTitle()),
              ),
            ),
            new CardSettingsFieldState(
              label: '${AppLocalizations.of(context).skill}:',
              content: new ListBody(
                children: userData.freelancerData.skills.map((item){
                  return new ListTile(
                    leading: new Checkbox(
                      value: item.useful,
                      onChanged: (value){},
                    ),
                    title: new Text(item.name),
                    subtitle: item.other != null ? new Text(item.other, style: Theme.of(context).textTheme.caption) : null,
                  );
                }).toList(),
              )
            ),
            new CardSettingsFieldState(
              label: '${AppLocalizations.of(context).workTime}:',
              content: new ListBody(
                children: userData.freelancerData.workTimes.map((item){
                  return new ListTile(
                  leading: new Checkbox(
                    value: item.useful,
                    onChanged: (value){},
                  ),
                  title: new Text(item.name),
                  subtitle: new Text('${AppLocalizations.of(context).from} ${item.time.form ?? ''}  ${AppLocalizations.of(context).to} ${item.time.to ?? ''}', style: Theme.of(context).textTheme.caption,),
                );
                }).toList(),
              )
            ),
          ]
        ) : new CardSettingsSection()
      ],
    );
  }
}

class UserPage extends StatefulWidget {
  
  UserPage(this.userData);

  final UserModel userData;

  @override
  State<UserPage> createState() => new UserPageState();
}

class UserPageState extends State<UserPage> {

  Stream<QuerySnapshot> stream;
  SearchDelegate delegate;

  @override
  void initState() {
    
    super.initState();

    stream = getQurey;
    delegate = getSearchDelegate;
  }

  Stream<QuerySnapshot> get getQurey => Store.instance.usersRef.snapshots();

  Stream<List<UserModel>> getSearchQuery(String query) {
    return getDataFromQuery(
      query: buildQuery(
        collection: Store.instance.usersRef,
      ),
      mapper: (doc) {
        return UserModel.fromJson(json.decode(json.encode(doc.data)));
      },
      clientSidefilters: [
        (user) {
          return query.isNotEmpty && (
            (user?.profile?.displayName?.toLowerCase()?.contains(query.toLowerCase()) ?? false) 
            || (user?.profile?.phoneNumber?.contains(query) ?? false));
        },
      ],
      orderComparer: (user1, user2) => user1?.profile?.displayName?.compareTo(user2?.profile?.displayName) 
    );
  }

  SearchDelegate get getSearchDelegate => new SearchListDelegate(
    suggestionBuilder: (context, query, onResult) {
      return new StreamBuilder<List<UserModel>>(
        stream: getSearchQuery(query),
        builder: (_, AsyncSnapshot<List<UserModel>> snapshot) {
          if (!snapshot.hasData) return new Center(child: new CircularProgressIndicator());
          
          return new ListView(
            children: snapshot.data.map((item){
              return snapshot.data.isNotEmpty ? new ListTile(
                title: new Text(item?.profile?.displayName ?? AppLocalizations.of(context).unknow),
                subtitle: new Text(item?.profile?.phoneNumber ?? AppLocalizations.of(context).unknow),
                onTap: () {
                  delegate.close(context, null);
                  Routes.instance.navigateTo(context, Routes.instance.userDetail, transition: TransitionType.inFromRight, object: {'userId': item.profile.userId, 'userData': widget.userData});
                },
              ) : new Center(child: new Text(AppLocalizations.of(context).noData));
            }).toList()
          );
        },
      );
    },
  ); 

  @override
  Widget build(BuildContext context) => new DefaultTabController(
    length: ConfigUsers.of(context).tabs.length,
    child: new Scaffold(
      appBar: new AppBar(
        title: new Text(AppLocalizations.of(context).users),
        elevation: elevation,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              await showSearch(
                context: context,
                delegate: delegate
              );
            },
          ),
        ],
        bottom: new TabBar(
          isScrollable: true,
          tabs: ConfigUsers.of(context).tabs.map((item){
            return new Tab(text: item.title);
          }).toList()
        ),
      ),
      body: streamBody,
    )
  );

  Widget get streamBody => new StreamBuilder<QuerySnapshot>(
    stream: stream,
    builder: (_, AsyncSnapshot<QuerySnapshot> snapshot){
      if (!snapshot.hasData) return new Center(child: new CircularProgressIndicator());

      return buildPage(snapshot.data.documents);
    },
  );

  Widget buildList(List<UserModel> list) {
    return list != null && list.isNotEmpty ? new ListView.separated(
      itemCount: list.length,
      separatorBuilder: (_, index) => new Divider(),
      itemBuilder: (_, index){
        return new ListTile(
          title: new Text(list[index]?.profile?.displayName ?? AppLocalizations.of(context).unknow),
          subtitle: new Text(list[index]?.profile?.phoneNumber ?? AppLocalizations.of(context).unknow),
          onTap: () {
            Routes.instance.navigateTo(context, Routes.instance.userDetail, transition: TransitionType.inFromRight, object: {'userId': list[index].profile.userId, 'userData': widget.userData});
          },
        );
      },
    ) : new Center(child: new Text(AppLocalizations.of(context).noData));
  }

  Widget buildPage(List<DocumentSnapshot> list) {
    return new TabBarView(
      children: ConfigUsers.of(context).tabs.map((item){
        return buildList( 
          list.where((_list){
            return _list?.data['category'] == item.value;
          }).map((value){
            return UserModel.fromJson(json.decode(json.encode(value.data)));
          }).toList()
        );
      }).toList()
    );
  }
}

class UserPageStaff extends StatefulWidget {

  @override
  State<UserPageStaff> createState() => new UserPageStaffStatff();
}

class UserPageStaffStatff extends State<UserPageStaff> {

  Stream<QuerySnapshot> stream;
  SearchDelegate delegate;

  @override
  void initState() {
    
    super.initState();

    stream = getQurey;
    delegate = getSearchDelegate;
  }

  Stream<QuerySnapshot> get getQurey => Store.instance.usersRef.snapshots();

  Stream<List<UserModel>> getSearchQuery(String query) {
    return getDataFromQuery(
      query: buildQuery(
        collection: Store.instance.usersRef,
      ),
      mapper: (doc) {
        return UserModel.fromJson(json.decode(json.encode(doc.data)));
      },
      clientSidefilters: [
        (user) {
          return query.isNotEmpty &&
          ((user?.profile?.displayName?.toLowerCase()?.contains(query) ?? false) 
          || (user?.profile?.phoneNumber?.contains(query) ?? false));
        },
      ],
      orderComparer: (user1, user2) => user1?.profile?.displayName?.compareTo(user2?.profile?.displayName) 
    );
  }

  SearchDelegate get getSearchDelegate => new SearchListDelegate(
    suggestionBuilder: (context, query, onResult) {
      return new StreamBuilder<List<UserModel>>(
        stream: getSearchQuery(query),
        builder: (_, AsyncSnapshot<List<UserModel>> snapshot) {
          if (!snapshot.hasData) return new Center(child: new CircularProgressIndicator());
          
          return new ListView(
            children: snapshot.data.map((item){
              return snapshot.data.isNotEmpty ? new ListTile(
                title: new Text(item?.profile?.displayName ?? AppLocalizations.of(context).unknow),
                subtitle: new Text(item?.profile?.phoneNumber ?? AppLocalizations.of(context).unknow),
                onTap: () {
                  Navigator.of(context).pop(item);
                },
              ) : new Center(child: new Text(AppLocalizations.of(context).noData));
            }).toList()
          );
        },
      );
    },
  ); 

  @override
  Widget build(BuildContext context) => new DefaultTabController(
    length: ConfigUsers.of(context).staffTabs.length,
    child: new Scaffold(
      appBar: new AppBar(
        title: new Text(AppLocalizations.of(context).users),
        elevation: elevation,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              await showSearch(
                context: context,
                delegate: delegate
              );
            },
          ),
        ],
        bottom: new TabBar(
          isScrollable: false,
          tabs: ConfigUsers.of(context).staffTabs.map((item){
            return new Tab(text: item.title);
          }).toList()
        ),
      ),
      body: streamBody,
    )
  );

  Widget get streamBody => new StreamBuilder<QuerySnapshot>(
    stream: stream,
    builder: (_, AsyncSnapshot<QuerySnapshot> snapshot){
      if (!snapshot.hasData) return new Center(child: new CircularProgressIndicator());

      return buildPage(snapshot.data.documents);
    },
  );

  Widget buildList(List<UserModel> list) {
    return list != null && list.isNotEmpty ? new ListView.separated(
      itemCount: list.length,
      separatorBuilder: (_, index) => new Divider(),
      itemBuilder: (_, index){
        return new ListTile(
          title: new Text(list[index]?.profile?.displayName ?? AppLocalizations.of(context).unknow),
          subtitle: new Text(list[index]?.profile?.phoneNumber ?? AppLocalizations.of(context).unknow),
          onTap: () {
            Navigator.of(context).pop(list[index]);
          },
        );
      },
    ) : new Center(child: new Text(AppLocalizations.of(context).noData));
  }

  Widget buildPage(List<DocumentSnapshot> list) {
    return new TabBarView(
      children: ConfigUsers.of(context).staffTabs.map((item){
        return buildList( 
          list.where((_list){
            return _list?.data['category'] == item.value;
          }).map((value){
            return UserModel.fromJson(json.decode(json.encode(value.data)));
          }).toList()
        );
      }).toList()
    );
  }
}