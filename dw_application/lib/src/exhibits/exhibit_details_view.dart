import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

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
      body: Column(
        children: [
          Image.network(exhibit?.image ?? ''),
          Expanded(child: Markdown(data: exhibit?.getDescription() ?? ''))
        ],
      ),
    );
  }
}
