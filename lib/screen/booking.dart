import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:card_settings/card_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../firestore_helpers/firestore_helpers.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../l10n/applocalization.dart';
import '../router/routes.dart';
import '../widgets.dart';
import '../store/store.dart';
import '../models.dart';
import './config_home.dart';
import './config_booking.dart';

class Complete extends StatefulWidget{

  Complete(this.data);

  final BookingModel data;

  @override
  State<Complete> createState() => new CompleteState();
}

class CompleteState extends State<Complete> {

  String code;

  @override
  Widget build(BuildContext context) => new Scaffold(
    appBar: new AppBar(
      title: new Text(AppLocalizations.of(context).complete),
      elevation: elevation,
    ),
    body: Padding(
      padding: padding,
      child: new Column(
        children: <Widget>[
          new TextField(
            onChanged: (value) {
              code = value;
            },
            decoration: new InputDecoration(
              hintText: AppLocalizations.of(context).serviceCode
            ),
          ),
          new ButtonBar(
            alignment: MainAxisAlignment.end,
            children: <Widget>[
              new RaisedButton(
                child: new Text(AppLocalizations.of(context).complete),
                textColor: Colors.white,
                onPressed: () {
                  if (code == widget.data.serviceCode) {
                    Store.instance.bookingRef.document(widget.data.id).setData({'status': 1}, merge: true);
                    Navigator.of(context).pop(true);
                  } else {
                    Fluttertoast.showToast(msg: 'service code error');
                  }
                },
              )
            ],
          )
        ],
      ),
    ),
  );
}

class BookingDetail extends StatefulWidget {

  BookingDetail(this.data, this.userData);

  final BookingModel data;
  final UserModel userData;

  @override
  State<BookingDetail> createState() => new BookingDetailState();
}   

class BookingDetailState extends State<BookingDetail> {

  TextEditingController evaluationController;
  String evaluation;
  int status;

  @override
  void initState() {
    
    super.initState();

    evaluation = widget.data.evaluation ?? '';
    status = widget.data.status ?? 0;
    
    evaluationController = new TextEditingController(text: widget.data.evaluation ?? '')..addListener(()=> setState((){}));
  }

  @override
  Widget build(BuildContext context) => new Scaffold(
    appBar: appBar,
    body: body,
  );

  dynamic getAction() {
    switch(widget.userData.category) {
      // case 0:
      // case 1:
      // return <Widget>[
      //   new FlatButton(
      //     onPressed: () {

      //     },
      //     textColor: Colors.white,
      //     child: new Text(AppLocalizations.of(context).cancel),
      //   ),
      // ];
      case 2:
      case 3:
      return status == 0 ? <Widget>[
        new FlatButton(
          onPressed: () {
            Routes.instance.navigateTo(context, Routes.instance.complete, transition: TransitionType.inFromRight, object: widget.data).then((onValue){
              if (onValue != null) {
                setState(() {
                  status = 1;
                });
              }
            });
          },
          textColor: Colors.white,
          child: new Text(AppLocalizations.of(context).complete),
        )
      ] : null;
      case 4:
        return [
          new PopupMenuButton(
            onSelected: (value) {
              switch(value){
                case 0:
                  Routes.instance.navigateTo(context, Routes.instance.complete, transition: TransitionType.inFromRight, object: widget.data).then((onValue){
                    if (onValue != null) {
                      setState(() {
                        status = 1;
                      });
                    } 
                  });
                break;
                case 1:
                  setState(() {
                    status = 2;
                  });
                  Store.instance.bookingRef.document(widget.data.id).setData({'status': 2}, merge: true);
                  Navigator.of(context).pop();
                break;
                case 2:
                  setState(() {
                    status = 3;
                  });
                  Store.instance.bookingRef.document(widget.data.id).setData({'status': 3}, merge: true);
                  Navigator.of(context).pop();
                break;
              }
            },
            itemBuilder: (_){
              return <PopupMenuEntry>[
                new PopupMenuItem(
                  value: 0,
                  child: new ListTile(
                    title: new Text(AppLocalizations.of(context).complete),
                  )
                ),
                new PopupMenuDivider(),
                new PopupMenuItem(
                  value: 1,
                  child: new ListTile(
                    title: new Text(AppLocalizations.of(context).cancel),
                  )
                ),
                new PopupMenuDivider(),
                new PopupMenuItem(
                  value: 2,
                  child: new ListTile(
                    title: new Text(AppLocalizations.of(context).delete),
                  )
                )
              ];
            }
        )
      ];
    }
    return null;
  }

  AppBar get appBar => new AppBar(
    title: new Text(AppLocalizations.of(context).bookingDetail),
    elevation: elevation,
    actions: getAction()
  );

  String get getStatus => status == 0 ? AppLocalizations.of(context).pending
  : status == 1 ? AppLocalizations.of(context).completed 
  : status == 2 ? AppLocalizations.of(context).cancel
  : AppLocalizations.of(context).delete;

  Widget get body => new CardSettings.sectioned(
    showMaterialIOS: true,
    children: <CardSettingsSection> [
      new CardSettingsSection(
        showMaterialIOS: true,
        header: new CardSettingsHeader(label: AppLocalizations.of(context).bookingInformation, showMaterialIOS: true),
        children: <Widget>[
          new CardSettingsField(
            label: '${AppLocalizations.of(context).bookingInfo}:',
            content: new Text(ConfigHome.clientCategories(context)[widget.data.cagetory].name),
          ),
          new CardSettingsField(
            label: '${AppLocalizations.of(context).status}:',
            content: new Text(getStatus),
          ),
          new CardSettingsField(
            label: '${AppLocalizations.of(context).createTime}:',
            content: new Text(widget.data.createTime),
          ),
          new CardSettingsField(
            label: '${AppLocalizations.of(context).startTime}:',
            content: new Text(widget.data.fromDate),
          ),
          new CardSettingsField(
            label: '${AppLocalizations.of(context).endTime}:',
            content: new Text(widget.data.toDate),
          ),
          new Visibility(
            visible: widget.userData.category == 4 || widget.data.userId == widget.userData.profile.userId,
            child: new CardSettingsField(
              label: '${AppLocalizations.of(context).serviceCode}:',
              content: new Text(widget.data.serviceCode),
            )
          ),
          new CardSettingsField(
            label: '${AppLocalizations.of(context).additionalInfo}:',
            contentOnNewLine: true,
            content: new Text(ConfigBooking.of(context).additionalFirst[widget.data.cagetory][widget.data.info].valueText),
          ),
          widget.data.subInfo != -1 ? new CardSettingsField(
            label: '${AppLocalizations.of(context).additionalInfo}:',
            contentOnNewLine: true,
            content: new Text(ConfigBooking.of(context).additionalSecond[widget.data.cagetory][widget.data.info][widget.data.subInfo].valueText),
          ) : new CardSettingsField(
            label: '${AppLocalizations.of(context).otherIns}:',
            contentOnNewLine: true,
            content: new Text(widget.data.otherInfo ?? AppLocalizations.of(context).unknow),
          ),
          new Visibility( 
            visible: widget.data.url != null,
            child: CachedNetworkImage(
              imageUrl: widget.data.url ?? '',
              width: 480.0,
              height: 270.0,
              fit: BoxFit.fitWidth,
            ),
          )
        ]
      ),
      new CardSettingsSection(
        showMaterialIOS: true,
        header: new CardSettingsHeader(label: AppLocalizations.of(context).userInfo, showMaterialIOS: true),
        children: <Widget> [
          new CardSettingsField(
            label: '${AppLocalizations.of(context).userName}:',
            content: new Text(widget.data.userName ?? AppLocalizations.of(context).unknow), 
          ),
          new CardSettingsField(
            label: '${AppLocalizations.of(context).userNumber}:',
            content: new Text(widget.data.userNumber ?? AppLocalizations.of(context).unknow),
          ),
          new Visibility(
            visible: widget.data.place == null ,
            child: new CardSettingsFieldState(
              label: '${AppLocalizations.of(context).address}:',
              contentOnNewLine: true,
              content: new Text(widget.data.addr ?? ''),
            )
          ),
          new Visibility(
            visible: widget.data.place != null,
            child: new CardSettingsFieldState(
              label: '${AppLocalizations.of(context).location}:',
              contentOnNewLine: true,
              content: widget.data.place != null ? new Text(widget.data.place.toString()) : new Container(),
              onPressed: () {
                Routes.instance.navigateTo(context, Routes.instance.map, transition: TransitionType.inFromRight, object: widget.data.place);
              },
            )
          ) 
        ]
      ),
      new CardSettingsSection(
        showMaterialIOS: true,
        header: new CardSettingsHeader(label: AppLocalizations.of(context).staffInfo, showMaterialIOS: true),
        children: <Widget> [
          new Visibility(
            visible: widget.userData.category == 4,
            child: new ListBody(
              children: <Widget>[
                new CardSettingsField(
                  label: '${AppLocalizations.of(context).staffName}:',
                  content: new Text(widget.data.staffName ?? AppLocalizations.of(context).unknow),
                ),
                new CardSettingsField(
                  label: '${AppLocalizations.of(context).staffNumber}:',
                  content: new Text(widget.data.staffNumber ?? AppLocalizations.of(context).unknow),
                )
              ]
            )
          )
        ]
      ),
      new CardSettingsSection(
        showMaterialIOS: true,
        header: new CardSettingsHeader(label: AppLocalizations.of(context).evaluation, showMaterialIOS: true),
        children: <Widget> [
          widget.data.userId == widget.userData.profile.userId ? new CardSettingsField(
            label: '',
            contentOnNewLine: true,
            content: new TextField(
              controller: evaluationController,
              maxLength: 128,
              maxLines: 2,
            ),
          ) : new CardSettingsField(
            label: '${AppLocalizations.of(context).evaluation}:',
            contentOnNewLine: true,
            content: new Text('${widget.data.evaluation ?? AppLocalizations.of(context).none}')
          ),
          
          new CardSettingsButton(label: AppLocalizations.of(context).save,
            backgroundColor: Theme.of(context).cardColor,
            textColor: evaluationController.text != evaluation ? Theme.of(context).accentColor : Colors.black45,
            onPressed: evaluationController.text != evaluation ? () {
                setState(() {
                  evaluation = evaluationController.text;
                });
                Store.instance.bookingRef.document(widget.data.id).setData({'evaluation': evaluationController.text}, merge: true);
                Navigator.of(context).pop();
              } : null,
          )
        ]
      )
    ],
  );
}

class BookingItem {
  
  BookingItem(this.data, this.userData, {this.callback});

  final BookingModel data;
  final UserModel userData;
  final VoidCallback callback;

  CardSettingsSection build(BuildContext context) {
    return new CardSettingsSection(
      showMaterialIOS: true,
      children: userData.category == 4 ? <Widget>[
        new CardSettingsHeaderEx(
          label: new Text(data.createTime), 
          icon: data.status != 3 ? 
            new IconButton(
              icon: new Icon(Icons.delete, color: Colors.white),
              onPressed: () {
                Store.instance.bookingRef.document(data.id).setData({'status': 3}, merge: true);
              }) : new Container()
        ),
        new CardSettingsField( 
          label: '${AppLocalizations.of(context).bookingInfo}:', 
          content: new Text(ConfigHome.clientCategories(context)[data.cagetory].name) ,
        ), 
        new CardSettingsField(
          label: '${AppLocalizations.of(context).startTime}:',
          content: new Text(data.fromDate),
        ),
        new CardSettingsFieldState(
          label: '${AppLocalizations.of(context).user}:',
          contentOnNewLine: false,
          labelWidth: 190.0,
          content: new Text('${data.userName ?? AppLocalizations.of(context).unknow}'),
        ),
        new CardSettingsFieldState(
          label: '${AppLocalizations.of(context).staff}:',
          contentOnNewLine: false,
          labelWidth: 190.0,
          content: new Text('${data.staffName ?? AppLocalizations.of(context).unknow}'),
          pickerIcon: new Icon(Icons.arrow_drop_down),
          onPressed: () {
            Routes.instance.navigateTo(context, Routes.instance.userPageStaff, transition: TransitionType.inFromRight).then<UserModel>((user){
              if (user != null) {
                Store.instance.bookingRef.document(data.id).setData({'staffId': user.profile.userId, 'staffName': user.profile.displayName, 'staffNumber': user.profile.phoneNumber, 'staffEmail': user.profile.email}, merge: true);
              }
            });
          },
        ),
        new CardSettingsButton(
          label: AppLocalizations.of(context).clickDetail,
          bottomSpacing: 4.0,
          backgroundColor: Theme.of(context).cardColor,
          textColor: Theme.of(context).accentColor,
          onPressed: () {
            Routes.instance.navigateTo(context, Routes.instance.bookingDetail, transition: TransitionType.inFromRight, object: {'data': data, 'userData': userData});
          }
        ),
      ] : <Widget> [ 
        new CardSettingsHeaderEx(
          label: new Text(data.createTime), 
          color: data.status == 2 ? Colors.orange : Theme.of(context).accentColor,
          icon: data.userId == userData.profile.userId ? new IconButton(
          icon: new Icon(Icons.delete, color: Colors.white),
          onPressed: () {
            Store.instance.bookingRef.document(data.id).setData({'status': 3}, merge: true);
          }) : new Container()
        ),
        new CardSettingsField( 
          label: '${AppLocalizations.of(context).bookingInfo}:', 
          content: new Text(ConfigHome.clientCategories(context)[data.cagetory].name) ,
        ),
        new CardSettingsField(
          label: '${AppLocalizations.of(context).startTime}:',
          content: new Text(data.fromDate),
        ),
        new CardSettingsButton(
          label: AppLocalizations.of(context).clickDetail,
          bottomSpacing: 4.0,
          backgroundColor: Theme.of(context).cardColor,
          textColor: Theme.of(context).accentColor,
          onPressed: () {
            if (callback != null) {
              callback();
            }
            Routes.instance.navigateTo(context, Routes.instance.bookingDetail, transition: TransitionType.inFromRight, object: {'data': data, 'userData': userData});
          }
        ),
      ]
    );
  }
}

class BookingList extends StatefulWidget {

  BookingList({
    @required this.viewData,
    @required this.userData,
    this.isShowAppBar = false
  });
  
  final UserModel viewData;
  final UserModel userData;
  final bool isShowAppBar;

  @override
  State<BookingList> createState() => new _BookingListState();
}   

class _BookingListState extends State<BookingList> {

  // Query query;
  Stream<List<BookingModel>> _stream;

  @override
  void initState() {
    
    super.initState();

    _stream = getStreamByQuery();
  }

  @override
  void dispose() {
    
    super.dispose(); 
  }

  Query getQuery() {
    switch(widget.viewData.category) {
      case 0:
      case 1:
        return Store.instance.bookingRef.where('userId', isEqualTo: widget.viewData.profile.userId);
      case 2:
      case 3:
        return Store.instance.bookingRef.where('staffId', isEqualTo: widget.viewData.profile.userId);
    }
    return null;
  }

  Stream<QuerySnapshot> getStream() {
    return getQuery().where('status', isLessThan: 3).orderBy('status').orderBy('fromDate').snapshots();
  }

  Stream<List<BookingModel>> getStreamByQuery() {
    return getDataFromQuery(
      query: buildQuery(
        collection: getQuery(),
      ),
      mapper: (doc) => BookingModel.fromJson(json.decode(json.encode(doc.data))),
      clientSidefilters: widget.userData.category != 4 ? [
        (booking) => booking.status != 3
      ] : null,
      orderComparer: (book1, book2) => book2?.fromDate?.compareTo(book1?.fromDate)
    );
  }

  @override
  Widget build(BuildContext context) => widget.isShowAppBar ? new Scaffold(
    appBar: new AppBar(
      title: new Text(AppLocalizations.of(context).bookings),
      elevation: elevation,
    ),
    body: body,
  ) : body;

  Widget get body => new StreamBuilder<List<BookingModel>> (
    stream: _stream,
    builder: (BuildContext context, AsyncSnapshot<List<BookingModel>> snapshot) {
      if (snapshot.hasError) {
        print(snapshot.error);
        return new Text(snapshot.error.toString());
      }
      if (!snapshot.hasData) return new Center(child: new CircularProgressIndicator());
      final int messageCount = snapshot.data.length;

      return messageCount > 0 ? CardSettings.sectioned(
        showMaterialIOS: true,
        children: snapshot.data.map((item){
          return new BookingItem(item, widget.userData).build(context);
        }).toList()
      ) : new Center(child: new Text(AppLocalizations.of(context).noData));
    },
  );

  // Widget get body => new StreamBuilder<QuerySnapshot> (
  //   // stream: Stream.fromFuture(_getFuture().then((query){
  //   //   return query.getDocuments();
  //   // })),
  //   stream: _stream,
  //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  //     if (snapshot.hasError) {
  //       print(snapshot.error);
  //       return new Text(snapshot.error.toString());
  //     }
  //     if (!snapshot.hasData) return new Center(child: new CircularProgressIndicator());
  //     final int messageCount = snapshot.data.documents.length;

  //     return messageCount > 0 ? ListView.builder(
  //       itemCount: messageCount,
  //       itemBuilder: (_, int index) {
  //         final DocumentSnapshot document = snapshot.data.documents[index];
  //         return new BookingItem(BookingModel.fromJson(json.decode(json.encode(document.data))), widget.userData);
  //       },
  //     ) : new Center(child: new Text(AppLocalizations.of(context).noData));
  //   },
  // );
}

class BookingPage extends StatefulWidget {

  BookingPage(this.userData);

  final UserModel userData;

  @override
  State<BookingPage> createState() => new BookingPageState();
}   

class BookingPageState extends State<BookingPage> with SingleTickerProviderStateMixin{

  Stream<QuerySnapshot> stream;
  TabController _tabController;
  SearchDelegate delegate;

  @override
  void initState() {
    
    super.initState();

    _tabController = TabController(vsync: this, length: 5)..addListener((){
      setState(() {});
    });

    stream = getQurey;
    delegate = getSearchDelegate;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Stream<QuerySnapshot> get getQurey => Store.instance.bookingRef.snapshots();

  Stream<List<BookingModel>> getSearchQuery(String query) {
    return getDataFromQuery(
      query: buildQuery(
        collection: Store.instance.bookingRef,
      ),
      mapper: (doc) {
        return BookingModel.fromJson(json.decode(json.encode(doc.data)));
      },
      clientSidefilters: [
        (booking) {
          return query.isNotEmpty && (
            (booking?.staffName?.toLowerCase()?.contains(query.toLowerCase()) ?? false) 
            || (booking?.staffNumber?.contains(query) ?? false)
            || (booking?.userName?.toLowerCase()?.contains(query.toLowerCase()) ?? false)
            || (booking?.userNumber?.contains(query) ?? false)
            || (booking?.fromDate?.contains(query) ?? false)
            || (booking?.serviceCode?.startsWith(query) ?? false)
          );
        },
      ],
      orderComparer: (book1, book2) => book2?.fromDate?.compareTo(book1?.fromDate) 
    );
  }

  @override
  Widget build(BuildContext context) => new Scaffold(
    appBar: new AppBar(
      title: new Text(AppLocalizations.of(context).bookings),
      elevation: elevation,
      actions: <Widget>[
        new IconButton(
          icon: new Icon(Icons.search),
          onPressed: () async {
            await showSearch(
              context: context,
              delegate: delegate
            );
          },
        ),
        _tabController.index == 4 ? new IconButton(
          icon: new Icon(Icons.delete),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) {
                return new AlertDialog(
                  title: new Text('Alert'),
                  content: new Text('Are you sure you want to permanently delete these deleted data?'),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text('No'),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                    new FlatButton(
                      child: new Text('Yes'),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    )
                  ],
                );
              }
            ).then((data){
              if(data != null && data){
                Store.instance.bookingRef.where('status', isEqualTo: 3).getDocuments().then((document){
                  if(document != null && document.documents != null) {
                    document.documents.forEach((doc){
                      Store.instance.bookingRef.document(doc.documentID).delete();
                    }); 
                  }
                });
              }
            });
          },
        ) : new Container()
      ],
      bottom: new TabBar(
        isScrollable: true,
        controller: _tabController,
        tabs: ConfigBooking.of(context).tabs.map((item){
          return new Tab(text: item.title);
        }).toList()
      ),
    ),
    body: streamBody,
  );

  SearchDelegate get getSearchDelegate => new SearchListDelegate(
    suggestionBuilder: (context, query, onResult) {
      return new StreamBuilder<List<BookingModel>>(
        stream: getSearchQuery(query),
        builder: (_, AsyncSnapshot<List<BookingModel>> snapshot) {
          if (!snapshot.hasData) return new Center(child: new CircularProgressIndicator());
          
          return snapshot.data != null && snapshot.data.isNotEmpty ? new CardSettings.sectioned(
            showMaterialIOS: true,
            children: snapshot.data.map((item){
              return new BookingItem(item, widget.userData, callback: (){
                delegate.close(context, null);
              }).build(context);
            }).toList()
          ) : new Center(child: new Text(AppLocalizations.of(context).noData));
        },
      );
    },
  ); 

  Widget get streamBody => new StreamBuilder<QuerySnapshot>(
    stream: stream,
    builder: (_, AsyncSnapshot<QuerySnapshot> snapshot){
      if (!snapshot.hasData) return new Center(child: new CircularProgressIndicator());

      return buildPage(snapshot.data.documents);
    },
  );

  Widget buildList(List<BookingModel> list) {
    return list != null && list.isNotEmpty ? new CardSettings.sectioned(
      showMaterialIOS: true,
      children: list.map((item){
        return new BookingItem(item, widget.userData).build(context);
      }).toList(),
    ) : new Center(child: new Text(AppLocalizations.of(context).noData));
  }

  bool filters(index, item) {
    switch(index) { 
      case 0:
      return item?.data['status'] == 0 && item?.data['staffId'] == null;
      case 1:
      return item?.data['status'] == 0 && item?.data['staffId'] != null;
      case 2:
      return item?.data['status'] == 1 && item?.data['staffId'] != null;
      case 3:
      return item?.data['status'] == 2 && item?.data['staffId'] != null;
      case 4:
      return item?.data['status'] == 3 && item?.data['staffId'] != null;
    }
    return true;
  }

  Widget buildPage(List<DocumentSnapshot> list) {
    return new TabBarView(
      controller: _tabController,
      children: ConfigBooking.of(context).tabs.map((item){
        return buildList( 
          list.where((_list){
            return filters(item.value, _list);
          }).map((value){
            return BookingModel.fromJson(json.decode(json.encode(value.data)));
          }).toList()
        );
      }).toList()
    );
  }
}