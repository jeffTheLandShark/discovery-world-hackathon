import 'package:dw_application/src/exhibit_popup/exhibit_popup.dart';
import 'package:dw_application/src/mapping/main_map.dart';
import 'package:flutter/material.dart';
import 'package:dw_application/src/exhibits/exhibit.dart';

class MapView extends StatelessWidget {
  // pass thorough exhibits list and exhibit map entries
  MapView(
      {Key? key,
      required this.exhibits,
      required this.exhibitMapEntries,
      required this.passedKey})
      : super(key: key);
  List<Exhibit> exhibits;
  List<ExhibitMapEntry> exhibitMapEntries;
  final GlobalKey<MainMapState> passedKey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // put interactive map here
        // get device height
        height: MediaQuery.of(context).size.height * 0.9,
        child: ExhibitPopup(
          mainKey: passedKey,
          exhibits: exhibits,
          exhibitMapEntries: exhibitMapEntries,
        ),
      ),
    );
  }
}
