import 'package:auto_route/auto_route.dart';
import 'package:bookservice/I18n/i18n.dart';
import 'package:bookservice/apis/client.dart';
import 'package:bookservice/bloc/address_bloc.dart';
import 'package:bookservice/router/router.gr.dart';
import 'package:card_settings/card_settings.dart';
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
        child: ExtendedNavigator(
          name: 'address',
          initialRoute: AddressPageRoutes.addressListPage,
        ));
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

  const AddressItem({Key key, this.data}) : super(key: key);

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
          labelWidth: 100,
          fieldPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          children: [
            CardSettingsSection(
              header: CardSettingsHeader(
                  child: Container(
                color: Colors.blue,
                margin: EdgeInsets.all(0.0),
                padding: EdgeInsets.only(
                    left: 14.0, top: 8.0, right: 14.0, bottom: 8.0),
                height: 50,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    data.defAddr
                        ? Expanded(
                            child: Text(
                              'Default',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          )
                        : Container(
                            alignment: Alignment.topCenter,
                            child: IconButton(
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
                          ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.white),
                      onPressed: () {},
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
              ],
            )
          ],
        );
      }),
    );
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
