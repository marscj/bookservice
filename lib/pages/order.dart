import 'package:auto_route/auto_route.dart';
import 'package:bookservice/I18n/i18n.dart';
import 'package:bookservice/apis/client.dart';
import 'package:bookservice/bloc/order_bloc.dart';
import 'package:bookservice/router/router.gr.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:bookservice/views/date_time/date_time_field_bloc_builder.dart'
    as _IL;

// ignore_for_file: close_sinks

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    return OrderListPage();
  }
}

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
          ExtendedNavigator.of(context).push('/order/put',
              arguments: OrderPostPageArguments(data: order));
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
  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderFormBloc>(
        create: (_) => OrderFormBloc(context, widget.data),
        child: FormBlocListener<OrderFormBloc, String, String>(
            child: Scaffold(
          appBar: AppBar(
            title: Text('Order Detail'),
            actions: <Widget>[
              FlatButton(
                child: Text(Localization.of(context).submit),
                onPressed: () {},
              )
            ],
          ),
          body: Builder(
            builder: (context) {
              OrderFormBloc formBloc = BlocProvider.of<OrderFormBloc>(context);
              DateTime dateTime = DateTime.now();
              return ListView(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: <Widget>[
                  DropdownFieldBlocBuilder(
                    showEmptyItem: false,
                    // isEnabled: false,
                    decoration: InputDecoration(
                        labelText: 'Status', border: OutlineInputBorder()),
                    itemBuilder: (context, value) =>
                        Localization.of(context).orderStatus[value],
                    selectFieldBloc: formBloc.status,
                  ),
                  DropdownFieldBlocBuilder(
                    showEmptyItem: false,
                    decoration: InputDecoration(
                        labelText: 'Service', border: OutlineInputBorder()),
                    itemBuilder: (context, value) =>
                        Localization.of(context).serviceType[value],
                    selectFieldBloc: formBloc.service,
                  ),
                  DropdownFieldBlocBuilder(
                    showEmptyItem: false,
                    decoration: InputDecoration(
                        labelText: 'Main Info', border: OutlineInputBorder()),
                    itemBuilder: (context, value) => Localization.of(context)
                        .mainInfo[value.service][value.main],
                    selectFieldBloc: formBloc.main_info,
                  ),
                  DropdownFieldBlocBuilder(
                    showEmptyItem: false,
                    decoration: InputDecoration(
                        labelText: 'Sub Info', border: OutlineInputBorder()),
                    itemBuilder: (context, value) => Localization.of(context)
                        .subInfo[value.service][value.main][value.sub],
                    selectFieldBloc: formBloc.sub_info,
                  ),
                  TextFieldBlocBuilder(
                    focusNode: FocusNode(debugLabel: 'address')
                      ..addListener(() {
                        FocusNode focusNode = FocusScope.of(context);
                        if (focusNode.hasFocus) {
                          focusNode.unfocus();
                          context.navigator
                              .push<Address>('/pickaddr')
                              .then((value) {
                            if (value != null) {
                              formBloc.address.updateValue(
                                  value.onMap ? value.address : value.toTitle);
                            }
                          });
                        }
                      }),
                    decoration: InputDecoration(
                        labelText: 'Address', border: OutlineInputBorder()),
                    textFieldBloc: formBloc.address,
                  ),
                  _IL.DateTimeFieldBlocBuilder(
                    dateTimeFieldBloc: formBloc.from_date,
                    canSelectTime: true,
                    format: DateFormat('yyyy-MM-dd HH:mm '),
                    initialDate: DateTime(dateTime.year, dateTime.month,
                        dateTime.day, dateTime.hour + 2),
                    firstDate: DateTime(dateTime.year, dateTime.month,
                        dateTime.day, dateTime.hour + 2),
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
                    format: DateFormat('yyyy-MM-dd HH:mm '),
                    initialDate: DateTime(dateTime.year, dateTime.month,
                        dateTime.day, dateTime.hour + 2),
                    firstDate: DateTime(dateTime.year, dateTime.month,
                        dateTime.day, dateTime.hour + 2),
                    lastDate: DateTime(
                        dateTime.year, dateTime.month, dateTime.day + 30),
                    decoration: InputDecoration(
                        labelText: 'To Date',
                        prefixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder()),
                  ),
                ],
              );
            },
          ),
        )));
  }
}
