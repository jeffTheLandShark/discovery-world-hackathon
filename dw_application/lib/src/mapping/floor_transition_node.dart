import 'package:dw_application/src/mapping/floor_map.dart';

import 'map_node.dart';

class FloorTransitionNode extends MapNode {
  List<FloorMap> canGoTo;
  
  FloorTransitionNode({required super.floor, required super.xPos, required super.yPos, required this.canGoTo});
}