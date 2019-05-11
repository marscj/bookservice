import 'package:flutter/widgets.dart';

import '../widgets.dart';
import '../l10n/applocalization.dart';

class ConfigUsers {

  ConfigUsers._();

  List<ListMenu> tabs;

  List<ListMenu> staffTabs;

  List<ListMenu> options;

  List<ListMenu> visits;

  factory ConfigUsers.of(BuildContext context) {
    return new ConfigUsers._()..tabs = List.generate(5, (index){
      return new ListMenu(
        value: [3, 2, 4, 0, 1][index],
        title: AppLocalizations.of(context).userTabs[index]
      );
    })..staffTabs = List.generate(2, (index){
      return new ListMenu(
        value: [3, 2][index],
        title: AppLocalizations.of(context).staffTabs[index]
      );
    })..options = List.generate(4, (index){
      return new ListMenu(
        value: index,
        title: AppLocalizations.of(context).contractOptions[index]
      );
    })..visits = [
      new ListMenu(
        value: 0, 
        title: 'A/C',
      ),
      new ListMenu(
        value: 1,
        title: 'Electrical',
      ),
      new ListMenu(
        value: 2,
        title: 'Plumbing',
      ),
      new ListMenu(
        value: 3,
        title: 'Water Tank',
      ),
      new ListMenu(
        value: 4,
        title: 'Duct Cleaning',
      ),
      new ListMenu(
        value: 5,
        title: 'Emergency'
      ),
    ];
  }
}