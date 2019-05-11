import 'package:flutter/widgets.dart';

import '../widgets.dart';
import '../l10n/applocalization.dart';

class ConfigBooking {
  
  List<ListMenu> tabs;

  List<List<AnyItem>> additionalFirst;

  List<List<List<AnyItem>>> additionalSecond;

  List<List<AnyItem>> additionalSecondIssue;

  ConfigBooking();

  factory ConfigBooking.of(BuildContext context) {
    return new ConfigBooking()..tabs = List<ListMenu>.generate(5, (index){
      return new ListMenu(
          value: index,
          title: AppLocalizations.of(context).bookingTabs[index],
        );
    })..additionalFirst = List<List<AnyItem>>.generate(4, (i){
      return List.generate(AppLocalizations.of(context).additionalFirst[i].length, (j){
        return new AnyItem(
          value: j,
          valueText: AppLocalizations.of(context).additionalFirst[i][j]
        );
      });
    })
    ..additionalSecond = List<List<List<AnyItem>>>.generate(4, (i){
      return List.generate(AppLocalizations.of(context).additionalSecond[i].length, (j){
        return List.generate(AppLocalizations.of(context).additionalSecond[i][j].length, (k){
          return AnyItem(
            value: k == AppLocalizations.of(context).additionalSecond[i][j].length -1 ? -1 : k,
            valueText: AppLocalizations.of(context).additionalSecond[i][j][k]
          );
        });
      });
    })
    ..additionalSecondIssue = List<List<AnyItem>>.generate(4, (i){
      return List.generate(AppLocalizations.of(context).additionalSecondIssue[i].length, (j){
        return new AnyItem(
          value: null,
          valueText: AppLocalizations.of(context).additionalSecondIssue[i][j]
        );
      });
    });
  }
}