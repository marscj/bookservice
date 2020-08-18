import 'package:bookservice/I18n/i18n.dart';
import 'package:bookservice/bloc/order_bloc.dart';
import 'package:bookservice/views/rally_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import 'order.dart';
import 'service.dart';
import 'setting.dart';

class CustomerPage extends StatefulWidget {
  @override
  _CustomerPageState createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderBloc>(
        create: (_) => OrderBloc(context),
        child: FocusTraversalGroup(
          policy: OrderedTraversalPolicy(),
          child: Column(
            children: [
              RallyTabBar(
                tabs: buildTabs(
                    context,
                    Theme.of(context).textTheme.button.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue)),
                tabController: _tabController,
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: buildTabViews(),
                ),
              ),
            ],
          ),
        ));
  }

  List<Widget> buildTabViews() {
    return [ServicePage(), OrderListPage(), SettingPage()];
  }

  List<Widget> buildTabs(context, textStyle) {
    return [
      RallyTab(
        textStyle: textStyle,
        iconData: Icons.phone,
        title: Localization.of(context).services,
        tabIndex: 0,
        tabController: _tabController,
        isVertical: false,
        color: Colors.blue,
        tabCount: 3,
      ),
      RallyTab(
        textStyle: textStyle,
        iconData: Icons.date_range,
        title: Localization.of(context).orders,
        tabIndex: 1,
        tabController: _tabController,
        isVertical: false,
        color: Colors.blue,
        tabCount: 3,
      ),
      RallyTab(
        textStyle: textStyle,
        iconData: Icons.settings,
        title: Localization.of(context).settings,
        tabIndex: 2,
        tabController: _tabController,
        isVertical: false,
        color: Colors.blue,
        tabCount: 3,
      ),
    ];
  }
}
