import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<String> loadAsset() async {
  return await rootBundle.loadString('assets/config.json');
}

class MainMap extends StatefulWidget {
  MainMap({super.key});

  @override
  _MainMapState createState() => _MainMapState();
}

class _MainMapState extends State<MainMap> {
  final TransformationController _controller = TransformationController();
  double _scale = 1.0;  // To track the zoom scale

  final List<List<double>> dotPositions = [
    [0, 0],
    [10, 10],
    [100, 10],
    [75, 75]
  ];

  static const double iconSize = 15;

  @override
  void initState() {
    super.initState();

    // Listen for scale changes on the TransformationController
    _controller.addListener(() {
      final scale = _controller.value.getMaxScaleOnAxis();
      if (scale != _scale) {
        setState(() {
          _scale = scale;  // Update the scale when it changes
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final stackChildren = <Widget>[];
    stackChildren.add(const Image(image: AssetImage('assets/images/map_assets/tech_floor2.png')));

    for (List<double> l in dotPositions) {
      Positioned p = Positioned(
        bottom: MediaQuery.of(context).size.height / 2 - iconSize / 2 + l[0],
        left: MediaQuery.of(context).size.width / 2 - iconSize / 2 + l[1],
        child: IconUpdater(
          iconSize: iconSize,
          scale: _scale,  // Pass the updated scale
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

class IconUpdater extends StatefulWidget {
  final double iconSize;
  final double scale;  // Receive the scale from MainMap

  const IconUpdater({super.key, required this.iconSize, required this.scale});

  @override
  _IconUpdaterState createState() => _IconUpdaterState();
}

class _IconUpdaterState extends State<IconUpdater> {
  // Initial color of the icon
  Color iconColor = Colors.red;

  // Method to toggle the color on click
  void _changeIconColor() {
    setState(() {
      // Toggle between blue and red
      iconColor = (iconColor == Colors.red) ? Colors.blue : Colors.red;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Apply the inverse scale to the icon to maintain its constant size
    return Transform.scale(
      scale: 1 / widget.scale,  // Use the passed scale to update the icon size
      child: IconButton(
        icon: Icon(Icons.circle, color: iconColor),
        onPressed: _changeIconColor,
        iconSize: widget.iconSize,  // Use the passed iconSize
      ),
    );
  }
}