import 'dart:collection';

// import 'package:dw_application/src/mapping/main_map.dart';
import 'package:flutter/material.dart';

import 'floor_transition_node.dart';
import 'map_node.dart';
import 'exhibit_node.dart';

// import 'package:dw_application/src/mapping/floor_map.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter/services.dart' show rootBundle;

import '../exhibit_popup/exhibit_popup.dart';

class FloorMap extends StatefulWidget {
  final String _path;
  final ExhibitPopupState _popup;

  GlobalKey<FloorMapState>? _key;

  FloorMap({required String path, required ExhibitPopupState popup, required GlobalKey<FloorMapState> key})
      : _path = path,
        _popup = popup,
        _key = key,
        super(key: key);

  String get path => _path;
  GlobalKey<FloorMapState>? get key => _key;

  @override
  FloorMapState createState() => FloorMapState();
}

class FloorMapState extends State<FloorMap> with TickerProviderStateMixin {
  final TransformationController _controller = TransformationController();
  double _scale = 1.0;

  List<MapNode> mapNodes = [];
  static const double iconSize = 20;
  int? activeIconIndex;

  @override
  void initState() {
    super.initState();

    mapNodes = [
      ExhibitNode(floor: widget, xPos: 0, yPos: 0, description: "description 1"),
      ExhibitNode(floor: widget, xPos: 10, yPos: 10, description: "description 2"),
      ExhibitNode(floor: widget, xPos: 100, yPos: -20, description: "description 3"),
      ExhibitNode(floor: widget, xPos: -80, yPos: 20, description: "description 4"),
      ExhibitNode(floor: widget, xPos: -40, yPos: -10, description: "description 5"),
      FloorTransitionNode(floor: widget, xPos: 50, yPos: 50, canGoTo: List<FloorTransitionNode>.empty()),
    ];

    _controller.addListener(() {
      final scale = _controller.value.getMaxScaleOnAxis();
      print(_controller.value.getTranslation().x);
      print(_controller.value.getTranslation().y);
      print(" ");
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
    stackChildren.add(Image(image: AssetImage(widget.path)));

    for (int i = 0; i < mapNodes.length; i++) {
      final ex = mapNodes[i];
      Positioned p = Positioned(
        top: MediaQuery.of(context).size.height/2 + ex.yPos,
        left: MediaQuery.of(context).size.width/2 + ex.xPos,
        child: IconUpdater(
          node: ex,
          iconSize: iconSize,
          scale: _scale,
          isActive: activeIconIndex == i,
          onIconClick: () {
            setState(() {
              if (activeIconIndex != i) {
                activeIconIndex = i;
                if (ex is ExhibitNode) {
                  widget._popup.updateText(ex.description, i);
                } else if (ex is FloorTransitionNode) {
                  widget._popup.updateText(ex.type, -1);
                }
              } else {
                activeIconIndex = -1;
                widget._popup.updateText("Click an exhibit to view information", -1);
              }
            });
          },
        ),
      );
      stackChildren.add(p);
    }

    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Center(
      heightFactor: MediaQuery.sizeOf(context).height,
      child: InteractiveViewer(
        constrained: false,
        boundaryMargin: const EdgeInsets.all(100),
        minScale: 1,
        maxScale: 10,
        transformationController: _controller,
        child: Container(
          color: isDarkMode ? Color.fromARGB(255, 49, 48, 52) : Colors.white,
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

  void pan(MapNode start, MapNode end){
    //get the current scale of the map
    double scale = _controller.value.getMaxScaleOnAxis();

    // Adjust for the current scale (so the translation is scaled correctly)
    double targetX =  -end.xPos*scale;
    double targetY =  -end.yPos*scale;

    // Get the current transformation matrix
    Matrix4 currentMatrix = _controller.value;
    // Matrix4 targetMatrix = Matrix4.identity(); - replaced with the following line
    Matrix4 targetMatrix = currentMatrix.clone();

    // Calculate the difference in position between the current view center and the target position
    double offsetX = targetX - targetMatrix.getTranslation().x;//*scale;
    double offsetY = targetY - targetMatrix.getTranslation().y;//*scale;

    // Apply the translation to the current matrix (while preserving scale)
    targetMatrix.setTranslationRaw(targetX, targetY, 0.0);

    // Set up animation controller
    final AnimationController animationController = AnimationController(
      vsync: this, // Ensure your widget implements TickerProviderStateMixin
      duration: const Duration(milliseconds: 500), // Animation duration
    );

    // Set up tween between current and target matrix
    final Matrix4Tween tween = Matrix4Tween(
      begin: currentMatrix,
      end: targetMatrix,
    );

    // Start animation
    animationController.addListener(() {
      setState(() {
        _controller.value = tween.evaluate(animationController);
      });
    });

    animationController.forward();
  }

  // void moveToIcon(int index) {
  //   final ex = mapNodes[index];

  //   double scale = _controller.value.getMaxScaleOnAxis();
  //   // Adjust for the current scale (so the translation is scaled correctly)
  //   double targetX =  -ex.xPos*scale;
  //   double targetY =  -ex.yPos*scale;

  //   // Get the current transformation matrix
  //   Matrix4 currentMatrix = _controller.value;
  //   Matrix4 targetMatrix = Matrix4.identity();

  //   // Calculate the difference in position between the current view center and the target position
  //   double offsetX = targetX - targetMatrix.getTranslation().x*scale;
  //   double offsetY = targetY - targetMatrix.getTranslation().y*scale;

  //   // Apply the translation to the current matrix (while preserving scale)
  //   targetMatrix.translate(offsetX, offsetY);

  //   // Set up animation controller
  //   final AnimationController animationController = AnimationController(
  //     vsync: this, // Ensure your widget implements TickerProviderStateMixin
  //     duration: const Duration(milliseconds: 500), // Animation duration
  //   );

  //   // Set up tween between current and target matrix
  //   final Matrix4Tween tween = Matrix4Tween(
  //     begin: currentMatrix,
  //     end: targetMatrix,
  //   );

  //   // Start animation
  //   animationController.addListener(() {
  //     setState(() {
  //       _controller.value = tween.evaluate(animationController);
  //     });
  //   });

  //   animationController.forward();
  // }

  FloorTransitionNode? getTransitionNode(MapNode node) {
    if (node.floor == widget) {
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


class IconUpdater extends StatelessWidget {
  final double iconSize;
  final double scale; // Receive the scale from MainMap
  final bool isActive; // Indicates if the icon is active
  final VoidCallback onIconClick; // Add callback for click
  final MapNode node;

  const IconUpdater({
    super.key,
    required this.iconSize,
    required this.scale,
    required this.isActive, // Accept whether the icon is active
    required this.onIconClick, // Accept the callback
    required this.node,
  });

  @override
  Widget build(BuildContext context) {
    // Apply the inverse scale to the icon to maintain its constant size
    return Transform.scale(
      scale: 1 / scale, // Use the passed scale to update the icon size
      child: IconButton(
        icon: Icon(Icons.circle, color: isActive ? Colors.green : node is FloorTransitionNode ? Colors.blue : Colors.red),
        onPressed: onIconClick, // Call the provided callback
        iconSize: iconSize, // Use the passed iconSize
      ),
    );
  }
}
