import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'exhibit_map_data.dart';
import '../exhibit_popup/exhibit_popup.dart';
import 'map_node.dart';

Future<String> loadAsset() async {
  return await rootBundle.loadString('assets/config.json');
}

class MainMap extends StatefulWidget {
  final List<MapNode> mapNodes;

  MainMap({super.key, required this.mapNodes, required this.popup});

  ExhibitPopupState popup;

  @override
  _MainMapState createState() => _MainMapState();
}

class _MainMapState extends State<MainMap> {
  final TransformationController _controller = TransformationController();
  double _scale = 1.0; // To track the zoom scale

  // Add a GlobalKey for ExhibitPopup
  final GlobalKey<ExhibitPopupState> popupKey = GlobalKey();

  final List<ExhibitMapData> exhibits = [
    ExhibitMapData("Exhibit 1", "This is description for exhibit 1", 0, 0),
    ExhibitMapData("Exhibit 2", "This is description for exhibit 2", -20, 10),
    ExhibitMapData("Exhibit 3", "This is description for exhibit 3", 30, -20),
    ExhibitMapData("Exhibit 4", "This is description for exhibit 4", 100, 20),
  ];

  static const double iconSize = 20;

  // Keep track of the active icon's index
  int? activeIconIndex;

  @override
  void initState() {
    super.initState();

    // Listen for scale changes on the TransformationController
    _controller.addListener(() {
      final scale = _controller.value.getMaxScaleOnAxis();
      if (scale != _scale) {
        setState(() {
          _scale = scale; // Update the scale when it changes
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
        bottom: MediaQuery.of(context).size.height / 2 - iconSize / 2 + ex.y,
        left: MediaQuery.of(context).size.width / 2 - iconSize / 2 + ex.x,
        child: IconUpdater(
          iconSize: iconSize,
          scale: _scale, // Pass the updated scale
          isActive: activeIconIndex == i, // Pass whether the icon is active
          onIconClick: () {
            setState(() {
              activeIconIndex = i; // Update the active icon index
            });
            widget.popup.updateText(ex.description); // Update the text dynamically
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
