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
  MainMap({super.key, required this.popupState, required this.exhibits});

  static MainMapState? of(BuildContext context) {
    return context.findAncestorStateOfType<MainMapState>();
  }

  static const routeName = '/map';

  final ValueNotifier<List<ExhibitMapEntry>> exhibits;
  late List<FloorMap> sections = [
      FloorMap(
          path: 'assets/images/map_assets/Tech Lower Level.png',
          popup: popupState,
          key: GlobalKey<FloorMapState>()),
      FloorMap(
          path: 'assets/images/map_assets/Tech Floor 1.png',
          popup: popupState,
          key: GlobalKey<FloorMapState>()),
      FloorMap(
          path: 'assets/images/map_assets/Tech Floor 2.png',
          popup: popupState,
          key: GlobalKey<FloorMapState>()),
      FloorMap(
          path: 'assets/images/map_assets/Tech Mezzanine.png',
          popup: popupState,
          key: GlobalKey<FloorMapState>()),
    ];
  FloorMap? currentFloor;
  ExhibitPopupState popupState;

  @override
  MainMapState createState() => MainMapState();
}

class MainMapState extends State<MainMap> with RestorationMixin {
  @override
  String get restorationId => 'main_map';

  int currentFloorIndex = 1;

  final RestorableInt _mainMapKey = RestorableInt(0);
  final GlobalKey<FloorMapState> floorMapKey = GlobalKey<FloorMapState>();

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_mainMapKey, 'main_map_key');
  }

  @override
  void initState() {
    super.initState();
    widget.sections = [
      FloorMap(
          path: 'assets/images/map_assets/Tech Lower Level.png',
          popup: widget.popupState,
          key: GlobalKey<FloorMapState>()),
      FloorMap(
          path: 'assets/images/map_assets/Tech Floor 1.png',
          popup: widget.popupState,
          key: GlobalKey<FloorMapState>()),
      FloorMap(
          path: 'assets/images/map_assets/Tech Floor 2.png',
          popup: widget.popupState,
          key: GlobalKey<FloorMapState>()),
      FloorMap(
          path: 'assets/images/map_assets/Tech Mezzanine.png',
          popup: widget.popupState,
          key: GlobalKey<FloorMapState>()),
    ];
    widget.currentFloor = widget.sections[currentFloorIndex];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateExhibitNodes();
    });
  }

  void updateExhibitNodes() {
    if (!mounted) return;
    for (var section in widget.sections) {
      section.key.currentState?.clearNodes();
    }
    for (var exhibit in widget.exhibits.value) {
      if (exhibit.location.layer >= 0 && exhibit.location.layer < widget.sections.length) {
        var sectionState = widget.sections[exhibit.location.layer].key.currentState;
        if (sectionState != null) {
          sectionState.addExhibitNode(ExhibitNode(
              floor: widget.sections[exhibit.location.layer],
              xPos: exhibit.location.x,
              yPos: exhibit.location.y,
              description: exhibit.description,
              id: exhibit.id));
        }
      }
    }
  }

  void transitionFloor(FloorTransitionNode start, FloorTransitionNode end) {
    //TODO: Implement transitionFloor
  }

  void changeFloor(int index) {
    if (index >= 0 && index < widget.sections.length) {
      setFloor(index);
      Future.delayed(Duration(milliseconds: 100), () {
        updateExhibitNodes();
      });
    }
  }
    

  void setFloor(int index) {
    if (index >= 0 && index < widget.sections.length) {
      setState(() {
        widget.currentFloor = widget.sections[index];
        currentFloorIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: DropdownButton<int>(
          value: currentFloorIndex,
          onChanged: (int? newIndex) {
            if (newIndex != null) {
              changeFloor(newIndex);
            }
          },
          items: const [
            DropdownMenuItem(
              value: 0,
              child: Text('Tech Lower Level'),
            ),
            DropdownMenuItem(
              value: 1,
              child: Text('Tech Level 1'),
            ),
            DropdownMenuItem(
              value: 2,
              child: Text('Tech Level 2'),
            ),
            DropdownMenuItem(
              value: 3,
              child: Text('Tech Mezzanine'),
            ),
          ],
        ),
      ),
      body: ValueListenableBuilder<List<ExhibitMapEntry>>(
          valueListenable: widget.exhibits,
          builder: (context, exhibits, child) {
            if (currentFloorIndex >= widget.sections.length) {
              return const Center(child: Text('Floor not available'));
            }
            updateExhibitNodes();
            return widget.sections[currentFloorIndex];
          }),
    );
  }
}
