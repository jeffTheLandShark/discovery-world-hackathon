import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<String> loadAsset() async {
  return await rootBundle.loadString('assets/config.json');
}

class MainMap extends StatelessWidget {
  const MainMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      heightFactor: MediaQuery.sizeOf(context).height,
      child: InteractiveViewer(
        constrained: false,
        boundaryMargin: const EdgeInsets.all(20),
        minScale: 0.1,
        maxScale: 5,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: const Image(image: AssetImage('assets/images/map_assets/tech_floor2.png'))
            ),
        )
      ),
    );
  }
}
