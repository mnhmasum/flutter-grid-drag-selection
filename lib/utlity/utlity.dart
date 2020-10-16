import 'package:dijkshortpath/coordinate.dart';

class Utility {
  static Coordinate getXY(int index) {
    Coordinate c = new Coordinate();
    c.x = (index / 10).floor();
    c.y = index % 10;
    return c;
  }
}
