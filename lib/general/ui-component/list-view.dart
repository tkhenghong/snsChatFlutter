import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PageListItem {
  final Widget title;
  final Widget subtitle;
  final Widget leading;
  final Widget trailing;
  final Function onTap;
  final Object object;

  PageListItem({this.title, this.leading, this.trailing, this.subtitle, this.onTap, this.object});
}

class PageListTile extends ListTile {
  PageListTile(PageListItem item, BuildContext context)
      : super(
            title: item.title,
            subtitle: item.subtitle,
            leading: item.leading,
            trailing: item.trailing,
            onTap: () {
              item.onTap(context, item.object);
            });
}

class PageListView extends StatefulWidget {
  final List<PageListItem> array;
  final BuildContext context;

  PageListView({this.array, this.context});

  @override
  State<StatefulWidget> createState() {
    return new PageListViewState();
  }
}

class PageListViewState extends State<PageListView> {
  RefreshController _refreshController;

  @override
  initState() {
    super.initState();
    _refreshController = new RefreshController();
  }

  Widget build(BuildContext context) {
    return new SmartRefresher(
        header: WaterDropHeader(),
        enableOverScroll: true,
        enablePullUp: false,
        enablePullDown: false,
        controller: _refreshController,
        // Very important, without this whole thing won't work. Check the examples in the plugins
        onRefresh: () {
          //Delay 1 second to simulate something loading
          Future.delayed(Duration(seconds: 1), () {
            print('Delayed 1 second.');
            _refreshController.refreshCompleted();
          });
        },
        onOffsetChange: (result, change) {
          print("onOffsetChange......");
        },
        // Unable to put PageView under child properties, so have to get manual
        child: new ListView.builder(
            itemCount: widget.array.length,
            physics: BouncingScrollPhysics(),
            //suggestion from https://github.com/flutter/flutter/issues/22314
            itemBuilder: (BuildContext content, int index) {
              PageListItem listItem = widget.array[index];
              return new PageListTile(listItem, context);
            }));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _refreshController.dispose();
    super.dispose();
  }
}
