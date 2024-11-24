import 'map_node.dart';

class ExhibitNode extends MapNode {
  String id;
  String description;
  
  ExhibitNode({
    required super.floor, 
    required super.xPos, 
    required super.yPos, 
    required this.id,
    required this.description
  });
}