import 'package:dw_application/src/mapping/floor_map.dart';

import 'map_node.dart';

class FloorTransitionNode extends MapNode {
  List<FloorTransitionNode> canGoTo;
  String type;
  
  
  FloorTransitionNode({required super.floor, required super.xPos, required super.yPos, required this.canGoTo, this.type = "Stairs"});

  List<FloorTransitionNode> get getCanGoTo => canGoTo;
  String get getType => type;
}
