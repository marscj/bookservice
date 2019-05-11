import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:card_settings/card_settings.dart';

import '../store/store.dart';
import '../widgets.dart';
import '../models.dart';
import '../l10n/applocalization.dart';

class FreelancerProfile extends StatefulWidget {

  FreelancerProfile(this.userData);

  final UserModel userData;

  @override
  State<FreelancerProfile> createState() => new _FreelancerProfileState();
}

class _FreelancerProfileState extends State<FreelancerProfile> {
  
  FreelancerModel freelancerData;
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    
    super.initState();

    freelancerData = widget.userData.freelancerData != null ? FreelancerModel.fromJson(json.decode(json.encode(widget.userData.freelancerData))) : new FreelancerModel();
  }

  @override
  Widget build(BuildContext context) => new Scaffold(
    appBar: appBar,
    body: body,
  );

  AppBar get appBar => new AppBar(
    elevation: elevation,
    title: new Text(AppLocalizations.of(context).freelancerProfile),
  );

  Widget get body => new Form(
    key: _formKey,
    child: card,
  );

  Widget get card => new CardSettings(
    padding: 8.0,
    children: <Widget>[
      new CardSettingsHeader(label: AppLocalizations.of(context).address),
      // new CardSettingsText( 
      //   label: '${AppLocalizations.of(context).country}:', 
      //   initialValue: freelancerData.country,
      //   validator: validator,
      //   onSaved: (value) => freelancerData.country = value,
      // ),
      new CardSettingsText( 
        label: '${AppLocalizations.of(context).city}:', 
        initialValue: freelancerData.city,
        validator: validator,
        onSaved: (value) => freelancerData.city = value,
      ),
      new CardSettingsText( 
        label: '${AppLocalizations.of(context).community}:', 
        initialValue: freelancerData.community,
        validator: validator,
        onSaved: (value) => freelancerData.community = value,
      ),
      new CardSettingsText( 
        label: '${AppLocalizations.of(context).street}:', 
        initialValue: freelancerData.community,
        validator: validator,
        onSaved: (value) => freelancerData.streetName = value,
      ),
      new CardSettingsText( 
        label: '${AppLocalizations.of(context).villaNo}:', 
        initialValue: freelancerData.villaNo,
        validator: validator,
        onSaved: (value) => freelancerData.villaNo = value,
      ),
      new CardSettingsHeader(label: AppLocalizations.of(context).skill),
      new CardSettingsFieldState( 
        label: '${AppLocalizations.of(context).skills}:',
        pickerIcon: new Icon(Icons.arrow_drop_down),
        validator: validatorSkill,
        onPressed: () {
          Navigator.of(context).push(new MaterialPageRoute(
            builder: (_) {
              return new Skill(freelancerData);
            },
            fullscreenDialog: true,
          )).then((onValue){
            if (onValue != null) {
              setState(() {
                freelancerData.skills = onValue;
              });
            }
          });
        },
        content: freelancerData.skills != null ? new Container(
          child: new Flex(
            direction: Axis.vertical,
            children: freelancerData.skills.map((item){
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
        ) : null,
      ),
      new CardSettingsHeader(label: AppLocalizations.of(context).workTime),
      new CardSettingsFieldState( 
        label: '${AppLocalizations.of(context).times}:',
        pickerIcon: new Icon(Icons.arrow_drop_down),
        validator: validatorTime,
        onPressed: (){
          Navigator.of(context).push(new MaterialPageRoute(
            builder: (_) {
              return new WorkTime(freelancerData);
            },
            fullscreenDialog: true,
          )).then((onValue){
            if (onValue != null) {
              if (onValue != null) {
                setState(() {
                  freelancerData.workTimes = onValue;
                });
              }
            }
          });
        },
        content: freelancerData.workTimes != null ? new Container(
          child: new Flex(
            direction: Axis.vertical,
            children: freelancerData.workTimes.map((item){
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
        ): null,
      ),
      new CardSettingsButton(
        label: 'Click to Save',
        bottomSpacing: 4.0,
        backgroundColor: Theme.of(context).cardColor,
        textColor: Theme.of(context).accentColor,
        onPressed: () {
          _save();
        },
      ),
    ],
  );

  String validator(String value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context).required;
    }
    return null;
  }

  String validatorTime(value) {
    if (freelancerData?.workTimes?.where((item){
      return item.useful;
    }) == null) {
      return AppLocalizations.of(context).required;
    }
    return null;
  }

  String validatorSkill(value) {
    if (freelancerData?.skills?.where((item){
      return item.useful;
    }) == null) {
      return AppLocalizations.of(context).required;
    }
    return null;
  }

  _save() {
    FormState state = _formKey.currentState;
    if(state.validate()){
      state.save(); 
      
      asyncDialog(
        context: context,
        future: Store.instance.userRef.setData({'freelancerData': json.decode(json.encode(freelancerData))}, merge: true)
        .catchError((onError){
          Fluttertoast.showToast(msg: onError.details);
        })
      ).then((onValue){
        Navigator.of(context).pop();
      });
    }
  }
}

class Skill extends StatefulWidget {

  Skill(this.freelancerData);

  final FreelancerModel freelancerData;
  
  @override
  State<StatefulWidget> createState() => new _SkillState();
}

class _SkillState extends State<Skill> {

  TextEditingController _controller;

  List<SkillModel> skills = [
    new SkillModel('A/C'),
    new SkillModel('Electrical'),
    new SkillModel('Plumbing'),
    new SkillModel('Cleaning'),
    new SkillModel('Duct Cleaning'),
    new SkillModel('Other'),
  ];

  @override
  void initState() {
    
    super.initState();

    _controller = new TextEditingController(text: _getOther() ?? '');

    int j = 0;
    skills.forEach((i){
      widget.freelancerData.skills?.forEach((k){
        if (i.name == k.name) {
          skills[j] = k;
        }
      });
      j ++;
    });
  }

  _getOther() {
    List<SkillModel> list = widget.freelancerData?.skills?.where((item) => item.useful && item.other != null)?.toList();
    if (list != null && list.length > 0){
      return list.first.other;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) => new Scaffold(
    appBar: new AppBar(
      elevation: elevation,
      title: new Text(AppLocalizations.of(context).skill),
      actions: <Widget>[
      new FlatButton(
        child: new Text(AppLocalizations.of(context).save, style: Theme.of(context).textTheme.body1.copyWith(color: Colors.white)),
        onPressed: () {
          Navigator.of(context).pop(skills.where((item) => item.useful).toList());
        }
      )
    ],
    ),
    body: body,
  );

  Widget get body => new Container(
    decoration: const BoxDecoration(
      border: Border(top: BorderSide(color: Colors.black26)),
    ),
    child: new ListView(
      children: ListTile.divideTiles(context: context, tiles: skills.map((item){
        return new Column(
          children: <Widget>[
            new MergeSemantics(child: new CheckboxListTile(
              title: new Text(item.name),
              value: item.useful,
              onChanged: (value) {
                setState(() {
                  item.useful = value;
                });
              },
            )),
            new Visibility(
              visible: item.useful && item.name == 'Other',
              child: new Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: new TextField(
                  controller: _controller,
                  maxLength: 128,
                  onChanged: (value) {
                    item.other = value;
                  },
                  decoration: new InputDecoration(
                    labelText: AppLocalizations.of(context).description,
                  ),
                )
              )
            )
          ],
        );
      })).toList(),
    )
  );
}

class WorkTime extends StatefulWidget {
  
  WorkTime(this.freelancerData);

  final FreelancerModel freelancerData;

  @override
  State<StatefulWidget> createState() => new _WorkTimeState();
}

class _WorkTimeState extends State<WorkTime> {
  
  List<WorkTimeModel> workTimes = [
    new WorkTimeModel('MON'),
    new WorkTimeModel('TUE'),
    new WorkTimeModel('WED'),
    new WorkTimeModel('THU'),
    new WorkTimeModel('FRI'),
    new WorkTimeModel('SAT'),
    new WorkTimeModel('SUN'),
  ];

  @override
  void initState() {
    
    super.initState();

    int j = 0;
    workTimes.forEach((i){
      widget.freelancerData.workTimes?.forEach((k){
        if (i.name == k.name) {
          workTimes[j] = k;
        }
      });
      j ++;
    });
  }

  @override
  Widget build(BuildContext context) => new Scaffold(
    appBar: new AppBar(
      elevation: elevation,
      title: new Text(AppLocalizations.of(context).workTime),
      actions: <Widget>[
      new FlatButton(
        child: new Text(AppLocalizations.of(context).save, style: Theme.of(context).textTheme.body1.copyWith(color: Colors.white)),
        onPressed: () {
          Navigator.of(context).pop(workTimes.where((item) => item.useful).toList());
        }
      )
    ],
    ),
    body: body,
  );

  Widget get body => new Container(
    decoration: const BoxDecoration(
      border: Border(top: BorderSide(color: Colors.black26)),
    ),
    child: new ListView(
      children: ListTile.divideTiles(context: context, tiles: workTimes.map((item){
        return new MergeSemantics(child: new ListTile(
          title: new Text(item.name),
          subtitle: new Text('${AppLocalizations.of(context).from} ${item.time.form ?? ''}  ${AppLocalizations.of(context).to} ${item.time.to ?? ''}'),
          trailing: new PopupMenuButton(
            onSelected: (value) {
              showTimePicker(
                context: context,
                initialTime: TimeOfDay(hour: 0, minute: 0)
              ).then<TimeOfDay>((onValue){
                setState(() {
                  value == 0 ? item.time.form = onValue?.format(context) : item.time.to = onValue?.format(context);
                  item.useful = (item.time.form != null && item.time.to != null) ? true : false;
                });
              });
            },
            itemBuilder: (_)=> <PopupMenuEntry<int>>[
              new PopupMenuItem<int>(
                value: 0,
                child: new Text(AppLocalizations.of(context).from),
              ),
              new PopupMenuDivider(),
              new PopupMenuItem<int>(
                value: 1,
                child: new Text(AppLocalizations.of(context).to),
              ),
            ],
          ),
          leading: new Checkbox(
            value: item.useful,
            onChanged: (value){}
          ),
        ));
      })
    ).toList())
  );
}