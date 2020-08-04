import 'package:animate_do/animate_do.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bookservice/I18n/i18n.dart';
import 'package:bookservice/apis/client.dart';
import 'package:bookservice/bloc/address_bloc.dart';
import 'package:bookservice/bloc/load_bloc.dart';
import 'package:bookservice/constanc.dart';
import 'package:bookservice/router/router.gr.dart';
import 'package:bookservice/views/dialog.dart';
import 'package:card_settings/card_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'load.dart';

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
          initialRoute: AddressPageRoutes.list,
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
              context.navigator.push('/post');
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
            fieldPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            margin: const EdgeInsets.all(0),
            divider: Divider(),
            children: [
              CardSettingsSection(
                children: [
                  CardSettingsField(
                    fieldPadding: null,
                    labelAlign: null,
                    requiredIndicator: null,
                    label: 'Address',
                    content: Text(data.toTitle),
                  ),
                  CardSettingsButton(
                    label: 'View Detail',
                    isDestructive: true,
                    backgroundColor: Theme.of(context).cardColor,
                    textColor: Theme.of(context).buttonColor,
                    onPressed: () {
                      context.navigator.push('/put');
                    },
                  )
                ],
              )
            ],
          );
        }));
  }
}

class AddressPostPage extends StatefulWidget {
  final Address data;

  const AddressPostPage({Key key, this.data}) : super(key: key);

  @override
  _AddressPostPageState createState() => _AddressPostPageState();
}

class _AddressPostPageState extends State<AddressPostPage> {
  @override
  Widget build(BuildContext context) {
    int id = RouteData.of(context).pathParams['id'].intValue;

    Widget body = MultiBlocProvider(
        providers: [
          BlocProvider<AddressPostBloc>(
            create: (context) => AddressPostBloc(),
          ),
          BlocProvider<AddressFormBloc>(
            create: (_) => AddressFormBloc(context),
          ),
          BlocProvider<AddressMapBloc>(
            create: (_) => AddressMapBloc(context),
          ),
        ],
        child: BlocBuilder<AddressPostBloc, AddressPostState>(
            builder: (context, state) {
          AddressPostBloc postBloc = BlocProvider.of<AddressPostBloc>(context);
          AddressMapBloc mapBloc = BlocProvider.of<AddressMapBloc>(context);
          AddressFormBloc formBloc = BlocProvider.of<AddressFormBloc>(context);
          return LoadPage(
            loading: id != null,
            builder: (context) {
              return ListView(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: <Widget>[
                  state.data.onMap
                      ? FormBlocListener<AddressMapBloc, String, String>(
                          child: ListBody(children: <Widget>[
                          DropdownFieldBlocBuilder(
                            showEmptyItem: false,
                            decoration: InputDecoration(
                                labelText: 'Model',
                                border: OutlineInputBorder()),
                            itemBuilder: (context, value) =>
                                ['Personal', 'Company'][value],
                            selectFieldBloc: mapBloc.model,
                          ),
                          DropdownFieldBlocBuilder(
                            showEmptyItem: false,
                            decoration: InputDecoration(
                                labelText: 'Style',
                                border: OutlineInputBorder()),
                            itemBuilder: (context, value) =>
                                ['Apartment', 'Villa'][value],
                            selectFieldBloc: mapBloc.style,
                          ),
                          TextFieldBlocBuilder(
                            textFieldBloc: mapBloc.lat
                              ..updateInitialValue('${state.data.lat ?? ''}'),
                            isEnabled: false,
                            decoration: InputDecoration(
                                labelText: 'Latitude',
                                border: OutlineInputBorder()),
                          ),
                          TextFieldBlocBuilder(
                            textFieldBloc: mapBloc.lng
                              ..updateInitialValue('${state.data.lng ?? ''}'),
                            isEnabled: false,
                            decoration: InputDecoration(
                                labelText: 'Longitude',
                                border: OutlineInputBorder()),
                          ),
                          TextFieldBlocBuilder(
                            textFieldBloc: mapBloc.address
                              ..updateInitialValue(state.data.address),
                            isEnabled: false,
                            maxLines: 3,
                            decoration: InputDecoration(
                                labelText: 'Address',
                                border: OutlineInputBorder()),
                          ),
                          FlatButton(
                            child: Text('Select again on the map'),
                            onPressed: () {
                              showLocationPicker(context, Constant.ApiKey,
                                      myLocationButtonEnabled: true,
                                      layersButtonEnabled: true,
                                      automaticallyAnimateToCurrentLocation:
                                          true)
                                  .then((value) {
                                if (value != null) {
                                  postBloc.add(AddressUpdate(state.data
                                      .copyWidth(
                                          lat: value.latLng.latitude,
                                          lng: value.latLng.longitude,
                                          address: value.address ?? '')));
                                }
                              });
                            },
                          ),
                          RaisedButton(
                            child: Text('I want to fill in manually'),
                            onPressed: () async {
                              postBloc.add(AddressUpdate(
                                  state.data.copyWidth(onMap: false)));
                            },
                          ),
                          SizedBox(height: 10),
                          RaisedButton(
                            child: Text(Localization.of(context).submit),
                            onPressed: () async {
                              mapBloc.submit();
                            },
                          ),
                        ]))
                      : FormBlocListener<AddressFormBloc, String, String>(
                          child: ListBody(children: <Widget>[
                          DropdownFieldBlocBuilder(
                            showEmptyItem: false,
                            decoration: InputDecoration(
                                labelText: 'Model',
                                border: OutlineInputBorder()),
                            itemBuilder: (context, value) =>
                                ['Personal', 'Company'][value],
                            selectFieldBloc: formBloc.model,
                          ),
                          DropdownFieldBlocBuilder(
                            showEmptyItem: false,
                            decoration: InputDecoration(
                                labelText: 'Style',
                                border: OutlineInputBorder()),
                            itemBuilder: (context, value) =>
                                ['Apartment', 'Villa'][value],
                            selectFieldBloc: formBloc.style,
                          ),
                          TextFieldBlocBuilder(
                              textFieldBloc: formBloc.city
                                ..updateInitialValue(state.data.city),
                              decoration: InputDecoration(
                                  labelText: 'City',
                                  border: OutlineInputBorder())),
                          TextFieldBlocBuilder(
                              textFieldBloc: formBloc.community
                                ..updateInitialValue(state.data.community),
                              decoration: InputDecoration(
                                  labelText: 'Community',
                                  border: OutlineInputBorder())),
                          TextFieldBlocBuilder(
                              textFieldBloc: formBloc.street
                                ..updateInitialValue(state.data.street),
                              decoration: InputDecoration(
                                  labelText: 'Street',
                                  border: OutlineInputBorder())),
                          TextFieldBlocBuilder(
                              textFieldBloc: formBloc.building
                                ..updateInitialValue(state.data.building),
                              decoration: InputDecoration(
                                  labelText: 'Building',
                                  border: OutlineInputBorder())),
                          TextFieldBlocBuilder(
                              textFieldBloc: formBloc.roomNo
                                ..updateInitialValue(state.data.roomNo),
                              decoration: InputDecoration(
                                  labelText: 'RoomNo',
                                  border: OutlineInputBorder())),
                          SizedBox(height: 10),
                          RaisedButton(
                            child: Text('I want to use the map to locate'),
                            onPressed: () async {
                              showLocationPicker(context, Constant.ApiKey,
                                      myLocationButtonEnabled: true,
                                      layersButtonEnabled: true,
                                      automaticallyAnimateToCurrentLocation:
                                          true)
                                  .then((value) {
                                if (value != null) {
                                  postBloc.add(AddressUpdate(state.data
                                      .copyWidth(
                                          onMap: true,
                                          lat: value.latLng.latitude,
                                          lng: value.latLng.longitude,
                                          address: value.address ?? '')));
                                }
                              });
                            },
                          ),
                          SizedBox(height: 10),
                          RaisedButton(
                            child: Text(Localization.of(context).submit),
                            onPressed: () async {
                              formBloc.submit();
                            },
                          ),
                        ]))
                ],
              );
            },
          );
        }));

    return Scaffold(
        appBar: AppBar(
          title: Text(Localization.of(context).address),
        ),
        body: body);
  }
}
