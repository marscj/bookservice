import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../auth/auth_callback.dart';
import '../widgets.dart';
import '../store/store.dart';
import '../firebase_user.dart';
import '../models.dart';
import '../l10n/applocalization.dart';

class CategoryPage extends StatefulWidget {

  CategoryPage(this.callback);

  final AuthCallback callback;

  @override
  State<CategoryPage> createState() => new _CategoryPageState();
}
class _CategoryPageState extends State<CategoryPage> {

  int curPage = 0;
  PageController _pageController;
  
  @override
  void initState() { 
    
    super.initState();

    _pageController = new PageController(keepPage: true)..addListener((){
      setState(() {
        curPage = _pageController.page.round();
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: appBar,
      body: futureBody,
    );
  }

  AppBar get appBar => new AppBar(
    elevation: elevation,
    title: new Text(AppLocalizations.of(context).userCategory),
    leading: curPage == 1 ? new IconButton( 
      icon: new BackButtonIcon(),
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      onPressed: () {
        _pageController.previousPage(duration: Duration(milliseconds: 400), curve: Curves.fastOutSlowIn);
      }
    ) : null,
  ); 

  Widget get futureBody => new FutureBuilder<bool>(
    future: FirebaseAuth.instance.currentUser().then((user){
      return Store.instance.whiteList.getDocuments().then((doc){
        if (doc != null && doc.documents != null){
          return doc.documents.map((item){
            return new WhiteListModel.fromJson(item.data); 
          }).toList();
        }
      }).then((listmodel) {
        if (listmodel != null) {
          return listmodel.firstWhere((item){ 
            return item.phoneNumber.contains(user.phoneNumber.substring(4));
          }, orElse: (){
            return null;
          });
        }
        return null;
      })
      .then<bool>((whitelist){ 
        if(whitelist != null) {
          onCategory(whitelist.category, true, whitelist.isAdmin);
          return false;
        }
        return true;
      });
    }), 
    builder: (_, AsyncSnapshot<dynamic> snapshot) {
      if (!snapshot.hasData) return new Center(child: new CircularProgressIndicator());
      return snapshot.data ? page : new Container();
    },
  );

  Widget get page => new PageView(
    controller: _pageController,
    physics: new NeverScrollableScrollPhysics(),
    children: <Widget>[
      new Center(
        child: new Container(
          width: 250.0,
          height: 250.0,
          child: new Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Flexible(
                flex: 0,
                child: new Text(AppLocalizations.of(context).register, style: Theme.of(context).textTheme.body2.copyWith(color: Colors.black54)),
              ),
              new Flexible(
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    iconText('assets/person.jpg', 'Register as Individual', () {
                      _pageController.nextPage(duration: Duration(milliseconds: 400), curve: Curves.fastOutSlowIn);
                    }),
                    iconText('assets/company.jpg', 'Register as Company', () {
                      onCategory(1, true, false);
                    }),
                  ],
                )
              ),
            ],
          ),
          decoration: new BoxDecoration(
            color: Colors.black12,
            borderRadius: new BorderRadius.circular(10.0)
          ),
        )
      ),
      new Center(
        child: new Container(
          width: 250.0,
          height: 250.0,
          child: new Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Flexible(
                flex: 0,
                child: new Text(AppLocalizations.of(context).areYou, style: Theme.of(context).textTheme.body2.copyWith(color: Colors.black54)),
              ),
              new Flexible(
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    iconText('assets/customer.jpg', 'A Customer', () {
                      onCategory(0, true, false);
                    }),
                    iconText('assets/freelancer.jpg', 'A Freelance', () {
                      onCategory(2, false, false);
                    }),
                  ],
                ),
              ),
            ],
          ),
          decoration: new BoxDecoration(
            color: Colors.black12,
            borderRadius: new BorderRadius.circular(10.0)
          ),
        )
      )
    ],
  );

  Widget iconText (String asset, String text, callback) {
    Widget widget = new Container(
      width: 100.0,
      height: 180.0,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Image.asset(
            asset, 
            width: 60.0 , 
            height: 60.0,
            color: Colors.black12,
            colorBlendMode: BlendMode.darken
          ),
          new SizedBox(height: 1.0),
          new Container(
            alignment: Alignment.center,
            padding: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: new Text(text, style: Theme.of(context).textTheme.button.copyWith(color: Colors.white)),
            decoration: new BoxDecoration(
              color: Theme.of(context).iconTheme.color,
              borderRadius: new BorderRadius.circular(8.0)
            ),
          )
        ],
      )
    );

    return new GestureDetector(
      child: widget,
      onTap: callback,
    );
  } 

  Future<String> onCategory(category, isEnable, isAdmin) async {
    
    FirebaseUser user = UserWithFirebase.instance.firebaseUser;

    return asyncDialog(
      context: context, 
      barrierDismissible: true,  
      future: Store.instance.userRef.setData({'category': category, 'isAdmin': isAdmin, 'isEnable': isEnable, 'profile': {'userId': user.uid ,'displayName': user.displayName, 'phoneNumber': user.phoneNumber,'email': user.email, 'isEmailVerified': user.isEmailVerified}}, merge: true).then((onValue){
        return category;
      }).timeout(new Duration(seconds: 10), onTimeout: (){
        Fluttertoast.showToast(msg: 'Network error (such as timeout, interrupted connection or unreachable host) has occurred.');
      })
      .catchError((onError){
        return onError;
      })
    ).then((onValue){
      if (onValue != null) {
        widget.callback(context);
      }
    });
  }
}