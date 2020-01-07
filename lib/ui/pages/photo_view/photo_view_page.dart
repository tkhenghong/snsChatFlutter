import 'package:flutter/cupertino.dart';
import 'package:photo_view/photo_view.dart';
import 'package:snschat_flutter/objects/index.dart';

class PhotoViewPage extends StatelessWidget {
  final Multimedia multimedia;

  PhotoViewPage([this.multimedia]);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return PhotoView(
      imageProvider: AssetImage("assets/large-image.jpg"),
    );
  }

}