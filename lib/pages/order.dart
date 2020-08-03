import 'package:bookservice/I18n/i18n.dart';
import 'package:bookservice/apis/client.dart';
import 'package:bookservice/bloc/order_list_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// ignore_for_file: close_sinks

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderListBloc>(
      create: (context) => OrderListBloc(context),
      child: BlocBuilder<OrderListBloc, OrderListState>(
        builder: (context, state) {
          OrderListBloc bloc = BlocProvider.of<OrderListBloc>(context);

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
              separatorBuilder: (_, index) => new Divider(),
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

    return DefaultTextStyle(
        style: TextStyle(color: Colors.white),
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              shape: BoxShape.rectangle,
              color: bgColor[200],
            ),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    child: ListTile(
                      trailing: Image.asset(images[order.service]),
                      title: Text(
                          '${Localization.of(context).mainInfo[order.service][order.main_info]}'),
                      subtitle: Text(
                          '${Localization.of(context).subInfo[order.service][order.main_info][order.sub_info]} \n${order.create_at}'),
                    ))
              ],
            )));
  }
}
