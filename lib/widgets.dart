export 'widget/color_override.dart';
export 'widget/button_bar.dart';
export 'widget/cut_corners_border.dart';
export 'widget/password_field.dart';
export 'widget/backdrop.dart';
export 'widget/app_logo.dart';
export 'widget/category_page.dart';
export 'widget/material_search.dart';
export 'widget/item_expansion.dart';
export 'widget/async_builder.dart';
export 'widget/async_dialog.dart';
export 'widget/after_layout.dart';
export 'widget/form_field.dart';
export 'widget/list_menu.dart';
export 'widget/background.dart';
export 'widget/title.dart';
export 'widget/card_setting_fromfield.dart';
export 'widget/search_delegate.dart';
export 'widget/form_field.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const double elevation = 1.0;
const EdgeInsets padding = EdgeInsets.all(16.0);

MediaQueryData mediaQueryData(context) => MediaQuery.of(context);
double statusBarHeight(context) => mediaQueryData(context).padding.top;
double screenHeight(context) => mediaQueryData(context).size.height;
double screenWidth(context) => mediaQueryData(context).size.width;
double appBarMaxHeight(context) => screenHeight(context) - statusBarHeight(context);