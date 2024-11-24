import 'dart:collection';

import 'package:dw_application/src/mapping/main_map.dart';
import 'package:dw_application/src/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../mapping/floor_map.dart';
import '../mapping/map_node.dart';
import '../exhibits/exhibit.dart';

class ExhibitPopup extends StatefulWidget {
  ExhibitPopup({
    Key? key,
    required this.exhibits,
    required this.exhibitMapEntries,
    required this.settingsController,
    this.initialText =
        "Click an exhibit to view information", // Initial text value
  }) : super(key: key);

  final ValueNotifier<List<Exhibit>> exhibits;
  final ValueNotifier<List<ExhibitMapEntry>> exhibitMapEntries;

  final String initialText;

  final SettingsController settingsController;

  @override
  ExhibitPopupState createState() => ExhibitPopupState();
}

class ExhibitPopupState extends State<ExhibitPopup> {
  GlobalKey<MainMapState> mainMapKey = GlobalKey<MainMapState>();
  late String displayText;
  PanelController panelController = PanelController();
  int exhibitIndex = -1;
  String exhibit_id = "";
  String searchQuery = "";
  late List<Exhibit> filteredExhibits = [];
  bool searchFocused = false;
  String currentFloorLabel = 'Tech Lower level';

  @override
  ExhibitPopupState createState() => ExhibitPopupState();

  @override
  void initState() {
    super.initState();
    displayText = widget.initialText;
    filteredExhibits = [];
  }

  void updateText(String id, int index) {
    panelController.open();
    setState(() {
      displayText = widget.exhibits.value[index].getDescription();
      // displayText = newText;
    });
    panelController.open();
    setState(() {
      displayText = widget.exhibits.value[index].getDescription();;
      // exhibitIndex = index;
    });
  }

  void updateSearchQuery(String query) {
    // setState(() {
    //   searchQuery = query;
    //   if (query.isEmpty && !searchFocused) {
    //     filteredExhibits = [];
    //   } else {
    //     filteredExhibits = widget.exhibits.value
    //         .where((exhibit) =>
    //             exhibit.getTitle().toLowerCase().contains(query.toLowerCase()))
    //         .toList();
    //   }
    // });
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        filteredExhibits = List<Exhibit>.from(widget.exhibits.value);
      } else {
        filteredExhibits = widget.exhibits.value
            .where((exhibit) =>
          exhibit.getTitle().toLowerCase().contains(query.toLowerCase()) ||
          exhibit.getDescription(
            language: widget.settingsController.language, difficultyLevel: widget.settingsController.difficulty.toString()
          ).toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  late MainMap mainMap;

  void zoom(String id) {
    FloorMapState? floorState = mainMap.currentFloor?.key.currentState;
    if (floorState == null ||
        floorState.activeIconIndex == null ||
        floorState.activeIconIndex! < 0 ||
        floorState.activeIconIndex! >= floorState.mapNodes.length) {
      return;
    }
    int index = floorState.mapNodes.indexWhere((element) {
      if (element is ExhibitNode) {
        return element.id == id;
      }
      return false;
    });
    Queue<MapNode>? transitions = floorState.getTransitions(
        floorState.mapNodes[floorState.activeIconIndex!],
        floorState.mapNodes[index]);
    if (transitions.isEmpty) {
      floorState.pan(floorState.mapNodes[floorState.activeIconIndex!],
          floorState.mapNodes[index]);
    } else {
      for (var node in transitions) {
        if (node is FloorTransitionNode) {
          floorState.pan(
              floorState.mapNodes[floorState.activeIconIndex!], node);
        } else {
          mainMapKey.currentState!.transitionFloor(
              floorState.mapNodes[floorState.activeIconIndex!]
                  as FloorTransitionNode,
              node as FloorTransitionNode);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    mainMap = MainMap(
        popupState: this, key: mainMapKey, exhibits: widget.exhibitMapEntries);
    return Scaffold(
      body: SlidingUpPanel(
        controller: panelController,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: isDarkMode ? (Colors.grey[800] ?? Colors.grey) : Colors.white,
        maxHeight: 400,
        panel: _buildPanel(context),
        body: Center(
          heightFactor: MediaQuery.of(context).size.height * 0.9,
          child: mainMap,
        ),
      ),
    );
  }

  Widget _buildPanel(BuildContext context) {
    TextEditingController descriptionController =
        TextEditingController(text: displayText);
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // TextEditingController descriptionController = TextEditingController(text: displayText);
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FocusScope(
            child: Focus(
              onFocusChange: (focus) {
                setState(() {
                  searchFocused = focus;
                  if (focus) {
                    filteredExhibits = widget.exhibits.value.toList();
                  } else if (searchQuery.isEmpty) {
                    filteredExhibits = [];
                  }
                });
              },
              child: TextField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search...',
                ),
                onChanged: updateSearchQuery,
              ),
            ),
          ),
        ),
        filteredExhibits.isEmpty
            ? SizedBox.shrink()
            : Expanded(
                child: ListView.builder(
                  itemCount: filteredExhibits.length,
                  itemBuilder: (context, index) {
                    return _buildExhibitCard(context,
                        exhibit: filteredExhibits[index]);
                  },
                ),
              ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: descriptionController,
            readOnly: true,
            decoration: const InputDecoration(
              border: InputBorder.none,
              labelText: 'Selected Exhibit Translation',
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExhibitCard(BuildContext context, {Exhibit? exhibit}) {
    exhibit ??= Exhibit.blank();
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // check if link if works else icon if not
            Image.network(
                  exhibit.image,
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
                    exhibit.getTitle(),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  // const SizedBox(height: 8),
                  // Text(
                  //   exhibit.getDescription(),
                  //   style: Theme.of(context).textTheme.bodyMedium,
                  // ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () {
                      zoom(exhibit!.id);
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
    );
  }
}
