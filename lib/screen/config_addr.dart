import 'package:flutter/widgets.dart';

import '../widgets.dart';
import '../l10n/applocalization.dart';

class ConfigAddr {

  List<AnyItem> typeItems;

  ConfigAddr();

  factory ConfigAddr.of(BuildContext context) {
    return new ConfigAddr()..typeItems = [
      new AnyItem(
        value: 0,
        valueText: AppLocalizations.of(context).apartment
      ),
      new AnyItem(
        value: 1,
        valueText: AppLocalizations.of(context).villa
      )
    ];
  }
}