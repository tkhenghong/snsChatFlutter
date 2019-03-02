import 'package:flutter/material.dart';

class PageListItem {
  final Widget title;
  final Widget subtitle;
  final Widget leading;
  final Widget trailing;
  final Function onTap;

  PageListItem({this.title, this.leading, this.trailing, this.subtitle, this.onTap});
}

class PageListTile extends ListTile {
  PageListTile(PageListItem item, BuildContext context)
      : super(
            title: item.title,
            subtitle: item.subtitle,
            leading: item.leading,
            trailing: item.trailing,
            onTap: () {
              item.onTap(context);
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
  Widget build(BuildContext context) {
    return new Material(
        color: Colors.white,
        child: new ListView.builder(
            itemCount: widget.array.length,
            physics: const AlwaysScrollableScrollPhysics(),
            //suggestion from https://github.com/flutter/flutter/issues/22314
            itemBuilder: (BuildContext content, int index) {
              PageListItem listItem = widget.array[index];
              return new PageListTile(listItem, context);
            }));
  }
}
