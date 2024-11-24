import 'dart:collection';
import 'package:flutter/material.dart';
import 'map_node.dart';
import '../exhibit_popup/exhibit_popup.dart';
import 'package:collection/collection.dart';

class FloorMap extends StatefulWidget {
  final String path;
  final ExhibitPopupState popup;
  final GlobalKey<FloorMapState> key;

  FloorMap({required this.path, required this.popup, required this.key})
      : super(key: key);

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
    _initializeMapNodes();
    _controller.addListener(_onScaleChanged);
    setViewer();
  }

  void setViewer(){
    // Clone the current transformation matrix
    // Get the screen size

    // Calculate the target translation to center the content

    // Create a new transformation matrix
    final Matrix4 newMatrix = Matrix4.identity()
      ..translate(0, -100);

    // Apply the updated matrix to the controller
    _controller.value = newMatrix;
  }

  void clearNodes() {
    setState(() {
      mapNodes = [];
    });
  }

  void _initializeMapNodes() {
    // mapNodes = [
    //   FloorTransitionNode(
    //       floor: widget,
    //       xPos: 50,
    //       yPos: 50,
    //       canGoTo: List<FloorTransitionNode>.empty()),
    // ];
    mapNodes = [];
  }

  void _onScaleChanged() {
    final scale = _controller.value.getMaxScaleOnAxis();
    if (scale != _scale) {
      setState(() {
        _scale = scale;
      });
    }
  }

  void addExhibitNode(ExhibitNode node) {
    //setState(() {
      mapNodes.add(node);
    //});
  }

  @override
  Widget build(BuildContext context) {
    final stackChildren = <Widget>[
      Container(width: 500, height: 500, child: Image(image: AssetImage(widget.path))),
      ..._buildMapNodes(context),
    ];

    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return
      InteractiveViewer(
        constrained: false,
        boundaryMargin: const EdgeInsets.all(100),
        minScale: 1,
        maxScale: 10,
        transformationController: _controller,
        child: Container(
          color: isDarkMode ? Color.fromARGB(255, 49, 48, 52) : Colors.white,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Positioned(
            child: Stack(
              alignment: Alignment.center,
              children: stackChildren,
            ),
          ),
        ),
      );
  }

  List<Widget> _buildMapNodes(BuildContext context) {
    return mapNodes.asMap().entries.map((entry) {
      final index = entry.key;
      final ex = entry.value;
      return Positioned(
        top: MediaQuery.of(context).size.height / 2 + ex.yPos,
        left: MediaQuery.of(context).size.width / 2 + ex.xPos,
        child: IconUpdater(
          node: ex,
          iconSize: iconSize,
          scale: _scale,
          isActive: activeIconIndex == index,
          onIconClick: () => _onIconClick(index, ex),
        ),
      );
    }).toList();
  }

  void _onIconClick(int index, MapNode ex) {
    print('Icon clicked: index=$index, activeIconIndex=$activeIconIndex');
    setState(() {
      if (activeIconIndex != index) {
        activeIconIndex = index;
        widget.popup.updateText(
            ex is ExhibitNode
                ? ex.id
                : (ex as FloorTransitionNode).type,
            index);
      } else {
        activeIconIndex = -1;
        widget.popup.updateText("Click an exhibit to view information", -1);
      }
    });
  }

  void pan(MapNode start, MapNode end) {
    double scale = _controller.value.getMaxScaleOnAxis();
    double targetX = -end.xPos * scale;
    double targetY = -end.yPos * scale;
    Matrix4 currentMatrix = _controller.value;
    Matrix4 targetMatrix = currentMatrix.clone();
    targetMatrix.setTranslationRaw(targetX, targetY, 0.0);

    final AnimationController animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    final Matrix4Tween tween = Matrix4Tween(
      begin: currentMatrix,
      end: targetMatrix,
    );

    animationController.addListener(() {
      setState(() {
        _controller.value = tween.evaluate(animationController);
      });
    });

    animationController.forward();
  }

  FloorTransitionNode? getTransitionNode(MapNode node) {
    if (node.floor == widget) {
      return null;
    }
    return mapNodes
        .whereType<FloorTransitionNode>()
        .firstWhereOrNull((element) => element.canGoTo.contains(node));
  }

  Queue<MapNode> getTransitions(MapNode start, MapNode end) {
    Queue<MapNode> transitions = Queue();
    FloorTransitionNode? transition = getTransitionNode(end);
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
  final double scale;
  final bool isActive;
  final VoidCallback onIconClick;
  final MapNode node;

  const IconUpdater({
    super.key,
    required this.iconSize,
    required this.scale,
    required this.isActive,
    required this.onIconClick,
    required this.node,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1 / scale,
      child: IconButton(
        icon: Icon(Icons.circle,
            color: isActive
                ? Colors.green
                : node is FloorTransitionNode
                    ? Colors.blue
                    : Colors.red),
        onPressed: onIconClick,
        iconSize: iconSize,
      ),
    );
  }
}
