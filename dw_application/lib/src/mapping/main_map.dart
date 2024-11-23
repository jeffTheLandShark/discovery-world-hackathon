import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<String> loadAsset() async {
  return await rootBundle.loadString('assets/config.json');
}

class MainMap extends StatelessWidget {
  MainMap({super.key});

  final IconColorChanger icon = IconColorChanger();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InteractiveViewer(
        constrained: false,
        boundaryMargin: const EdgeInsets.all(double.infinity),
        minScale: 0.1,
        maxScale: 10,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Image(image: AssetImage('assets/images/map_assets/tech_floor2.png')),
              Positioned(
                top: 0,
                right: 0,
                child: icon),
            ],
          ),
        )
      ),
    );
  }
}

class IconColorChanger extends StatefulWidget {
  @override
  _IconColorChangerState createState() => _IconColorChangerState();
}

class _IconColorChangerState extends State<IconColorChanger> {
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
    return IconButton(
      icon: Icon(Icons.circle, color: iconColor),
      onPressed: _changeIconColor,
      iconSize: 30,
    );
  }
}