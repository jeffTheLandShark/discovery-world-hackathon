// import 'package:dw_application/src/mapping/exhibit_node.dart';
import 'package:dw_application/src/mapping/floor_map.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../exhibit_popup/exhibit_popup.dart';
import 'floor_transition_node.dart';


Future<String> loadAsset() async {
  return await rootBundle.loadString('assets/config.json');
}

class MainMap extends StatefulWidget {
  
  GlobalKey<MainMapState>? _mainKey;
  
  MainMap({super.key, required this.popupState, required GlobalKey<MainMapState> mainKey}) {
    _mainKey = mainKey;
  }
  final ExhibitPopupState popupState;
  List<FloorMap> sections = [];
  FloorMap? currentFloor;

  @override
  GlobalKey<MainMapState>? get key => _mainKey;

  @override
  MainMapState createState() => MainMapState();
}

class MainMapState extends State<MainMap> {
  GlobalKey<FloorMapState> floorMapKey = GlobalKey<FloorMapState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void transitionFloor(FloorTransitionNode start, FloorTransitionNode end){
    //TODO: Implement transitionFloor
  }

  void setFloor(int index){
    if(index >= 0 && index < widget.sections.length){
      currentFloor = widget.sections[index];
      widget.currentFloor = currentFloor;
    }
  }
  
  late FloorMap currentFloor;

  @override
  Widget build(BuildContext context) {

    widget.sections = [
      FloorMap(path: 'assets/images/map_assets/Tech Floor 1.png', popup: widget.popupState, key: floorMapKey,),
      FloorMap(path: 'assets/images/map_assets/Tech Floor 2.png', popup: widget.popupState, key: floorMapKey,),
      FloorMap(path: 'assets/images/map_assets/Tech Lower Level.png', popup: widget.popupState, key: floorMapKey,),
      FloorMap(path: 'assets/images/map_assets/Tech Mezzanine.png', popup: widget.popupState, key: floorMapKey,),
    ];
    
    currentFloor = widget.sections[0];
    widget.currentFloor = currentFloor;

    return 
        currentFloor;
  }
  
}
