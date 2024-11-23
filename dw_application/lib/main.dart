import 'package:flutter/material.dart';

import 'earth_ar.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Earth_AR()
      );
  }
}





// import 'src/app.dart';
// import 'src/settings/settings_controller.dart';
// import 'src/settings/settings_service.dart';

// import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
// import 'package:vector_math/vector_math_64.dart' as vector;

// import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart'
//     show ArCoreController;


// void main() {
//   runApp(MaterialApp(home: ARScreen()));
// }

// class ARScreen extends StatefulWidget {
//   @override
//   _ARScreenState createState() => _ARScreenState();
// }

// class _ARScreenState extends State<ARScreen> {
//   late ArCoreController arCoreController;

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     arCoreController.dispose();
//   }

//   // Add object to plane when the plane is detected
//   _onArCoreViewCreated(ArCoreController controller) {
//     arCoreController = controller;
//     try {
//       arCoreController.onPlaneDetected = _onPlaneDetected;
//       print('Plane detection callback assigned.');
//     } catch (e) {
//       print('Error setting up plane detection: $e');
//     }
//     print("ARCore view created!");
//   }

//   _onPlaneDetected(ArCorePlane plane) {
//     print('Detected plane type: ${plane.type}');
//     if (plane.type == ArCorePlaneType.HORIZONTAL_UPWARD_FACING) {
//       _addObjectToPlane(plane);
//     }
//   }

//   // Add the object to the detected plane
//   _addObjectToPlane(ArCorePlane plane) {
//     print("Adding Object...");
//     final node = ArCoreReferenceNode(
//       name: 'earth',
//       object3DFileName: 'earth.obj',  // Replace with your object path
//       position: vector.Vector3(0, 0, -1), // Position 1 meter away from the camera
//       scale: vector.Vector3(10, 10, 10), // Scale for the 3D object
//     );
//     arCoreController.addArCoreNodeWithAnchor(node);
//     print("Object added!");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('ARCore Flutter Plugin')),
//       body: ArCoreView(
//         onArCoreViewCreated: _onArCoreViewCreated,
//         enablePlaneRenderer: true,
//       ),
//     );
//   }
// }