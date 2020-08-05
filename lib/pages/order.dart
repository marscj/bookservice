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

    return InkWell(
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
  Widget _buildDatePicker(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showCupertinoModalPopup<void>(
          context: context,
          builder: (context) {
            return _BottomPicker(
              child: CupertinoDatePicker(
                backgroundColor:
                    CupertinoColors.systemBackground.resolveFrom(context),
                mode: CupertinoDatePickerMode.dateAndTime,
                initialDateTime: DateTime.now(),
                onDateTimeChanged: (newDateTime) {},
              ),
            );
          },
        );
      },
      child: _Menu(children: [
        Text('PickerDate'),
        Text(
          DateFormat.yMMMMd().format(DateTime.now()),
          style: const TextStyle(color: CupertinoColors.inactiveGray),
        ),
      ]),
    );
  }

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
                  _IL.DateTimeFieldBlocBuilder(
                    dateTimeFieldBloc: formBloc.from_date,
                    canSelectTime: true,
                    format: DateFormat('yyyy-MM-dd HH:mm '),
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                    // pickerBuilder: (context, widget) {
                    //   return _buildDatePicker(context);
                    // },
                    decoration: InputDecoration(
                        labelText: 'From Date',
                        prefixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder()),
                  ),
                  _IL.DateTimeFieldBlocBuilder(
                    dateTimeFieldBloc: formBloc.to_date,
                    canSelectTime: true,
                    format: DateFormat('yyyy-MM-dd HH:mm '),
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                    decoration: InputDecoration(
                        labelText: 'To Date',
                        prefixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder()),
                  )
                ],
              );
            },
          ),
        )));
  }
}

class CupertinoPickerDemo extends StatefulWidget {
  const CupertinoPickerDemo();

  @override
  _CupertinoPickerDemoState createState() => _CupertinoPickerDemoState();
}

class _CupertinoPickerDemoState extends State<CupertinoPickerDemo> {
  Duration timer = const Duration();

  // Value that is shown in the date picker in date mode.
  DateTime date = DateTime.now();

  // Value that is shown in the date picker in time mode.
  DateTime time = DateTime.now();

  // Value that is shown in the date picker in dateAndTime mode.
  DateTime dateTime = DateTime.now();

  Widget _buildDatePicker(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showCupertinoModalPopup<void>(
          context: context,
          builder: (context) {
            return _BottomPicker(
              child: CupertinoDatePicker(
                backgroundColor:
                    CupertinoColors.systemBackground.resolveFrom(context),
                mode: CupertinoDatePickerMode.date,
                initialDateTime: date,
                onDateTimeChanged: (newDateTime) {
                  setState(() => date = newDateTime);
                },
              ),
            );
          },
        );
      },
      child: _Menu(children: [
        Text('PickerDate'),
        Text(
          DateFormat.yMMMMd().format(date),
          style: const TextStyle(color: CupertinoColors.inactiveGray),
        ),
      ]),
    );
  }

  Widget _buildTimePicker(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showCupertinoModalPopup<void>(
          context: context,
          builder: (context) {
            return _BottomPicker(
              child: CupertinoDatePicker(
                backgroundColor:
                    CupertinoColors.systemBackground.resolveFrom(context),
                mode: CupertinoDatePickerMode.time,
                initialDateTime: time,
                onDateTimeChanged: (newDateTime) {
                  setState(() => time = newDateTime);
                },
              ),
            );
          },
        );
      },
      child: _Menu(
        children: [
          Text('CupertinoPickerTime'),
          Text(
            DateFormat.jm().format(time),
            style: const TextStyle(color: CupertinoColors.inactiveGray),
          ),
        ],
      ),
    );
  }

  Widget _buildDateAndTimePicker(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showCupertinoModalPopup<void>(
          context: context,
          builder: (context) {
            return _BottomPicker(
              child: CupertinoDatePicker(
                backgroundColor:
                    CupertinoColors.systemBackground.resolveFrom(context),
                mode: CupertinoDatePickerMode.dateAndTime,
                initialDateTime: dateTime,
                onDateTimeChanged: (newDateTime) {
                  setState(() => dateTime = newDateTime);
                },
              ),
            );
          },
        );
      },
      child: _Menu(
        children: [
          Text('PickerDateTime'),
          Flexible(
            child: Text(
              DateFormat.yMMMd().add_jm().format(dateTime),
              style: const TextStyle(color: CupertinoColors.inactiveGray),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountdownTimerPicker(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showCupertinoModalPopup<void>(
          context: context,
          builder: (context) {
            return _BottomPicker(
              child: CupertinoTimerPicker(
                backgroundColor:
                    CupertinoColors.systemBackground.resolveFrom(context),
                initialTimerDuration: timer,
                onTimerDurationChanged: (newTimer) {
                  setState(() => timer = newTimer);
                },
              ),
            );
          },
        );
      },
      child: _Menu(
        children: [
          Text('PickerTimer'),
          Text(
            '${timer.inHours}:'
            '${(timer.inMinutes % 60).toString().padLeft(2, '0')}:'
            '${(timer.inSeconds % 60).toString().padLeft(2, '0')}',
            style: const TextStyle(color: CupertinoColors.inactiveGray),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        middle: Text('Title'),
      ),
      child: DefaultTextStyle(
        style: CupertinoTheme.of(context).textTheme.textStyle,
        child: ListView(
          children: [
            const SizedBox(height: 32),
            _buildDatePicker(context),
            _buildTimePicker(context),
            _buildDateAndTimePicker(context),
            _buildCountdownTimerPicker(context),
          ],
        ),
      ),
    );
  }
}

class _BottomPicker extends StatelessWidget {
  const _BottomPicker({
    Key key,
    @required this.child,
  })  : assert(child != null),
        super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 216,
      padding: const EdgeInsets.only(top: 6),
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      color: CupertinoColors.systemBackground.resolveFrom(context),
      child: DefaultTextStyle(
        style: TextStyle(
          color: CupertinoColors.label.resolveFrom(context),
          fontSize: 22,
        ),
        child: GestureDetector(
          // Blocks taps from propagating to the modal sheet and popping.
          onTap: () {},
          child: SafeArea(
            top: false,
            child: child,
          ),
        ),
      ),
    );
  }
}

class _Menu extends StatelessWidget {
  const _Menu({
    Key key,
    @required this.children,
  })  : assert(children != null),
        super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: CupertinoColors.inactiveGray, width: 0),
          bottom: BorderSide(color: CupertinoColors.inactiveGray, width: 0),
        ),
      ),
      height: 44,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ),
      ),
    );
  }
}

// END
