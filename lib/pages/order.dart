import 'package:auto_route/auto_route.dart';
import 'package:bookservice/I18n/i18n.dart';
import 'package:bookservice/apis/client.dart';
import 'package:bookservice/bloc/addition_bloc.dart';
import 'package:bookservice/bloc/order_bloc.dart';
import 'package:bookservice/router/router.gr.dart';
import 'package:bookservice/views/dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:bookservice/views/date_time/date_time_field_bloc_builder.dart'
    as _IL;

// ignore_for_file: close_sinks

class OrderListPage extends StatefulWidget {
  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderBloc>(
      create: (context) => OrderBloc(context),
      child: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          OrderBloc bloc = BlocProvider.of<OrderBloc>(context);

          return SmartRefresher(
            enablePullDown: true,
            enablePullUp: state.list.length < state.totalCount,
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
            onRefresh: () => bloc.add(RefreshOrderList()),
            onLoading: () => bloc.add(LoadOrderList()),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              separatorBuilder: (_, index) => SizedBox(
                height: 20,
              ),
              itemBuilder: (c, i) => OrderListItem(order: state.list[i]),
              itemCount: state.list.length,
            ),
          );
        },
      ),
    );
  }
}

class OrderListItem extends StatelessWidget {
  final Order order;

  const OrderListItem({Key key, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MaterialColor bgColor = Colors.blue;

    final List<String> images = [
      'assets/images/ac.png',
      'assets/images/eletectrical.png',
      'assets/images/plumbing.png',
      'assets/images/house.png'
    ];

    return GestureDetector(
        onTap: () {
          ExtendedNavigator.of(context).push('/order/${order.id}',
              arguments: OrderPageArguments(data: order));
        },
        child: DefaultTextStyle(
            style: TextStyle(
                color: Colors.white,
                fontFamily: GoogleFonts.getFont('Righteous').fontFamily),
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Colors.blue, width: 1),
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.grey[300], offset: Offset(0, 0)),
                      BoxShadow(
                          color: Colors.grey[400], offset: Offset(1.5, 3)),
                    ]),
                child: Column(
                  children: <Widget>[
                    Container(
                        height: 45,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(8)),
                          shape: BoxShape.rectangle,
                          color: bgColor[400],
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('${order.orderID}'),
                              Text(
                                  '${Localization.of(context).orderStatus[order.status]}')
                            ])),
                    Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 10),
                        child: ListTile(
                          trailing: Image.asset(images[order.service]),
                          title: Text(
                              '${Localization.of(context).mainInfo[order.service][order.main_info]}'),
                          subtitle: Text(
                              '${Localization.of(context).subInfo[order.service][order.main_info][order.sub_info]} \n${order.create_at}'),
                        ))
                  ],
                ))));
  }
}

class OrderPostPage extends StatefulWidget {
  final Order data;

  const OrderPostPage({Key key, this.data}) : super(key: key);

  @override
  _OrderPostPageState createState() => _OrderPostPageState();
}

class _OrderPostPageState extends State<OrderPostPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    bool post = RouteData.of(context)?.pathParams != null
        ? RouteData.of(context).pathParams['id'].intValue == 0 ? true : false
        : false;

    return BlocProvider<OrderFormBloc>(
        create: (_) => OrderFormBloc(context, widget.data, post),
        child: Builder(builder: (context) {
          OrderFormBloc formBloc = BlocProvider.of<OrderFormBloc>(context);
          DateTime dateTime = DateTime.now();
          return Builder(
            builder: (context) {
              Widget body = FormBlocListener<OrderFormBloc, String, String>(
                  onSubmitting: (context, state) {
                    LoadingDialog.show(context);
                  },
                  onSuccess: (context, state) {
                    LoadingDialog.hide(context);
                    context.navigator.pop(true);
                  },
                  onFailure: (context, state) {
                    LoadingDialog.hide(context);
                  },
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    children: <Widget>[
                      Visibility(
                        visible: !post,
                        child: DropdownFieldBlocBuilder(
                          showEmptyItem: false,
                          isEnabled: false,
                          decoration: InputDecoration(
                              labelText: 'Status',
                              border: OutlineInputBorder()),
                          itemBuilder: (context, value) =>
                              Localization.of(context).orderStatus[value],
                          selectFieldBloc: formBloc.status,
                        ),
                      ),
                      DropdownFieldBlocBuilder(
                        showEmptyItem: false,
                        isEnabled: post,
                        decoration: InputDecoration(
                            labelText: 'Service', border: OutlineInputBorder()),
                        itemBuilder: (context, value) =>
                            Localization.of(context).serviceType[value],
                        selectFieldBloc: formBloc.service,
                      ),
                      DropdownFieldBlocBuilder(
                        showEmptyItem: false,
                        isEnabled: post,
                        decoration: InputDecoration(
                            labelText: 'Main Info',
                            border: OutlineInputBorder()),
                        itemBuilder: (context, value) =>
                            Localization.of(context).mainInfo[value.service]
                                [value.main],
                        selectFieldBloc: formBloc.main_info,
                      ),
                      DropdownFieldBlocBuilder(
                        showEmptyItem: false,
                        isEnabled: post,
                        decoration: InputDecoration(
                            labelText: 'Sub Info',
                            border: OutlineInputBorder()),
                        itemBuilder: (context, value) =>
                            Localization.of(context).subInfo[value.service]
                                [value.main][value.sub],
                        selectFieldBloc: formBloc.sub_info,
                      ),
                      TextFieldBlocBuilder(
                        isEnabled: post,
                        focusNode: FocusNode(debugLabel: 'address')
                          ..addListener(() {
                            FocusNode focusNode = FocusScope.of(context);
                            if (focusNode.hasFocus) {
                              focusNode.unfocus();
                              context.navigator
                                  .push<Address>('/pickaddr')
                                  .then((value) {
                                if (value != null) {
                                  if (value.onMap) {
                                    formBloc.lat.updateValue('${value.lat}');
                                    formBloc.lng.updateValue('${value.lng}');
                                    formBloc.address.updateValue(value.address);
                                  } else {
                                    formBloc.address.updateValue(value.toTitle);
                                  }
                                }
                              });
                            }
                          }),
                        maxLines: 2,
                        decoration: InputDecoration(
                            labelText: 'Address', border: OutlineInputBorder()),
                        textFieldBloc: formBloc.address,
                      ),
                      _IL.DateTimeFieldBlocBuilder(
                        dateTimeFieldBloc: formBloc.from_date,
                        canSelectTime: true,
                        isEnabled: post,
                        showClearIcon: false,
                        format: DateFormat('yyyy-MM-dd HH:mm'),
                        initialDate: DateTime(dateTime.year, dateTime.month,
                            dateTime.day + 1, 12),
                        firstDate: DateTime(
                            dateTime.year, dateTime.month, dateTime.day, 12),
                        lastDate: DateTime(
                            dateTime.year, dateTime.month, dateTime.day + 30),
                        decoration: InputDecoration(
                            labelText: 'From Date',
                            prefixIcon: Icon(Icons.calendar_today),
                            border: OutlineInputBorder()),
                      ),
                      _IL.DateTimeFieldBlocBuilder(
                        dateTimeFieldBloc: formBloc.to_date,
                        canSelectTime: true,
                        isEnabled: post,
                        showClearIcon: false,
                        format: DateFormat('yyyy-MM-dd HH:mm'),
                        initialDate: DateTime(dateTime.year, dateTime.month,
                            dateTime.day + 1, 14),
                        firstDate: DateTime(
                            dateTime.year, dateTime.month, dateTime.day, 14),
                        lastDate: DateTime(
                            dateTime.year, dateTime.month, dateTime.day + 30),
                        decoration: InputDecoration(
                            labelText: 'To Date',
                            prefixIcon: Icon(Icons.calendar_today),
                            border: OutlineInputBorder()),
                      ),
                      SizedBox(height: 10),
                      Visibility(
                        visible: post,
                        child: RaisedButton(
                          child: Text(Localization.of(context).submit),
                          onPressed: () {
                            formBloc.submit();
                          },
                        ),
                      )
                    ],
                  ));

              return post
                  ? Scaffold(
                      key: _scaffoldKey,
                      appBar: AppBar(
                        title: Text('Order New'),
                      ),
                      body: body)
                  : body;
            },
          );
        }));
  }
}

class OrderAdditionPage extends StatefulWidget {
  @override
  _OrderAdditionPageState createState() => _OrderAdditionPageState();
}

class _OrderAdditionPageState extends State<OrderAdditionPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class OrderJobPage extends StatefulWidget {
  @override
  _OrderJobPageState createState() => _OrderJobPageState();
}

class _OrderJobPageState extends State<OrderJobPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class OrderCommentPage extends StatefulWidget {
  @override
  _OrderCommentPageState createState() => _OrderCommentPageState();
}

class _OrderCommentPageState extends State<OrderCommentPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class OrderPage extends StatefulWidget {
  final Order data;

  const OrderPage({Key key, this.data}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class OrderNav {
  final Color color;
  final IconData icon;
  final String text;

  OrderNav(this.color, this.icon, this.text);
}

class _OrderPageState extends State<OrderPage> {
  int selectedIndex = 0;
  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text(
          'OrderDetail',
        ),
      ),
      body: PageView(
        onPageChanged: (page) {
          setState(() {
            selectedIndex = page;
          });
        },
        controller: controller,
        children: [
          OrderPostPage(data: widget.data),
          OrderAdditionPage(),
          OrderJobPage(),
          OrderCommentPage()
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(100)),
              boxShadow: [
                BoxShadow(
                    spreadRadius: -10,
                    blurRadius: 60,
                    color: Colors.black.withOpacity(.20),
                    offset: Offset(0, 15))
              ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
            child: GNav(
                tabs: [
                  OrderNav(Colors.blue, LineIcons.calendar, 'Base'),
                  OrderNav(Colors.purple, Icons.image, 'Additional'),
                  OrderNav(Colors.teal, Icons.work, 'Job'),
                  OrderNav(Colors.pink, LineIcons.comment, 'Comment')
                ].map((e) {
                  return GButton(
                    gap: 10,
                    iconActiveColor: e.color,
                    iconColor: Colors.grey,
                    textColor: e.color,
                    backgroundColor: e.color.withOpacity(.2),
                    iconSize: 24,
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 5),
                    icon: e.icon,
                    text: e.text,
                  );
                }).toList(),
                selectedIndex: selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                  controller.jumpToPage(index);
                }),
          ),
        ),
      ),
    );
  }
}

class AdditionPostPage extends StatefulWidget {
  @override
  _AdditionPostPageState createState() => _AdditionPostPageState();
}

class _AdditionPostPageState extends State<AdditionPostPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdditionBloc>(
        create: (context) => AdditionBloc(),
        child: Builder(
          builder: (context) {
            AdditionBloc formBloc = BlocProvider.of<AdditionBloc>(context);
            return FormBlocListener<AdditionBloc, String, String>(
              child: Scaffold(
                key: _scaffoldKey,
                appBar: AppBar(),
                body: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  children: [
                    BlocBuilder<InputFieldBloc, dynamic>(
                        cubit: formBloc.image,
                        builder: (context, state) => IconButton(
                            icon: Icon(
                              Icons.add_box,
                              size: 96,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              _scaffoldKey.currentState.showBottomSheet<void>(
                                (_) {
                                  return Container(
                                    height: 200,
                                    color: Colors.white,
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child: Column(
                                        children: <Widget>[
                                          FlatButton(
                                            child: Text(Localization.of(context)
                                                .camera),
                                            onPressed: () async {
                                              await ImagePicker()
                                                  .getImage(
                                                      source:
                                                          ImageSource.camera)
                                                  .then((file) {
                                                if (file != null) {
                                                  return ImageCropper.cropImage(
                                                      sourcePath: file.path,
                                                      maxWidth: 1080,
                                                      maxHeight: 1920,
                                                      androidUiSettings:
                                                          AndroidUiSettings(
                                                              toolbarTitle:
                                                                  'Cropper',
                                                              toolbarColor: Colors
                                                                  .deepOrange,
                                                              toolbarWidgetColor:
                                                                  Colors.white,
                                                              initAspectRatio:
                                                                  CropAspectRatioPreset
                                                                      .original,
                                                              lockAspectRatio:
                                                                  false),
                                                      iosUiSettings:
                                                          IOSUiSettings(
                                                        minimumAspectRatio: 1.0,
                                                      )).then((value) {
                                                    if (value != null) {
                                                      Navigator.pop(context);
                                                    }
                                                  });
                                                }
                                                return null;
                                              });
                                            },
                                          ),
                                          Divider(
                                            color: Colors.grey,
                                          ),
                                          FlatButton(
                                            child: Text(Localization.of(context)
                                                .gallery),
                                            onPressed: () async {
                                              await ImagePicker()
                                                  .getImage(
                                                      source:
                                                          ImageSource.gallery)
                                                  .then((file) {
                                                if (file != null) {
                                                  return ImageCropper.cropImage(
                                                      sourcePath: file.path,
                                                      maxWidth: 1080,
                                                      maxHeight: 1920,
                                                      androidUiSettings:
                                                          AndroidUiSettings(
                                                              toolbarTitle:
                                                                  'Cropper',
                                                              toolbarColor: Colors
                                                                  .deepOrange,
                                                              toolbarWidgetColor:
                                                                  Colors.white,
                                                              initAspectRatio:
                                                                  CropAspectRatioPreset
                                                                      .original,
                                                              lockAspectRatio:
                                                                  false),
                                                      iosUiSettings:
                                                          IOSUiSettings(
                                                        minimumAspectRatio: 1.0,
                                                      )).then((value) {
                                                    if (value != null) {
                                                      Navigator.of(context)
                                                          .pop(value);
                                                    }
                                                  });
                                                }
                                                return null;
                                              });
                                            },
                                          ),
                                          Divider(
                                            height: 20,
                                            thickness: 6,
                                          ),
                                          FlatButton(
                                            child: Text(Localization.of(context)
                                                .cancel),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }))
                  ],
                ),
              ),
            );
          },
        ));
  }
}
