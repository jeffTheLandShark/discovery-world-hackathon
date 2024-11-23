import 'package:dw_application/src/mapping/main_map.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../mapping/floor_map.dart';
import '../mapping/map_node.dart';

class ExhibitPopup extends StatefulWidget {
  const ExhibitPopup({
    Key? key,
    this.initialText = "This is a slider", // Initial text value
  }) : super(key: key);

  final String initialText;

  @override
  ExhibitPopupState createState() => ExhibitPopupState();
}

class ExhibitPopupState extends State<ExhibitPopup> {
  late String displayText;

  @override
  void initState() {
    super.initState();
    displayText = widget.initialText;
  }

  void updateText(String newText) {
    setState(() {
      
      displayText = newText;
      print("Text changed");
    });
  }

  @override
  Widget build(BuildContext context) { 
    return Scaffold(
      appBar: AppBar(
        title: Text("Test"),
      ),
      body: SlidingUpPanel(
        borderRadius: BorderRadius.circular(20),
        panel: Column(
          children: [
            const SizedBox(height: 5),
            Container(
              child: Text(
                displayText,
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
        body: Center(
          child: MainMap(popup: this,
          mapNodes:[
          MapNode(floor: FloorMap(path:'assets/images/map_assets/tech_floor2.png'),xPos: 50,yPos: 100),
          MapNode(floor: FloorMap(path:'assets/images/map_assets/tech_floor2.png'), xPos: 0, yPos: 40),
          MapNode(floor: FloorMap(path:'assets/images/map_assets/tech_floor2.png'), xPos: 75, yPos: 100),
          MapNode(floor: FloorMap(path:'assets/images/map_assets/tech_floor2.png'), xPos: 13, yPos: 12),]),
        ),
      ),
    );
  }
}