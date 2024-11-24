import 'floor_map.dart';

class FloorTransitionNode extends MapNode {
  String type;
  List<FloorTransitionNode> canGoTo = [];

  FloorTransitionNode(
      {required super.floor,
      required super.xPos,
      required super.yPos,
      required this.canGoTo,
      this.type = "Stairs"});

  List<FloorTransitionNode> get getCanGoTo => canGoTo;
  String get getType => type;
}

class ExhibitNode extends MapNode {
  String id;
  String description;

  ExhibitNode(
      {required super.floor,
      required super.xPos,
      required super.yPos,
      required this.id,
      required this.description});
}

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
