import 'floor_map.dart';

class MapNode {
  FloorMap _floor;
  double _xPos;
  double _yPos;
  
  MapNode({required FloorMap floor, required double xPos, required double yPos})
      : _floor = floor,
        _xPos = xPos,
        _yPos = yPos;

  FloorMap get floor => _floor;
  double get xPos => _xPos;
  double get yPos => _yPos;
}