// import 'package:dw_application/src/mapping/exhibit_node.dart';
import 'package:dw_application/src/mapping/floor_map.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../exhibit_popup/exhibit_popup.dart';
import '../exhibits/exhibit.dart';
import 'exhibit_node.dart';
import 'floor_transition_node.dart';

Future<String> loadAsset() async {
  return await rootBundle.loadString('assets/config.json');
}

class MainMap extends StatefulWidget {
  final GlobalKey<MainMapState> _mainKey = GlobalKey<MainMapState>();

  void changeFloor(int index) {
    _mainKey.currentState?.changeFloor(index);
  }

  MainMap(
      {super.key,
      required this.popupState,
      required List<ExhibitMapEntry> exhibits}) {
    this.exhibits.value = exhibits;
  }

  static MainMapState? of(BuildContext context) {
    return context.findAncestorStateOfType<MainMapState>();
  }

  static const routeName = '/map';

  ValueNotifier<List<ExhibitMapEntry>> exhibits = ValueNotifier([]);

  void updateExhibits(List<ExhibitMapEntry> newExhibits) {
    exhibits.value = newExhibits;
  }

  final ExhibitPopupState popupState;
  List<FloorMap> sections = [];
  FloorMap? currentFloor;

  @override
  MainMapState createState() => MainMapState();
}

class MainMapState extends State<MainMap> with RestorationMixin {
  @override
  String get restorationId => 'main_map';

  void updateExhibits(List<ExhibitMapEntry> newExhibits) {
    widget.updateExhibits(newExhibits);
  }

  final RestorableInt _mainMapKey = RestorableInt(0);

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_mainMapKey, 'main_map_key');
  }

  GlobalKey<FloorMapState> floorMapKey = GlobalKey<FloorMapState>();

  void transitionFloor(FloorTransitionNode start, FloorTransitionNode end) {
    //TODO: Implement transitionFloor
  }

  void changeFloor(int index) {
    setFloor(index);
  }

  void setFloor(int index) {
    if (index >= 0 && index < widget.sections.length) {
      setState(() {
        currentFloor = widget.sections[index];
        widget.currentFloor = currentFloor;
      });
    }
  }

  late FloorMap currentFloor;

  @override
  Widget build(BuildContext context) {
    widget.sections = [
      FloorMap(
        path: 'assets/images/map_assets/Tech Floor 1.png',
        popup: widget.popupState,
        key: floorMapKey,
      ),
      FloorMap(
        path: 'assets/images/map_assets/Tech Floor 2.png',
        popup: widget.popupState,
        key: floorMapKey,
      ),
      FloorMap(
        path: 'assets/images/map_assets/Tech Lower Level.png',
        popup: widget.popupState,
        key: floorMapKey,
      ),
      FloorMap(
        path: 'assets/images/map_assets/Tech Mezzanine.png',
        popup: widget.popupState,
        key: floorMapKey,
      ),
    ];

    return ValueListenableBuilder<List<ExhibitMapEntry>>(
      valueListenable: widget.exhibits,
      builder: (context, exhibits, child) {
        for (var exhibit in exhibits) {
          widget.sections[exhibit.location.layer].key!.currentState!
              .addExhibitNode(ExhibitNode(
                  floor: widget.sections[exhibit.location.layer],
                  xPos: exhibit.location.x,
                  yPos: exhibit.location.y,
                  description: "description 1"));
        }

        currentFloor = widget.sections[0];
        widget.currentFloor = currentFloor;

        return currentFloor;
      },
    );
  }
}
