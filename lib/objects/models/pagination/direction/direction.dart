enum Direction { ASC, DESC }

extension DirectionUtil on Direction {
  String get name {
    switch (this) {
      case Direction.ASC:
        return 'ASC';
      case Direction.DESC:
        return 'DESC';
      default:
        return null;
    }
  }

  static Direction getByName(String name) {
    switch (name) {
      case 'ASC':
        return Direction.ASC;
      case 'DESC':
        return Direction.DESC;
      default:
        return null;
    }
  }
}
