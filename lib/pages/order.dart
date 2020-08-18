import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:bookservice/I18n/i18n.dart';
import 'package:bookservice/apis/client.dart';
import 'package:bookservice/bloc/addition_bloc.dart';
import 'package:bookservice/bloc/app_bloc.dart';
import 'package:bookservice/bloc/comment_bloc.dart';
import 'package:bookservice/bloc/order_bloc.dart';
import 'package:bookservice/router/router.gr.dart';
import 'package:bookservice/views/date_time/any_field_bloc_builder.dart';
import 'package:bookservice/views/dialog.dart';
import 'package:bookservice/views/ifnone_widget.dart';
import 'package:bookservice/views/modal.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter_form_bloc/src/utils/style.dart' as IStyle;
import 'package:line_icons/line_icons.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:bookservice/views/date_time/date_time_field_bloc_builder.dart'
    as _IL;

// ignore_for_file: close_sinks
// ignore_for_file: implementation_imports
// ignore_for_file: non_constant_identifier_names

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
    bool post = widget?.data?.id == null;

    final Widget body = Builder(
      builder: (context) {
        OrderFormBloc formBloc = BlocProvider.of<OrderFormBloc>(context);
        DateTime dateTime = DateTime.now();
        Widget body = FormBlocListener<OrderFormBloc, String, String>(
            onSubmitting: (context, state) {
              LoadingDialog.show(context);
            },
            onSuccess: (context, state) {
              LoadingDialog.hide(context);
              if (formBloc.nextStep) {
                context.navigator.replace('/addition/post',
                    arguments:
                        AdditionPostPageArguments(postId: formBloc.data.id));
              } else {
                context.navigator.pop();
              }
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
                        labelText: 'Status', border: OutlineInputBorder()),
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
                      labelText: 'Main Info', border: OutlineInputBorder()),
                  itemBuilder: (context, value) => Localization.of(context)
                      .mainInfo[value.service][value.main],
                  selectFieldBloc: formBloc.main_info,
                ),
                DropdownFieldBlocBuilder(
                  showEmptyItem: false,
                  isEnabled: post,
                  decoration: InputDecoration(
                      labelText: 'Sub Info', border: OutlineInputBorder()),
                  itemBuilder: (context, value) => Localization.of(context)
                      .subInfo[value.service][value.main][value.sub],
                  selectFieldBloc: formBloc.sub_info,
                ),
                AnyFieldBlocBuilder<Address>(
                    inputFieldBloc: formBloc.address,
                    onPick: showAddressPickModal,
                    isEnabled: post,
                    showClearIcon: post,
                    decoration: InputDecoration(
                        labelText: 'Address', border: OutlineInputBorder()),
                    builder: (context, state) {
                      return Text(
                        state?.value?.address ?? '',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: IStyle.Style.getDefaultTextStyle(
                          context: context,
                          isEnabled: post,
                        ),
                      );
                    }),
                _IL.DateTimeFieldBlocBuilder(
                  dateTimeFieldBloc: formBloc.from_date,
                  canSelectTime: true,
                  isEnabled: post,
                  showClearIcon: false,
                  format: DateFormat('yyyy-MM-dd HH:mm'),
                  initialDate: DateTime(
                      dateTime.year, dateTime.month, dateTime.day + 1, 12),
                  firstDate:
                      DateTime(dateTime.year, dateTime.month, dateTime.day, 12),
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
                  initialDate: DateTime(
                      dateTime.year, dateTime.month, dateTime.day + 1, 14),
                  firstDate:
                      DateTime(dateTime.year, dateTime.month, dateTime.day, 14),
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

    if (post) {
      return BlocProvider<OrderFormBloc>(
          create: (_) => OrderFormBloc(context, widget.data, true),
          child: body);
    } else {
      return body;
    }
  }
}

class OrderAdditionPage extends StatefulWidget {
  final Order data;

  const OrderAdditionPage({Key key, this.data}) : super(key: key);

  @override
  _OrderAdditionPageState createState() => _OrderAdditionPageState();
}

class _OrderAdditionPageState extends State<OrderAdditionPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdditionBloc, AdditionState>(
      builder: (context, state) {
        AdditionBloc bloc = BlocProvider.of<AdditionBloc>(context);

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
          onRefresh: () => bloc.add(AdditionRefreshList(widget.data.id)),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            separatorBuilder: (context, index) {
              return SizedBox(height: 25);
            },
            itemBuilder: (c, i) => GestureDetector(
                onTap: () {
                  context.navigator.push('/image/order',
                      arguments: ViewOrderImageArguments(
                          url: state.list[i].image['full_size']));
                },
                child: AspectRatio(
                    aspectRatio: 16.0 / 9.0,
                    child: Container(
                      height: 300,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                              image: NetworkImage(
                                  state.list[i].image['full_size']))),
                      child: Container(
                          alignment: Alignment.bottomCenter,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          child: Text(
                            state.list[i].tag ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(color: Colors.white),
                          )),
                    ))),
            itemCount: state.list.length,
          ),
        );
      },
    );
  }
}

class OrderCommentPage extends StatefulWidget {
  final Order data;

  const OrderCommentPage({Key key, this.data}) : super(key: key);

  @override
  _OrderCommentPageState createState() => _OrderCommentPageState();
}

class _OrderCommentPageState extends State<OrderCommentPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentBloc, CommentState>(
      builder: (context, state) {
        CommentBloc bloc = BlocProvider.of<CommentBloc>(context);

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
          onRefresh: () => bloc.add(CommentRefreshList(widget.data.id)),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (c, i) => Container(
              child: Column(
                children: [
                  ListTile(
                    leading: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(32)),
                          image: DecorationImage(
                              image: state.list[i].user?.photo['thumbnail'] !=
                                      null
                                  ? NetworkImage(
                                      state.list[i].user?.photo['thumbnail'])
                                  : ExactAssetImage('assets/images/user.png')),
                        )),
                    title: RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                              style: DefaultTextStyle.of(context)
                                  .style
                                  .copyWith(fontSize: 18),
                              text: state.list[i].comment),
                          TextSpan(text: '\n'),
                          TextSpan(
                              style: DefaultTextStyle.of(context)
                                  .style
                                  .copyWith(color: Colors.grey[600]),
                              text:
                                  '${state.list[i].user.name}  ${state.list[i].create_at}'),
                        ],
                      ),
                    ),
                    subtitle: RatingBar(
                      initialRating: state.list[i].rating.toDouble(),
                      minRating: 1,
                      direction: Axis.horizontal,
                      itemCount: 5,
                      itemSize: 24,
                      unratedColor: Colors.grey,
                      itemPadding:
                          EdgeInsets.symmetric(horizontal: 1.0, vertical: 12),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {},
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.reply),
                      onPressed: () {
                        showCommentModal(context, state.list[i].id, 'comment',
                                reply: state.list[i])
                            .then((value) {
                          if (value != null && value) {
                            bloc.add(CommentRefreshList(widget.data.id));
                            bloc.refreshController.requestRefresh();
                          }
                        });
                      },
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.only(left: 16),
                      child: ListBody(
                        children: state.list[i].child.map((e) {
                          return ListTile(
                              isThreeLine: true,
                              dense: true,
                              leading: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(32)),
                                    image: DecorationImage(
                                        image: state.list[i].user
                                                    ?.photo['thumbnail'] !=
                                                null
                                            ? NetworkImage(state.list[i].user
                                                ?.photo['thumbnail'])
                                            : ExactAssetImage(
                                                'assets/images/user.png')),
                                  )),
                              title: Text('${e.comment}'),
                              subtitle: Text('${e.user.name}  ${e.create_at}'));
                        }).toList(),
                      ))
                ],
              ),
            ),
            itemCount: state.list.length,
          ),
        );
      },
    );
  }
}

class OrderCommentPostPage extends StatefulWidget {
  final int objectid;
  final String contenttype;
  final Comment reply;

  const OrderCommentPostPage(
      {Key key, this.objectid, this.contenttype, this.reply})
      : super(key: key);

  @override
  _OrderCommentPostPageState createState() => _OrderCommentPostPageState();
}

class _OrderCommentPostPageState extends State<OrderCommentPostPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CommentFormBloc>(
        create: (_) =>
            CommentFormBloc(context, widget.objectid, widget.contenttype),
        child: Builder(
          builder: (context) {
            CommentFormBloc formBloc =
                BlocProvider.of<CommentFormBloc>(context);
            return FormBlocListener<CommentFormBloc, String, String>(
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
              child: Scaffold(
                body: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  children: [
                    IfNoneWidget(
                      basis: widget.reply != null,
                      builder: (context) {
                        return ListBody(
                          children: [
                            SizedBox(height: 10),
                            ListTile(
                              leading: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(32)),
                                    image: DecorationImage(
                                        image: widget.reply.user
                                                    ?.photo['thumbnail'] !=
                                                null
                                            ? NetworkImage(widget
                                                .reply.user?.photo['thumbnail'])
                                            : ExactAssetImage(
                                                'assets/images/user.png')),
                                  )),
                              title: Text(widget.reply.comment),
                              subtitle: Text(
                                '${widget.reply.user.name}  ${widget.reply.create_at}',
                              ),
                            ),
                          ],
                        );
                      },
                      none: ListBody(
                        children: [
                          SizedBox(height: 10),
                          AnyFieldBlocBuilder<double>(
                            inputFieldBloc: formBloc.rating,
                            showClearIcon: false,
                            decoration: InputDecoration(
                                labelText: 'Rating',
                                border: OutlineInputBorder()),
                            builder: (context, state) {
                              return Container(
                                  alignment: Alignment.center,
                                  child: RatingBar(
                                    initialRating: state.value,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    itemCount: 5,
                                    unratedColor: Colors.grey,
                                    itemPadding:
                                        EdgeInsets.symmetric(horizontal: 4.0),
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {
                                      print(rating);
                                      formBloc.rating.updateValue(rating);
                                    },
                                  ));
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFieldBlocBuilder(
                      textFieldBloc: formBloc.comment,
                      maxLines: 3,
                      maxLength: 256,
                      decoration: InputDecoration(
                          labelText: 'Comment', border: OutlineInputBorder()),
                    ),
                    SizedBox(height: 10),
                    RaisedButton(
                      child: Text(Localization.of(context).submit),
                      onPressed: () {
                        formBloc.submit();
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ));
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
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        List<Widget> actions(
            AdditionBloc additionBloc, CommentBloc commentBloc) {
          switch (selectedIndex) {
            case 0:
            case 3:
              break;
            case 1:
              return [
                IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      showImagePostModal(context, widget.data.id).then((value) {
                        if (value != null && value) {
                          additionBloc.add(AdditionRefreshList(widget.data.id));
                          additionBloc.refreshController.requestRefresh();
                        }
                      });
                    })
              ];
            case 2:
              return [
                IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      showCommentModal(context, widget.data.id, 'order')
                          .then((value) {
                        if (value != null && value) {
                          commentBloc.add(CommentRefreshList(widget.data.id));
                          commentBloc.refreshController.requestRefresh();
                        }
                      });
                    })
              ];
          }
          return [];
        }

        List<String> title = ['BaseInfo', 'Additional', 'Comment'];

        List<Widget> child() {
          return [
            OrderPostPage(data: widget.data),
            OrderAdditionPage(
              data: widget.data,
            ),
            OrderCommentPage(
              data: widget.data,
            ),
          ];
        }

        List<OrderNav> tabs() {
          return [
            OrderNav(Colors.blue, LineIcons.calendar, 'Base'),
            OrderNav(Colors.purple, Icons.image, 'Additional'),
            OrderNav(Colors.pink, LineIcons.comment, 'Comment'),
          ];
        }

        return MultiBlocProvider(
            providers: [
              BlocProvider<OrderFormBloc>(
                  create: (_) => OrderFormBloc(context, widget.data, false)),
              BlocProvider<AdditionBloc>(create: (context) => AdditionBloc()),
              BlocProvider<CommentBloc>(create: (context) => CommentBloc()),
            ],
            child: Builder(
              builder: (context) {
                AdditionBloc additionBloc =
                    BlocProvider.of<AdditionBloc>(context);
                CommentBloc commentBloc = BlocProvider.of<CommentBloc>(context);
                return Scaffold(
                  extendBody: true,
                  appBar: AppBar(
                    title: Text(
                      title[selectedIndex],
                    ),
                    actions: actions(additionBloc, commentBloc),
                  ),
                  body: PageView(
                    onPageChanged: (page) {
                      setState(() {
                        selectedIndex = page;
                      });
                    },
                    controller: controller,
                    children: child(),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 5),
                        child: GNav(
                            tabs: tabs().map((e) {
                              return GButton(
                                gap: 10,
                                iconActiveColor: e.color,
                                iconColor: Colors.grey,
                                textColor: e.color,
                                backgroundColor: e.color.withOpacity(.2),
                                iconSize: 24,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 5),
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
              },
            ));
      },
    );
  }
}

class AdditionPostPage extends StatefulWidget {
  final int postId;

  const AdditionPostPage({Key key, this.postId}) : super(key: key);

  @override
  _AdditionPostPageState createState() => _AdditionPostPageState();
}

class _AdditionPostPageState extends State<AdditionPostPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdditionFormBloc>(
        create: (_) => AdditionFormBloc(context, widget.postId),
        child: Builder(
          builder: (context) {
            AdditionFormBloc formBloc =
                BlocProvider.of<AdditionFormBloc>(context);
            return FormBlocListener<AdditionFormBloc, String, String>(
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
              child: Scaffold(
                body: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  children: [
                    SizedBox(height: 20),
                    AnyFieldBlocBuilder<File>(
                      inputFieldBloc: formBloc.image,
                      showClearIcon: true,
                      onPick: showImagePickModal,
                      builder: (context, state) {
                        return Container(
                            width: 64,
                            height: 96,
                            child: DottedBorder(
                                color: Colors.black,
                                strokeWidth: 1,
                                strokeCap: StrokeCap.butt,
                                dashPattern: const <double>[8, 2],
                                child: Container(
                                    alignment: Alignment.center,
                                    child: state.value == null
                                        ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                                Icon(
                                                  Icons.file_upload,
                                                  color: Colors.grey,
                                                  size: 64,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                      'Images for select a picture or take'),
                                                ),
                                              ])
                                        : Stack(
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                child: Image.file(
                                                  state.value,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ],
                                          ))));
                      },
                    ),
                    SizedBox(height: 10),
                    TextFieldBlocBuilder(
                      textFieldBloc: formBloc.tag,
                      maxLines: 3,
                      maxLength: 128,
                      decoration: InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder()),
                    ),
                    SizedBox(height: 10),
                    RaisedButton(
                      child: Text(Localization.of(context).submit),
                      onPressed: () {
                        formBloc.submit();
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ));
  }
}

class ViewOrderImage extends StatelessWidget {
  final String url;

  const ViewOrderImage({Key key, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.normal),
            appBarTheme: AppBarTheme(
                elevation: 0,
                color: Colors.black,
                iconTheme: IconThemeData(color: Colors.white),
                textTheme: GoogleFonts.righteousTextTheme(
                  Theme.of(context).textTheme.apply(
                      displayColor: Colors.white, bodyColor: Colors.white),
                ),
                brightness: Brightness.dark)),
        child: Scaffold(
            appBar: AppBar(),
            body: BlocBuilder<AppBloc, AppState>(builder: (context, state) {
              return Stack(
                children: <Widget>[
                  Center(
                      child: PhotoView(
                          heroAttributes: PhotoViewHeroAttributes(tag: url),
                          imageProvider: NetworkImage(url))),
                ],
              );
            })));
  }
}
