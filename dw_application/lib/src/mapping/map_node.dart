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
  int _xPos;
  int _yPos;

  MapNode({required FloorMap floor, required int xPos, required int yPos})
      : _floor = floor,
        _xPos = xPos,
        _yPos = yPos;

  FloorMap get floor => _floor;
  int get xPos => _xPos;
  int get yPos => _yPos;
}
