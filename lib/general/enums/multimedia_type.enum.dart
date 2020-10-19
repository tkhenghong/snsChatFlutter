enum MultimediaType {
  GIF, Image, Video, Music, Recording, Audio, Word, Excel, PowerPoint, TXT
}

extension MultimediaTypeUtil on MultimediaType {
  String get name {
    switch(this) {
      case MultimediaType.GIF: return 'GIF';
      case MultimediaType.Image: return 'Image';
      case MultimediaType.Video: return 'Video';
      case MultimediaType.Music: return 'Music';
      case MultimediaType.Recording: return 'Recording';
      case MultimediaType.Audio: return 'Audio';
      case MultimediaType.Word: return 'Word';
      case MultimediaType.Excel: return 'Excel';
      case MultimediaType.PowerPoint: return 'PowerPoint';
      case MultimediaType.TXT: return 'TXT';
      default: return null;
    }
  }

  static MultimediaType getByName(String name) {
    switch(name) {
      case 'GIF': return MultimediaType.GIF;
      case 'Image': return MultimediaType.Image;
      case 'Video': return MultimediaType.Video;
      case 'Music': return MultimediaType.Music;
      case 'Recording': return MultimediaType.Recording;
      case 'Audio': return MultimediaType.Audio;
      case 'Word': return MultimediaType.Word;
      case 'Excel': return MultimediaType.Excel;
      case 'PowerPoint': return MultimediaType.PowerPoint;
      case 'TXT': return MultimediaType.TXT;
    }
  }
}