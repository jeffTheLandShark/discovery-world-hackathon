import 'package:dw_application/src/exhibits/exhibit_details_view.dart';
import 'package:flutter/material.dart';

import 'exhibit.dart';

class ExhibitListView extends StatefulWidget {
  const ExhibitListView({super.key, required this.exhibits});

  static ExhibitListViewState? of(BuildContext context) {
    return context.findAncestorStateOfType<ExhibitListViewState>();
  }

  static const routeName = '/exhibits';
  final List<Exhibit> exhibits;

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
  
  late ValueNotifier<List<Exhibit>> _exhibits;

  @override
  void initState() {
    super.initState();
    _exhibits = ValueNotifier(widget.exhibits);
  }

  void updateExhibits(List<Exhibit> newExhibits) {
    _exhibits.value = newExhibits;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<List<Exhibit>>(
        valueListenable: _exhibits,
        builder: (context, exhibits, _) {
          return ListView.builder(
            restorationId: 'exhibitListView',
            itemCount: exhibits.length,
            itemBuilder: (BuildContext context, int index) {
              final item = exhibits[index];

              return ListTile(
                key: Key(item.id),
                title: Text(item.getTitle()),
                subtitle: Text(item.getDescription()),
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
