import 'package:auto_route/auto_route.dart';
import 'package:card_settings/card_settings.dart';
import 'package:bookservice/I18n/i18n.dart';
import 'package:bookservice/apis/client.dart';
import 'package:bookservice/bloc/contract_bloc.dart';
import 'package:bookservice/router/router.gr.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// ignore_for_file: close_sinks
class ContractPage extends StatefulWidget {
  @override
  _ContractPageState createState() => _ContractPageState();
}

class _ContractPageState extends State<ContractPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ContractBloc>(
        create: (context) => ContractBloc(context),
        child: ExtendedNavigator(
          name: 'contract',
          initialRoute: ContractPageRoutes.contractListPage,
        ));
  }
}

class ContractListPage extends StatefulWidget {
  @override
  _ContractListPageState createState() => _ContractListPageState();
}

class _ContractListPageState extends State<ContractListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(Localization.of(context).contract),
          leading: BackButton(onPressed: () {
            context.navigator.root.pop();
          }),
        ),
        body: BlocBuilder<ContractBloc, ContractState>(
          builder: (context, state) {
            ContractBloc bloc = BlocProvider.of<ContractBloc>(context);
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
              onRefresh: () => bloc.add(ContractRefreshList()),
              onLoading: () => bloc.add(ContractLoadList()),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemBuilder: (c, i) => ContractItem(
                  data: state.list[i],
                ),
                itemCount: state.list.length,
              ),
            );
          },
        ));
  }
}

class ContractItem extends StatefulWidget {
  final Contract data;

  const ContractItem({Key key, this.data}) : super(key: key);

  @override
  _ContractItemState createState() => _ContractItemState();
}

class _ContractItemState extends State<ContractItem> {
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
      child: CardSettings.sectioned(
        showMaterialonIOS: true,
        labelWidth: 100,
        fieldPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        children: [
          CardSettingsSection(
            header: CardSettingsHeader(
              label: '${widget.data.contractID}',
            ),
            children: [
              CardSettingsText(
                label: 'Option',
                initialValue:
                    '${Localization.of(context).contractOption[widget.data.option]}',
                enabled: false,
              ),
              CardSettingsText(
                label: 'Issue Date',
                initialValue: '${widget.data.issue_date}',
                enabled: false,
              ),
              CardSettingsText(
                label: 'Expiry Date',
                initialValue: '${widget.data.expiry_date}',
                enabled: false,
              ),
              CardSettingsText(
                label: 'Expiry Date',
                initialValue: '${widget.data.expiry_date}',
                enabled: false,
              ),
              CardSettingsParagraph(
                  label: 'Address',
                  initialValue: widget.data.address != null
                      ? '${widget.data.address}'
                      : '',
                  enabled: false,
                  numberOfLines: 3),
              CardSettingsParagraph(
                  label: 'Remark',
                  initialValue:
                      widget.data.remark != null ? '${widget.data.remark}' : '',
                  enabled: false,
                  numberOfLines: 3),
              CardSettingsField(
                fieldPadding: null,
                labelAlign: null,
                requiredIndicator: null,
                enabled: false,
                contentOnNewLine: true,
                label: 'Visit',
                content: Container(
                    alignment: Alignment.topLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: widget.data.visits != null
                          ? widget.data.visits
                              .map((e) => ListTile(
                                    title: Text(
                                        '${Localization.of(context).serviceType[e.service]} : ${e.count}'),
                                  ))
                              .toList()
                          : Container(),
                    )),
              )
            ],
          )
        ],
      ),
    );
  }
}

class ContractPost extends StatefulWidget {
  @override
  _ContractPostState createState() => _ContractPostState();
}

class _ContractPostState extends State<ContractPost> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
