import 'map_node.dart';

class ExhibitNode extends MapNode {
  String description;
  
  ExhibitNode({required super.floor, required super.xPos, required super.yPos, required this.description});
}