import 'package:dw_application/src/mapping/main_map.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../mapping/floor_map.dart';
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
    mainMap.currentFloor?.key?.currentState?.moveToNode(index);
  }

  @override
  Widget build(BuildContext context) {
    mainMap = MainMap(popupState: this);
    return Scaffold(
      appBar: AppBar(
        title: Text("Test"),
      ),
      body: SlidingUpPanel(
        borderRadius: BorderRadius.circular(20),
        panel: Column(
          children: [
            const SizedBox(height: 5),
            Column(
              children: [
                Text(
                  displayText,
                  style: const TextStyle(color: Colors.black),
                ),
                TextButton(
                  onPressed: (){zoom(exhibitIndex);},
                  child: const Text("Go to point"))
              ],
            ),
          ],
        ),
        body: Center(
          child: mainMap,
        ),
      ),
    );
  }
}