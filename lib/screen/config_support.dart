import 'package:flutter/widgets.dart';

import '../l10n/applocalization.dart';
import '../l10n/localization.dart';

class ConfigSupport{

  ConfigSupport._();

  List<FAQ> faqs;

  factory ConfigSupport.of(BuildContext context) {
    return new ConfigSupport._()..faqs = AppLocalizations.of(context).faqs;
  }
}