import 'package:dw_application/src/mapping/map_node.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'floor_map.dart';
import '../exhibit_popup/exhibit_popup.dart';
import '../exhibits/exhibit.dart';

Future<String> loadAsset() async {
  return await rootBundle.loadString('assets/config.json');
}

class MainMap extends StatefulWidget {
  MainMap(
      {super.key,
      required ExhibitPopupState popupState,
      required this.exhibits});

  static MainMapState? of(BuildContext context) {
    return context.findAncestorStateOfType<MainMapState>();
  }

  static const routeName = '/map';

  final ValueNotifier<List<ExhibitMapEntry>> exhibits;
  List<FloorMap> sections = [];
  FloorMap? currentFloor;
  ExhibitPopupState popupState;

  @override
  MainMapState createState() => MainMapState();
}

class MainMapState extends State<MainMap> with RestorationMixin {
  @override
  String get restorationId => 'main_map';

  int currentFloorIndex = 0;

  final RestorableInt _mainMapKey = RestorableInt(0);
  final GlobalKey<FloorMapState> floorMapKey = GlobalKey<FloorMapState>();

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_mainMapKey, 'main_map_key');
  }

  void updateExhibits(List<ExhibitMapEntry> newExhibits) {
    widget.exhibits.value = newExhibits;
  }

  void transitionFloor(FloorTransitionNode start, FloorTransitionNode end) {
    //TODO: Implement transitionFloor
  }

  void changeFloor(int index) {
    setFloor(index);
  }

  void setFloor(int index) {
    if (index >= 0 && index < widget.sections.length) {
      setState(() {
        widget.currentFloor = widget.sections[index];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.sections = [
      FloorMap(
          path: 'assets/images/map_assets/Tech Floor 1.png',
          popup: widget.popupState,
          key: floorMapKey),
      FloorMap(
          path: 'assets/images/map_assets/Tech Floor 2.png',
          popup: widget.popupState,
          key: floorMapKey),
      FloorMap(
          path: 'assets/images/map_assets/Tech Lower Level.png',
          popup: widget.popupState,
          key: floorMapKey),
      FloorMap(
          path: 'assets/images/map_assets/Tech Mezzanine.png',
          popup: widget.popupState,
          key: floorMapKey),
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
                  description: "description 1",
                  id: exhibit.id));
        }

        widget.currentFloor = widget.sections[0];

        return widget.currentFloor!;
      },
    );
  }
}
