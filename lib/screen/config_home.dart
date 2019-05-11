import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../my_flutter_app_icons.dart';
import 'package:flutter_svg/svg.dart';

import '../widgets.dart';
import './home.dart';
import './booking.dart';
import './setting.dart';
import './support.dart';
import '../models.dart';
import '../l10n/applocalization.dart';

class ConfigHome {

  ConfigHome();

  static List<Category> clientCategories(context) {
    return List<Category>.generate(3, (index){
      return new Category(
        index,
        name: AppLocalizations.of(context).clientCategories[index],
        icon: [
          new SvgPicture.asset('assets/ac.svg', color: Theme.of(context).iconTheme.color, width: 60.0, height: 60.0),
          new SvgPicture.asset('assets/electrical.svg', color: Theme.of(context).iconTheme.color, width: 60.0, height: 60.0),
          new SvgPicture.asset('assets/plumbing.svg', color: Theme.of(context).iconTheme.color, width: 60.0, height: 60.0),
          // new SvgPicture.asset('assets/cleaning.svg', color: Theme.of(context).iconTheme.color, width: 60.0, height: 60.0),
        ][index]
      );
    });
  }

  static List<Category> workerCategories(context) {
    return List<Category>.generate(1, (index){
      return new Category(
        4,
        name: AppLocalizations.of(context).workerCategories[index],
        icon: new Icon(Icons.list, size: 60.0)
      );
    });
  }

  static List<Category> operatorCategories(context) {
    return List<Category>.generate(3, (index){
      return new Category(
        [5, 6, 7][index],
        name: AppLocalizations.of(context).operatorCategories[index],
        icon: [Icons.list, Icons.person, Icons.featured_play_list].map((item){
          return new Icon(item, size: 60.0);
        }).toList()[index]
      );
    });
  }

  static List<ListMenu> menus(context, UserModel userData) {
    
    if (userData == null || userData.category == null) {
      return [
        ListMenu(
          value: 0,
          title: AppLocalizations.of(context).eletec,
          subtitle: AppLocalizations.of(context).home,
          leading: new Icon(Icons.home),
          child: new HomePage(userData)
        ),
      ];
    } else {
      switch(userData.category) {
        case 0:
        case 1:
        return [
          ListMenu(
            value: 0,
            title: AppLocalizations.of(context).eletec,
            subtitle: AppLocalizations.of(context).home,
            leading: new Icon(Icons.home),
            child: new HomePage(userData)
          ),

          ListMenu(
            value: 1,
            title: AppLocalizations.of(context).bookings,
            subtitle: AppLocalizations.of(context).bookings,
            leading: new Icon(Icons.list),
            child: new BookingList(viewData: userData, userData: userData, isShowAppBar: false)
          ),

          ListMenu(
            value: 2,
            title: AppLocalizations.of(context).settings,
            subtitle: AppLocalizations.of(context).settings,
            leading: new Icon(Icons.settings),
            child: new Setting(userData)
          ),

          ListMenu(
            value: 3,
            title: AppLocalizations.of(context).support,
            subtitle: AppLocalizations.of(context).support,
            leading: new Icon(Icons.help),
            child: new Support()
          ),

          ListMenu(
            value: 4,
            title: AppLocalizations.of(context).signout,
            subtitle: AppLocalizations.of(context).signout,
            leading: new Icon(MyFlutterApp.logout),
            callback: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushNamedAndRemoveUntil('/', ModalRoute.withName('/'));
            }
          ),
        ];
        case 2:
        case 3:
        case 4:
        return [
          ListMenu(
            value: 0,
            title: AppLocalizations.of(context).eletec,
            subtitle: AppLocalizations.of(context).home,
            leading: new Icon(Icons.home),
            child: new HomePage(userData)
          ),
          ListMenu(
            value: 1,
            title: AppLocalizations.of(context).settings,
            subtitle: AppLocalizations.of(context).settings,
            leading: new Icon(Icons.settings),
            child: new Setting(userData)
          ),
          ListMenu(
            value: 2,
            title: AppLocalizations.of(context).support,
            subtitle: AppLocalizations.of(context).support,
            leading: new Icon(Icons.help),
            child: new Support()
          ),
          ListMenu(
            value: 3,
            title: AppLocalizations.of(context).signout,
            subtitle: AppLocalizations.of(context).signout,
            leading: new Icon(MyFlutterApp.logout),
            callback: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushNamedAndRemoveUntil('/', ModalRoute.withName('/'));
            }
          ),
        ];
      }
    }
    return null;
  }
}