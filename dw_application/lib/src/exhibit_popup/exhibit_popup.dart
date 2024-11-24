import 'dart:collection';

import 'package:dw_application/src/mapping/main_map.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../mapping/floor_map.dart';
import '../mapping/floor_transition_node.dart';
import '../mapping/map_node.dart';

class ExhibitPopup extends StatefulWidget {
  const ExhibitPopup({
    Key? key,
    this.initialText = "Click an exhibit to view information", // Initial text value
  }) : super(key: key);

  final String initialText;

  @override
  ExhibitPopupState createState() => ExhibitPopupState();
}

class ExhibitPopupState extends State<ExhibitPopup> {
  GlobalKey<MainMapState> mainMapKey = GlobalKey<MainMapState>();
  late String displayText;
  int exhibitIndex = -1;

  @override
  void initState() {
    super.initState();
    displayText = widget.initialText;
  }

  void updateText(String newText, int index) {
    setState(() {
      displayText = newText;
      exhibitIndex = index;
    });
  }

  late MainMap mainMap;

  void zoom(int index){
    FloorMapState? floorState = mainMap.currentFloor?.key?.currentState;
    MainMapState? mapState = mainMap.key?.currentState;
    Queue<MapNode>? transitions = floorState?.getTransitions(floorState.mapNodes[floorState.activeIconIndex!], floorState.mapNodes[index]);
    if (transitions!.isEmpty) {
      print("panning, no transition");
      floorState?.pan(floorState.mapNodes[floorState.activeIconIndex!], floorState.mapNodes[index]);
    } else {
      for (var node in transitions){
        if (node is FloorTransitionNode) {
          print("panning");
          floorState?.pan(floorState.mapNodes[floorState.activeIconIndex!], node);
        } else {
          print("Transitioning to floor");
          mapState!.transitionFloor(floorState!.mapNodes[floorState.activeIconIndex!] as FloorTransitionNode, node as FloorTransitionNode);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    mainMap = MainMap(popupState: this, mainKey: mainMapKey);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Exhibit Explorer"),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Icon(
              Icons.search,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: SlidingUpPanel(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        maxHeight: 400,
        minHeight: 100,
        panel: _buildPanel(context),
        body: Center(
          child: mainMap,
        ),
      ),
    );
  }

  Widget _buildPanel(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Container(
          height: 4,
          width: 60,
          decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        const SizedBox(height: 10),
        Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Image.network(
                  'https://via.placeholder.com/100',
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'All Aboard',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Explore the wonders of technology and innovation at our exhibit.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: () {
                          zoom(0);
                        },
                        icon: const Icon(Icons.map),
                        label: const Text('Take me there'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: 'Tech Lower level',
              items: <String>[
                'Tech Lower level',
                'Tech level 1',
                'Tech level 2',
                'Tech Mezzanine',
                'Building Side View'
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                // Handle change
              },
            ),
          ),
        ),
      ],
    );
  }
}





// import 'dart:collection';

// import 'package:dw_application/src/mapping/main_map.dart';
// import 'package:flutter/material.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';

// import '../mapping/floor_map.dart';
// import '../mapping/floor_transition_node.dart';
// import '../mapping/map_node.dart';

// class ExhibitPopup extends StatefulWidget {
//   const ExhibitPopup({
//     Key? key,
//     this.initialText = "Click an exhibit to view information", // Initial text value
//   }) : super(key: key);

//   final String initialText;

//   @override
//   ExhibitPopupState createState() => ExhibitPopupState();
// }

// class ExhibitPopupState extends State<ExhibitPopup> {
//   GlobalKey<MainMapState> mainMapKey = GlobalKey<MainMapState>();
//   late String displayText;
//   int exhibitIndex = -1;

//   @override
//   void initState() {
//     super.initState();
//     displayText = widget.initialText;
//   }

//   void updateText(String newText, int index) {
//     setState(() {
//       displayText = newText;
//       exhibitIndex = index;
//     });
//   }

//   late MainMap mainMap;

//   void zoom(int index){
//     FloorMapState? floorState = mainMap.currentFloor?.key?.currentState;
//     MainMapState? mapState = mainMap.key?.currentState;
//     Queue<MapNode>? transitions = floorState?.getTransitions(floorState.mapNodes[floorState.activeIconIndex!], floorState.mapNodes[index]);
//     if (transitions!.isEmpty) {
//       print("panning, no transition");
//       floorState?.pan(floorState.mapNodes[floorState.activeIconIndex!], floorState.mapNodes[index]);
//     } else {
//       for (var node in transitions){
//         if (node is FloorTransitionNode) {
//           print("panning");
//           floorState?.pan(floorState.mapNodes[floorState.activeIconIndex!], node);
//         } else {
//           print("Transitioning to floor");
//           mapState!.transitionFloor(floorState!.mapNodes[floorState.activeIconIndex!] as FloorTransitionNode, node as FloorTransitionNode);
//         }
//       }
//     }
// }

//   @override
//   Widget build(BuildContext context) {
//     mainMap = MainMap(popupState: this, mainKey: mainMapKey);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Test"),
//       ),
//       body: SlidingUpPanel(
//         borderRadius: BorderRadius.circular(20),
//         panel: Column(
//           children: [
//             const SizedBox(height: 5),
//             Column(
//               children: [
//                 Text(
//                   displayText,
//                   style: const TextStyle(color: Colors.black),
//                 ),
//                 TextButton(
//                   onPressed: (){zoom(0);},
//                   child: const Text("Go to point"))
//               ],
//             ),
//           ],
//         ),
//         body: Center(
//           child: mainMap,
//         ),
//       ),
//     );
//   }
// }