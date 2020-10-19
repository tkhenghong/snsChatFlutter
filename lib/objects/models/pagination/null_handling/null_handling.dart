enum NullHandling {
  NATIVE, NULLS_FIRST, NULLS_LAST
}

extension NullHandlingUtil on NullHandling {
  String get code {
    switch(this) {
      case NullHandling.NATIVE: return 'NATIVE';
      case NullHandling.NULLS_FIRST: return 'NULLS_FIRST';
      case NullHandling.NULLS_LAST: return 'NULLS_LAST';
      default: return null;
    }
  }

  static NullHandling getByName(String name) {
    switch(name) {
      case 'NATIVE': return NullHandling.NATIVE;
      case 'NULLS_FIRST': return NullHandling.NULLS_FIRST;
      case 'NULLS_LAST': return NullHandling.NULLS_LAST;
      default: return null;
    }
  }
}