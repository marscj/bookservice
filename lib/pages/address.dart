import 'package:auto_route/auto_route.dart';
import 'package:bookservice/I18n/i18n.dart';
import 'package:bookservice/apis/client.dart';
import 'package:bookservice/bloc/address_bloc.dart';
import 'package:bookservice/router/router.gr.dart';
import 'package:bookservice/views/dialog.dart';
import 'package:card_settings/card_settings.dart';
import 'package:card_settings/interfaces/minimum_field_properties.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// ignore_for_file: close_sinks
class AddressPage extends StatefulWidget {
  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AddressBloc(this.context),
        child: BlocListener<AddressBloc, AddressState>(
            listener: (context, state) {
              if (state.isLoading) {
                LoadingDialog.show(context);
              } else {
                LoadingDialog.hide(context);
              }
            },
            child: ExtendedNavigator(
              name: 'address',
              initialRoute: AddressPageRoutes.addressListPage,
            )));
  }
}

class AddressListPage extends StatefulWidget {
  @override
  _AddressListPageState createState() => _AddressListPageState();
}

class _AddressListPageState extends State<AddressListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Localization.of(context).address),
        leading: BackButton(onPressed: () {
          context.navigator.root.pop();
        }),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              context.navigator.push('${null}/post');
            },
          )
        ],
      ),
      body: BlocBuilder<AddressBloc, AddressState>(
        builder: (context, state) {
          AddressBloc bloc = BlocProvider.of<AddressBloc>(context);

          return SmartRefresher(
            enablePullDown: true,
            enablePullUp: false,
            header: WaterDropHeader(),
            footer: CustomFooter(
              builder: (BuildContext context, LoadStatus mode) {
                Widget body;
                if (mode == LoadStatus.idle) {
                  body = Text("pull up load");
                } else if (mode == LoadStatus.loading) {
                  body = CupertinoActivityIndicator();
                } else if (mode == LoadStatus.failed) {
                  body = Text("Load Failed!Click retry!");
                } else if (mode == LoadStatus.canLoading) {
                  body = Text("release to load more");
                } else {
                  body = Text("No more Data");
                }
                return Container(
                  height: 55.0,
                  child: Center(child: body),
                );
              },
            ),
            controller: bloc.refreshController,
            onRefresh: () => bloc.add(AddressRefreshList()),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemBuilder: (c, i) => AddressItem(
                data: state.list[i],
              ),
              itemCount: state.list.length,
            ),
          );
        },
      ),
    );
  }
}

class AddressItem extends StatelessWidget {
  final Address data;
  final Builder builder;

  const AddressItem({Key key, this.data, this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(
            secondaryHeaderColor: Colors.blue, // card header background
            cardColor: Colors.white, // card field background
            buttonColor: Colors.blue, // button background color
            textTheme: Theme.of(context).textTheme.copyWith(
                  button: Theme.of(context)
                      .textTheme
                      .button
                      .copyWith(color: Colors.white), // button text
                  subtitle1: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(color: Colors.black87), // input text
                  headline6: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(color: Colors.white), // card header text
                ),
            inputDecorationTheme: InputDecorationTheme(
              labelStyle: TextStyle(color: Colors.black87), // style for labels
            ),
            cardTheme: CardTheme(
                shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ))),
        child: Builder(builder: (context) {
          return CardSettings.sectioned(
            showMaterialonIOS: true,
            fieldPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            margin: const EdgeInsets.all(0),
            divider: Divider(),
            children: [
              CardSettingsSection(
                header: CardSettingsHeader(
                    child: Container(
                  color: Colors.blue,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      data.defAddr
                          ? IconButton(
                              icon: Icon(
                                Icons.radio_button_checked,
                                color: Colors.white,
                              ),
                              onPressed: () {},
                            )
                          : IconButton(
                              icon: Icon(
                                Icons.radio_button_unchecked,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                BlocProvider.of<AddressBloc>(context).add(
                                    AddressUpdateList(
                                        data.id, {'defAddr': true}));
                              },
                            ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.white),
                        onPressed: () {
                          BlocProvider.of<AddressBloc>(context)
                              .add(AddressDelList(data.id));
                        },
                      )
                    ],
                  ),
                )),
                children: [
                  CardSettingsField(
                    fieldPadding: null,
                    labelAlign: null,
                    requiredIndicator: null,
                    label: 'Address',
                    content: Text(data.toTitle),
                  ),
                  CardSettingsButtonEx(
                    label: 'View Detail',
                    isDestructive: false,
                    backgroundColor: Theme.of(context).cardColor,
                    textColor: Theme.of(context).buttonColor,
                    onPressed: () {},
                  )
                ],
              )
            ],
          );
        }));
  }
}

class AddressPostPage extends StatefulWidget {
  @override
  _AddressPostPageState createState() => _AddressPostPageState();
}

class _AddressPostPageState extends State<AddressPostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Localization.of(context).address),
      ),
    );
  }
}

class CardSettingsButtonEx extends StatelessWidget
    implements IMinimumFieldSettings {
  CardSettingsButtonEx({
    this.label: 'Label',
    @required this.onPressed,
    this.visible: true,
    this.backgroundColor,
    this.textColor,
    this.enabled = true,
    this.bottomSpacing: 0.0,
    this.isDestructive = false,
  });

  final String label;

  final bool isDestructive;
  final Color backgroundColor;
  final Color textColor;
  final double bottomSpacing;
  final bool enabled;
  @override
  final bool visible;

  // Events
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    TextStyle buttonStyle =
        Theme.of(context).textTheme.button.copyWith(color: textColor);

    if (visible) {
      return showMaterialButton(context, buttonStyle);
    } else {
      return Container();
    }
  }

  Widget showMaterialButton(BuildContext context, TextStyle buttonStyle) {
    var fillColor = backgroundColor ?? Theme.of(context).buttonColor;
    if (!enabled) fillColor = Colors.grey;

    return Container(
      // margin: EdgeInsets.only(
      //     top: 4.0, bottom: bottomSpacing, left: 4.0, right: 4.0),
      padding: EdgeInsets.all(0.0),
      color: fillColor,
      child: RawMaterialButton(
        padding: EdgeInsets.all(0.0),
        elevation: 0.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              label,
              style: buttonStyle,
            ),
          ],
        ),
        fillColor: fillColor,
        onPressed: (enabled)
            ? onPressed
            : null, // to disable, we need to not provide an onPressed function
      ),
    );
  }

  @override
  bool get showMaterialonIOS => true;
}
