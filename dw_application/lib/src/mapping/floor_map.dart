import 'package:dw_application/src/mapping/main_map.dart';
import 'package:flutter/material.dart';
import 'dart:collection';

import 'map_node.dart';
import 'exhibit_node.dart';

import 'package:dw_application/src/mapping/floor_map.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'floor_transition_node.dart';

import '../exhibit_popup/exhibit_popup.dart';

class FloorMap extends StatefulWidget {
  final String _path;
  final ExhibitPopupState _popup;

  // Define a GlobalKey to access the FloorMapState
  final GlobalKey<FloorMapState> _key = GlobalKey<FloorMapState>();

  FloorMap({required String path, required ExhibitPopupState popup})
      : _path = path,
        _popup = popup;

  String get path => _path;

  List<MapNode> mapNodes = [];

  // Method to zoom on a specific exhibit
  void zoomOnExhibit(int exhibitIndex) {
    // Access the FloorMapState and call movePosition
    _key.currentState?.movePosition(mapNodes[exhibitIndex].xPos, mapNodes[exhibitIndex].yPos);
  }

  @override
  Widget build(BuildContext context) {
    mapNodes = [
      ExhibitNode(floor: this, xPos: 0, yPos: 0, description: "description")
    ];
    return Container();
  }

  @override
  FloorMapState createState() => FloorMapState();

  /// Retrieves a transition node that can transition to the specified [node]'s floor.
  /// 
  /// If the specified [node] is already on the same floor, returns `null`.
  /// Otherwise, iterates through the list of map nodes and returns the first 
  /// [FloorTransitionNode] that can transition to the specified [node]'s floor.
  /// 
  /// Returns `null` if no such transition node is found.
  /// 
  /// - Parameter node: The target [MapNode] to find a transition node for.
  /// - Returns: A [FloorTransitionNode] that can transition to the specified [node]'s floor, or `null` if no such node exists.
  FloorTransitionNode? getTransitionNode(MapNode node) {
    if (node.floor == this) {
      return null;
    }
    for (var element in mapNodes) {
      if (element is FloorTransitionNode) {
        if (element.canGoTo.contains(node)) {
          return element;
        }
      }
    }
    return null;
  }

  Queue<MapNode> getTransitions(MapNode start, MapNode end) {
    Queue<MapNode> transitions = Queue();
    FloorTransitionNode? transition = getTransitionNode(end);

    //At the moment, this is true both if the nodes are on the same floor as well as if there is more than one step to get to the end node
    if (transition == null) {
      return transitions;
    }
    transitions.add(transition);

    for (var node in transition.canGoTo) {
      if (node.floor == end.floor) {
        transitions.add(node);
        return transitions;
      }
    }
  
    return transitions;
  }

}

class FloorMapState extends State<FloorMap> {
  final TransformationController _controller = TransformationController();
  double _scale = 1.0;

  List<ExhibitNode> exhibits = [];
  static const double iconSize = 20;
  int? activeIconIndex;

  // Method to move position
  void movePosition(double x, double y) {
    // Extract the current scale from the transformation matrix
    final Matrix4 currentMatrix = _controller.value;
    final double currentScale = currentMatrix.getMaxScaleOnAxis();

    // Create a new matrix with the same scale but updated position
    _controller.value = Matrix4.identity()
      ..scale(currentScale) // Preserve the current scale
      ..translate(x, y);    // Update the position
  }

  @override
  void initState() {
    super.initState();

    exhibits = [
      ExhibitNode(floor: widget, xPos: 0, yPos: 0, description: "description 1"),
      ExhibitNode(floor: widget, xPos: 10, yPos: 10, description: "description 2"),
      ExhibitNode(floor: widget, xPos: 100, yPos: -20, description: "description 3"),
      ExhibitNode(floor: widget, xPos: -80, yPos: 20, description: "description 4"),
      ExhibitNode(floor: widget, xPos: -40, yPos: -10, description: "description 5"),
    ];

    _controller.addListener(() {
      final scale = _controller.value.getMaxScaleOnAxis();
      if (scale != _scale) {
        setState(() {
          _scale = scale;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final stackChildren = <Widget>[];
    stackChildren.add(const Image(image: AssetImage('assets/images/map_assets/tech_floor2.png')));

    for (int i = 0; i < exhibits.length; i++) {
      final ex = exhibits[i];
      Positioned p = Positioned(
        bottom: MediaQuery.of(context).size.height / 2 - iconSize / 2 + ex.yPos,
        left: MediaQuery.of(context).size.width / 2 - iconSize / 2 + ex.xPos,
        child: IconUpdater(
          iconSize: iconSize,
          scale: _scale,
          isActive: activeIconIndex == i,
          onIconClick: () {
            widget.zoomOnExhibit(i);
            setState(() {
              if (activeIconIndex != i) {
                activeIconIndex = i;
                widget._popup.updateText(ex.description);
              } else {
                activeIconIndex = -1;
                widget._popup.updateText("Click an exhibit to view information");
              }
            });
          },
        ),
      );
      stackChildren.add(p);
    }

    return Center(
      heightFactor: MediaQuery.sizeOf(context).height,
      child: InteractiveViewer(
        constrained: false,
        boundaryMargin: const EdgeInsets.all(20),
        minScale: 0.1,
        maxScale: 10,
        transformationController: _controller,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            alignment: Alignment.center,
            children: stackChildren,
          ),
        ),
      ),
    );
  }
}


class IconUpdater extends StatelessWidget {
  final double iconSize;
  final double scale; // Receive the scale from MainMap
  final bool isActive; // Indicates if the icon is active
  final VoidCallback onIconClick; // Add callback for click

  const IconUpdater({
    super.key,
    required this.iconSize,
    required this.scale,
    required this.isActive, // Accept whether the icon is active
    required this.onIconClick, // Accept the callback
  });

  @override
  Widget build(BuildContext context) {
    // Apply the inverse scale to the icon to maintain its constant size
    return Transform.scale(
      scale: 1 / scale, // Use the passed scale to update the icon size
      child: IconButton(
        icon: Icon(Icons.circle, color: isActive ? Colors.blue : Colors.red),
        onPressed: onIconClick, // Call the provided callback
        iconSize: iconSize, // Use the passed iconSize
      ),
    );
  }
}
