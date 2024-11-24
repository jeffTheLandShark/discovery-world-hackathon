import 'package:dw_application/src/settings/settings_controller.dart';
import 'package:flutter/material.dart';

import 'exhibit.dart';

class ExhibitDetailsView extends StatelessWidget {
  const ExhibitDetailsView({super.key, this.exhibit, required this.settingsController});
  final Exhibit? exhibit;
  final SettingsController settingsController;
  static const routeName = '/exhibitDetails';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(exhibit?.getTitle() ?? ''),
      ),
      body: Center(
        child: Text(exhibit?.getDescription(language: settingsController.language, difficultyLevel: settingsController.difficulty.toString()) ?? ''),
      ),
    );
  }
}
