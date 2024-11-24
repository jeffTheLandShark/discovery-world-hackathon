import 'map_node.dart';

class FloorTransitionNode extends MapNode {
  List<FloorTransitionNode> canGoTo = [];
  
  FloorTransitionNode({required super.floor, required super.xPos, required super.yPos, required this.canGoTo});

  List<FloorTransitionNode> get getCanGoTo => canGoTo;
}
