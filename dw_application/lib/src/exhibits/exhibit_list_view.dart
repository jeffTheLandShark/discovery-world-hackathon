import 'package:dw_application/src/exhibits/exhibit_details_view.dart';
import 'package:flutter/material.dart';

import 'exhibit.dart';

class ExhibitListView extends StatefulWidget {
  const ExhibitListView({super.key, required this.exhibits});

  static ExhibitListViewState? of(BuildContext context) {
    return context.findAncestorStateOfType<ExhibitListViewState>();
  }

  static const routeName = '/exhibits';
  final ValueNotifier<List<Exhibit>> exhibits;

  void updateExhibits(List<Exhibit> newExhibits) {
    exhibits.value = newExhibits;
  }

  @override
  ExhibitListViewState createState() => ExhibitListViewState();
}

class ExhibitListViewState extends State<ExhibitListView>
    with RestorationMixin {
  @override
  String get restorationId => 'exhibit_list_view';

  final RestorableInt _exhibitListViewKey = RestorableInt(0);

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_exhibitListViewKey, 'exhibit_list_view_key');
  }

  late ValueNotifier<List<Exhibit>> _filteredExhibits;

  @override
  void initState() {
    super.initState();
    _filteredExhibits = ValueNotifier(widget.exhibits.value);
  }

  updateExhibits(List<Exhibit> newExhibits) {
    widget.updateExhibits(newExhibits);
    updateFilteredExhibits(newExhibits);
  }

  void updateFilteredExhibits(List<Exhibit> newExhibits) {
    _filteredExhibits.value = newExhibits;
  }

  void searchExhibits(String query) {
    if (query.isEmpty) {
      updateFilteredExhibits(widget.exhibits.value);
    } else {
      final List<Exhibit> filteredExhibits = widget.exhibits.value
          .where((exhibit) => (exhibit.hasContent(query, language: 'en')))
          .toList();
      updateFilteredExhibits(filteredExhibits);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: SearchBar(
        hintText: 'Search exhibits...',
        onChanged: (query) {
          searchExhibits(query);
        },
      )),
      body: ValueListenableBuilder<List<Exhibit>>(
        valueListenable: _filteredExhibits,
        builder: (context, exhibits, _) {
          return ListView.builder(
            restorationId: 'exhibitListView',
            itemCount: exhibits.length,
            itemBuilder: (BuildContext context, int index) {
              final item = exhibits[index];

              return ListTile(
                key: Key(item.id),
                title: Text(item.getTitle()),
                leading: CircleAvatar(
                  foregroundImage: AssetImage(item.image),
                ),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    ExhibitDetailsView.routeName,
                    arguments: item.id,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
