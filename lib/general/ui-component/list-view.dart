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
    return new ListView.builder(
        itemCount: widget.array.length,
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        // suggestion from https://github.com/flutter/flutter/issues/22314
        itemBuilder: (BuildContext content, int index) {
          PageListItem listItem = widget.array[index];
          return new PageListTile(listItem, context);
        });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}
