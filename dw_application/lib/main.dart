import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

// void main() async {
//   // Set up the SettingsController, which will glue user settings to multiple
//   // Flutter Widgets.
//   final settingsController = SettingsController(SettingsService());

//   // Load the user's preferred theme while the splash screen is displayed.
//   // This prevents a sudden theme change when the app is first displayed.
//   await settingsController.loadSettings();

//   // Run the app and pass in the SettingsController. The app listens to the
//   // SettingsController for changes, then passes it further down to the
//   // SettingsView.
//   runApp(MyApp(settingsController: settingsController));
// }

import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart'
    show ArCoreController;

import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';

void main() {
  runApp(MaterialApp(home: ARScreen()));
}

class ARScreen extends StatefulWidget {
  @override
  _ARScreenState createState() => _ARScreenState();
}

class _ARScreenState extends State<ARScreen> {
  late ArCoreController arCoreController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    arCoreController.dispose();
  }

  // Add object to plane when the plane is detected
  _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    arCoreController.onPlaneDetected = _onPlaneDetected;
  }

  _onPlaneDetected(ArCorePlane plane) {
    if (plane.type == ArCorePlaneType.HORIZONTAL_UPWARD_FACING) {
      _addObjectToPlane(plane);
    }
  }

  // Add the object to the detected plane
  _addObjectToPlane(ArCorePlane plane) {
    final node = ArCoreReferenceNode(
      name: 'earth',
      object3DFileName: 'earth.obj',  // Replace with your object path
      position: vector.Vector3(0, 0, -1), // Position 1 meter away from the camera
      scale: vector.Vector3(0.1, 0.1, 0.1), // Scale for the 3D object
    );
    arCoreController.addArCoreNodeWithAnchor(node);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ARCore Flutter Plugin')),
      body: ArCoreView(
        onArCoreViewCreated: _onArCoreViewCreated,
      ),
    );
  }
}

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   print('ARCORE IS AVAILABLE?');
//   print(await ArCoreController.checkArCoreAvailability());
//   print('\nAR SERVICES INSTALLED?');
//   print(await ArCoreController.checkIsArCoreInstalled());
//   runApp(HelloWorld());
// }

// class HelloWorld extends StatefulWidget {
//   const HelloWorld({super.key});

//   @override
//   _HelloWorldState createState() => _HelloWorldState();
// }

// class _HelloWorldState extends State<HelloWorld> {
//   ArCoreController arCoreController = ArCoreController(id: 0);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Hello World'),
//         ),
//         body: ArCoreView(
//           onArCoreViewCreated: _onArCoreViewCreated,
//         ),
//       ),
//     );
//   }

//   void _onArCoreViewCreated(ArCoreController controller) {
//     arCoreController = controller;

//     _addSphere(arCoreController);
//     _addCylindre(arCoreController);
//     _addCube(arCoreController);
//   }

//   void _addSphere(ArCoreController controller) {
//     final material = ArCoreMaterial(
//         color: Color.fromARGB(120, 66, 134, 244));
//     final sphere = ArCoreSphere(
//       materials: [material],
//       radius: 0.1,
//     );
//     final node = ArCoreNode(
//       shape: sphere,
//       position: vector.Vector3(0, 0, -1.5),
//     );
//     controller.addArCoreNode(node);
//   }

//   void _addCylindre(ArCoreController controller) {
//     final material = ArCoreMaterial(
//       color: Colors.red,
//       reflectance: 1.0,
//     );
//     final cylindre = ArCoreCylinder(
//       materials: [material],
//       radius: 0.5,
//       height: 0.3,
//     );
//     final node = ArCoreNode(
//       shape: cylindre,
//       position: vector.Vector3(0.0, -0.5, -2.0),
//     );
//     controller.addArCoreNode(node);
//   }

//   void _addCube(ArCoreController controller) {
//     final material = ArCoreMaterial(
//       color: Color.fromARGB(120, 66, 134, 244),
//       metallic: 1.0,
//     );
//     final cube = ArCoreCube(
//       materials: [material],
//       size: vector.Vector3(0.5, 0.5, 0.5),
//     );
//     final node = ArCoreNode(
//       shape: cube,
//       position: vector.Vector3(-0.5, 0.5, -3.5),
//     );
//     controller.addArCoreNode(node);
//   }

//   @override
//   void dispose() {
//     arCoreController.dispose();
//     super.dispose();
//   }
// }
