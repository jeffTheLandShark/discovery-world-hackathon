import 'map_node.dart';

class FloorTransitionNode extends MapNode {
  String type;
  List<FloorTransitionNode> canGoTo = [];
  
  
  FloorTransitionNode({required super.floor, required super.xPos, required super.yPos, required this.canGoTo, this.type = "Stairs"});

  List<FloorTransitionNode> get getCanGoTo => canGoTo;
  String get getType => type;
}
