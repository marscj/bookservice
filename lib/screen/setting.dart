import 'package:flutter/material.dart';

import '../my_flutter_app_icons.dart';
import '../widgets.dart';
import '../router/routes.dart';
import '../models.dart';
import '../l10n/applocalization.dart';

class Setting extends StatelessWidget {
  
  Setting(this.userData);
  
  final UserModel userData;

  @override
  Widget build(BuildContext context) => new ListView(
    padding: padding,
    children: <Widget>[
      new ListTile(
        leading: new Icon(MyFlutterApp.user),
        title: new Text(AppLocalizations.of(context).userProfile),
        onTap: () {
          Routes.instance.navigateTo(context, Routes.instance.profile, transition: TransitionType.inFromRight);
        },
      ),
      new Visibility(
        visible: userData.category < 2,
        child: new ListBody(
          children: <Widget>[
            new Divider(),
            ListTile(
              leading: new Icon(MyFlutterApp.address),
              title: new Text(AppLocalizations.of(context).address),
              onTap: () {
                Routes.instance.navigateTo(context, Routes.instance.addr, transition: TransitionType.inFromRight, object: userData);
              },
            ),
          ],
        ),
      ),
      new Visibility(
        visible: userData.category < 2,
        child: new ListBody(
          children: <Widget>[
            new Divider(),
            ListTile(
              leading: new Icon(Icons.insert_drive_file),
              title: new Text(AppLocalizations.of(context).contract),
              onTap: () {
                Routes.instance.navigateTo(context, Routes.instance.contract, transition: TransitionType.inFromRight, object: {'viewData': userData, 'userData': userData});
              },
            )
          ],
        ),
      ),
      new Visibility(
        visible: userData.category == 2,
        child: new ListBody(
          children: <Widget>[
            new Divider(),
            ListTile(
              leading: new Icon(MyFlutterApp.address),
              title: new Text(AppLocalizations.of(context).freelancerProfile),
              onTap: () {
                Routes.instance.navigateTo(context, Routes.instance.freelancerProfile, transition: TransitionType.inFromRight, object: userData);
              },
            )
          ],
        ),
      ),
      new Divider(),
      new ListTile(
        leading: new Icon(Icons.language),
        title: new Text(AppLocalizations.of(context).language),
        onTap: () {
          Routes.instance.navigateTo(context, Routes.instance.language, transition: TransitionType.inFromRight, object: {'canBack': true});
        },
      ),
    ],
  );
}