import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:banner_view/banner_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../widgets.dart';
import './config_home.dart';
import '../router/routes.dart';
import '../firebase_user.dart';
import '../store/store.dart';
import '../models.dart';
import '../messaging/messaging.dart';
import '../l10n/applocalization.dart';

class Home extends StatefulWidget {

  @override
  State<Home> createState() => new HomeState();
}

class HomeState extends State<Home> with AfterLayoutMixin<Home>{
  
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _curPage = 0;
  UserModel userModel;
  Stream<DocumentSnapshot> _stream;

  @override
  void initState() {
    
    super.initState();

    Messaging.instance.setting();

    Messaging.instance.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        Fluttertoast.showToast(msg: message['notification']['body']);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );

    _stream = getStream();
  }

  @override
  void dispose() {

    Messaging.instance.unSubscribeToTopic();

    super.dispose();
  }

  @override
  afterFirstLayout(context) {
    // _stream = getStream();
  }

  Future<bool> onWillPop() async {
    if (userModel == null) {
      return true;
    } else {
      if (_curPage == 0) {
        return true;
      } else {
        setState(() {
          _curPage = 0;
        });
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) => new Scaffold(
    key: _scaffoldKey,
    appBar: new AppBar(
      elevation: elevation,
      title: new Text(ConfigHome.menus(context, userModel)[_curPage]?.title ?? ''),
      leading: IconButton(
        icon: new Icon(Icons.menu),
        onPressed: () {
          _scaffoldKey.currentState.openDrawer();
        },
      ),
    ),
    body: new WillPopScope(
      onWillPop: onWillPop,
      child: streamView,
    ),
    drawer: userModel != null ? new MyDrawer(userData: userModel, onChange: (value) {
      if (value.child != null) {
        if (_curPage != value.value) {
          setState(() {
            _curPage = value.value;
          });
        }
        _scaffoldKey.currentState.openEndDrawer();
      } else {
        value?.callback();
      }
    }) : null,
  );

  Stream<DocumentSnapshot> getStream() {
    return Store.instance.userRef.snapshots()..listen((onData){
      if (onData != null) {
        if (onData.data == null || onData.data['category'] == null) {
          Routes.instance.navigateTo(context, Routes.instance.category, replace: true, transition: TransitionType.inFromRight);
        } else {
          if (mounted) {
            setState(() {
              userModel = UserModel.fromJson(json.decode(json.encode(onData.data)));
              Messaging.instance.subscribeToTopic(userModel);
            });
          }
        }
      }
    });
  }

  Widget get streamView => new StreamBuilder<DocumentSnapshot>(
    stream: _stream,
    builder: (_, snapshot){
      if (!snapshot.hasData) {
        return new Center(child:  new CircularProgressIndicator());
      } else {
        return new BackGroundView(
          body: ConfigHome.menus(context, userModel)[_curPage].child,
          backgroundColor: Colors.black12,
        );
      }
    },
  );
}

class MyDrawer extends StatefulWidget {

  MyDrawer({
    this.userData,
    this.onChange
  });

  final ValueChanged onChange;
  final UserModel userData;

  @override
  State<MyDrawer> createState() => new _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  
  String photoUrl;

  @override
  void initState() {
    
    super.initState();

    photoUrl = UserWithFirebase.instance.firebaseUser?.photoUrl;
  }

  @override
  Widget build(BuildContext context) => new Drawer(
    child: Column(
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: new Text(UserWithFirebase.instance.firebaseUser.displayName),
          accountEmail: new Text(UserWithFirebase.instance.firebaseUser.email),
          currentAccountPicture: new Image.asset('assets/title.png')
        ),
        MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 8.0),
              children: ConfigHome.menus(context, widget.userData).map((item){
                return new ListTile(
                  leading: item.leading,
                  title: new Text(item.subtitle),
                  onTap: () => onPressed(item)
                );
              }).toList()
            ),
          ),
        ),
      ],
    ),
  );

  void onPressed(ListMenu value) {
    widget.onChange(value);
  }
}

class HomePage extends StatefulWidget {

  HomePage(this.userData);

  final UserModel userData;

  @override
  State<HomePage> createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) => body;

  Widget get body => widget.userData != null ? new GridTile(
    footer: bottomView,
    child: new Flex(
      direction: Axis.vertical,
      children: <Widget>[
        new Visibility(
          visible: widget.userData.category < 2,
          child: new Flexible(
            flex: 0, 
            child: bannerView
          ),
        ),
        new Flexible(
          flex: 0,
          child: categoryView,
        ),
        new Flexible(
          child: new Container(),
        ),
      ],
    ),
  ) : new Container(); 

  Widget get bannerView => new AspectRatio(
    aspectRatio: 4.0 / 1.7 ,
    // height: 140.0,
    child: new BannerView( 
      [
        new Image.asset('assets/slide1.jpg', fit: BoxFit.fill),
        new Image.asset('assets/slide2.jpg', fit: BoxFit.fill),
        new Image.asset('assets/slide3.jpg', fit: BoxFit.fill),
        new Image.asset('assets/slide4.jpg', fit: BoxFit.fill),
        new Image.asset('assets/slide5.jpg', fit: BoxFit.fill), 
      ],
      log: false,
      intervalDuration: new Duration(seconds: 3),
      indicatorBuilder: (BuildContext context, Widget indicatorWidget) {
        return new Align(
          alignment: Alignment.bottomRight,
          child: new Container(
            height: 40.0,
            padding: new EdgeInsets.symmetric(horizontal: 16.0),
            child: indicatorWidget,
          )
        );
      },
      indicatorSelected: new Container(
        width: 8.0,
        height: 8.0,
        decoration: new BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).iconTheme.color,
        ),
      ),
    )
  );

  List<Category> getCategories(UserModel user) {
    switch(user.category){
      case 0: // cusertomer
      case 1: // company
        return ConfigHome.clientCategories(context);
      case 2: // freelancer
      case 3: // staff
        return ConfigHome.workerCategories(context);
      case 4: // operator
        return ConfigHome.operatorCategories(context);
    }
    return null;
  }

  void getCategoriesFun(Category category, UserModel user) {
    switch(category.value) {
      case 0:
      case 1:
      case 2:
      case 3:
        Routes.instance.navigateTo(context, Routes.instance.bookingCreate, transition: TransitionType.nativeModal, object: {'category':category, 'userData': widget.userData});
      break;
      case 4:
        Routes.instance.navigateTo(context, Routes.instance.bookingList, transition: TransitionType.inFromRight, object: {'viewData': widget.userData, 'userData': widget.userData});
      break;
      case 5:
        Routes.instance.navigateTo(context, Routes.instance.bookingPage, transition: TransitionType.inFromRight, object: widget.userData);
      break;
      case 6:
        Routes.instance.navigateTo(context, Routes.instance.users, transition: TransitionType.inFromRight, object: widget.userData);
      break;
      case 7:
        Routes.instance.navigateTo(context, Routes.instance.whiteList, transition: TransitionType.inFromRight, object: widget.userData);
      break;
      case 8:
        Routes.instance.navigateTo(context, Routes.instance.upload, transition: TransitionType.inFromRight);
    }
  }

  Widget get categoryView => new CategoriesPage(
    categories: getCategories(widget.userData),
    onCategoryTap: (Category category) {
      getCategoriesFun(category, widget.userData);
    },
  );

  Widget get bottomView => new Stack(
    children: <Widget>[
      new Opacity(
        opacity: 0.5,
        child: new Container(
          height: 90.0,
          width: double.infinity,
          color: Colors.white,
        ),
      ),
     
     new Column(
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(AppLocalizations.of(context).assistance, style: Theme.of(context).textTheme.title.copyWith(color: Theme.of(context).accentColor)),
                new SizedBox(height: 5.0),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Flag(
                      title: 'Email to',
                      sub: 'support@eletec.ae',
                      icon: Icons.alternate_email,
                      callback: _launchEmail,
                    ), 
                    new Flag(
                      title: 'Call on',
                      sub: '04-250-0090',
                      icon: Icons.phone,
                      callback: _launchTel,
                    ), 
                  ],
                ),
              ],
            )
          ),
          new Container(
            padding: new EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
            width: double.infinity,
            color: Theme.of(context).accentColor,
            child: new Text('@Copyright Eletec Technical Works', style: new TextStyle(color: Colors.white)),
          )
        ],
      ),
    ],
  );

  _launchTel() async {
    const url = 'tel:<042500090>';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchEmail() async {
    const url = 'mailto:support@eletec.ae';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class Flag extends StatelessWidget {
  
  Flag({
    this.icon,
    this.title,
    this.sub,
    this.callback
  });

  final IconData icon;
  final String title;
  final String sub;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) => new GestureDetector(
    onTap: callback,
    child: new Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        new Icon(icon),
        new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Text(title, style: new TextStyle(color: Colors.black54)),
            new Text(sub, style: new TextStyle(color: Theme.of(context).accentColor)),
          ],
        )
      ],
    )
  );
}