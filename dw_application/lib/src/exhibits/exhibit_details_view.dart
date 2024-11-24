import 'package:flutter/material.dart';

import 'exhibit.dart';

class ExhibitDetailsView extends StatelessWidget {
  const ExhibitDetailsView({super.key, this.exhibit});
  final Exhibit? exhibit;
  static const routeName = '/exhibitDetails';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(exhibit?.getTitle() ?? ''),
      ),
      body: Center(
        child: Text(exhibit?.getDescription() ?? ''),
      ),
    );
  }
}
