import 'package:dw_application/src/exhibits/exhibit_details_view.dart';
import 'package:flutter/material.dart';

import 'exhibit.dart';

class ExhibitItemListView extends StatelessWidget {
  const ExhibitItemListView({super.key, required this.exhibits});

  static const routeName = '/exhibits';
  final List<Exhibit> exhibits;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // To work with lists that may contain a large number of items, it’s best
      // to use the ListView.builder constructor.
      //
      // In contrast to the default ListView constructor, which requires
      // building all Widgets up front, the ListView.builder constructor lazily
      // builds Widgets as they’re scrolled into view.
      body: ListView.builder(
        // Providing a restorationId allows the ListView to restore the
        // scroll position when a user leaves and returns to the app after it
        // has been killed while running in the background.
        restorationId: 'exhibitListView',
        itemCount: exhibits.length,
        itemBuilder: (BuildContext context, int index) {
          final item = exhibits[index];

          return ListTile(
              title: Text(item.getTitle()),
              leading: CircleAvatar(
                // Display the Flutter Logo image asset.
                foregroundImage: AssetImage(item.image),
              ),
              onTap: () {
                // Navigate to the details page. If the user leaves and returns to
                // the app after it has been killed while running in the
                // background, the navigation stack is restored.
                Navigator.pushNamed(
                  context,
                  ExhibitDetailsView.routeName,
                  arguments: item.id,
                );
              });
        },
      ),
    );
  }
}
