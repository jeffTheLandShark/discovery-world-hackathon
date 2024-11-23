import 'package:dw_application/src/mapping/main_map.dart';
import 'package:flutter/material.dart';

import 'map_node.dart';
import 'exhibit_node.dart';

import 'package:dw_application/src/mapping/floor_map.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart' show rootBundle;

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

  List<ExhibitNode> exhibits = [];
  static const double iconSize = 20;
  int? activeIconIndex;

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
    stackChildren.add(const Image(image: AssetImage('assets/images/map_assets/tech_floor2.png')));

    for (int i = 0; i < exhibits.length; i++) {
      final ex = exhibits[i];
      Positioned p = Positioned(
        top: MediaQuery.of(context).size.height/2 + ex.yPos,
        left: MediaQuery.of(context).size.width/2 + ex.xPos,
        child: IconUpdater(
          iconSize: iconSize,
          scale: _scale,
          isActive: activeIconIndex == i,
          onIconClick: () {
            setState(() {
              if (activeIconIndex != i) {
                activeIconIndex = i;
                widget._popup.updateText(ex.description, i);
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

    return Center(
      heightFactor: MediaQuery.sizeOf(context).height,
      child: InteractiveViewer(
        constrained: false,
        boundaryMargin: const EdgeInsets.all(100),
        minScale: 1,
        maxScale: 10,
        transformationController: _controller,
        child: Container(
          color: Colors.white,
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

  }

  void moveToNode(int index) {
  if (index < 0 || index >= exhibits.length) {
    return;
  }

  final ex = exhibits[index];
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  double scale = _controller.value.getMaxScaleOnAxis();

  // Adjust for the current scale (so the translation is scaled correctly)
  double targetX =  -ex.xPos*scale;
  double targetY =  -ex.yPos*scale;

  // Get the current transformation matrix
  Matrix4 currentMatrix = _controller.value;
  Matrix4 targetMatrix = Matrix4.identity();

  // Calculate the difference in position between the current view center and the target position
  double offsetX = targetX - targetMatrix.getTranslation().x*scale;
  double offsetY = targetY - targetMatrix.getTranslation().y*scale;

  // Apply the translation to the current matrix (while preserving scale)
  targetMatrix.translate(offsetX, offsetY);

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
