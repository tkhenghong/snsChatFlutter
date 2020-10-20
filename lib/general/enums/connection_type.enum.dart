enum ConnectionType { Wifi, MobileData }

extension ConnectionTypeUtil on ConnectionType {
  String get name {
    switch (this) {
      case ConnectionType.Wifi:
        return 'Wifi';
      case ConnectionType.MobileData:
        return 'MobileData';
      default:
        return null;
    }
  }

  static ConnectionType getByName(String name) {
    switch (name) {
      case 'Wifi':
        return ConnectionType.Wifi;
      case 'MobileData':
        return ConnectionType.MobileData;
      default:
        return null;
    }
  }
}
