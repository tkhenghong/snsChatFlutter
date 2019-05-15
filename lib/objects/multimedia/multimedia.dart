import 'dart:io';
import 'dart:typed_data';

class Multimedia {
  // Image, Video, Gifs, Sticker, Recording, links
  String localUrl;
  String remoteUrl;
  String thumbnail;
  Uint8List imageData;
  File imageFile;

  Multimedia({this.localUrl, this.remoteUrl, this.thumbnail, this.imageData, this.imageFile});
// KS put
// mediaCheckPoint
// mediaPercentage
// But I don't think I really need this, or I need to save this into database

}
