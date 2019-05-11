import 'package:flutter/material.dart';

import '../widgets.dart';
import './config_support.dart';
import '../l10n/applocalization.dart';

class Support extends StatefulWidget {

  @override
  State<Support> createState() => new _SupportState();
}
class _SupportState extends State<Support> with AfterLayoutMixin{

  List<ExpansionItem> items;

  @override
  void afterFirstLayout(BuildContext context){
    setState(() {
      items = ConfigSupport.of(context).faqs.map((data) {
        return new ExpansionItem(
          name: data.title, 
          builder: (item) {
            return new Container(
              padding: new EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0),
              child: new Text(data.subTtitle),
              decoration: new BoxDecoration(
                border: new Border(top: Divider.createBorderSide(context, width: 1.0))
              ),
            );
          }
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) => new ListView(
    padding: padding,
    children: items != null ? [
      new Text(AppLocalizations.of(context).faqsText, style: Theme.of(context).textTheme.body2.copyWith(color: Theme.of(context).accentColor)),
      new SizedBox(height: 5.0),
      new ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            items[index].isExpanded = !isExpanded;
          });
        },
        children: items.map((item){
          return ExpansionPanel(
            isExpanded: item.isExpanded,
            headerBuilder: item.headerBuilder,
            body: item.build()
          );
        }).toList()
    )
    ]: []
  );
}