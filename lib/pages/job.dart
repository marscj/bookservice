import 'package:bookservice/bloc/job_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class JobPage extends StatefulWidget {
  const JobPage({Key key}) : super(key: key);

  @override
  _JobPageState createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JobBloc, JobState>(
      builder: (context, state) {
        JobBloc bloc = BlocProvider.of<JobBloc>(context);

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
          onRefresh: () => bloc.add(JobRefreshList()),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            separatorBuilder: (context, index) {
              return SizedBox(height: 25);
            },
            itemBuilder: (c, i) => Container(),
            itemCount: state.list.length,
          ),
        );
      },
    );
  }
}
