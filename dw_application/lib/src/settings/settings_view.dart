import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'settings_controller.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.controller});

  static const routeName = '/settings';

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        // Glue the SettingsController to the theme selection DropdownButton.
        //
        // When a user selects a theme from the dropdown list, the
        // SettingsController is updated, which rebuilds the MaterialApp.
        child:  
          SettingsList(sections: [
            SettingsSection(
            title: Text('Settings'),
            tiles: [
              SettingsTile.switchTile(
              title: Text('Dark Mode'),
              leading: Icon(Icons.dark_mode),
              onToggle: (bool value) {
                if (value) {
                  controller.updateThemeMode(ThemeMode.dark);
                } else {
                  controller.updateThemeMode(ThemeMode.light);
                }
                },
              initialValue: controller.themeMode == ThemeMode.dark,
              ),
              SettingsTile(
                title: Text('Difficulty'),
                leading: Icon(Icons.description),
                trailing: Slider(
                  min: 1,
                  max: 3,
                  divisions: 2,
                  value: controller.difficulty.toDouble(),
                  onChanged: (newValue) {
                    controller.updateDifficulty(newValue.toInt());
                    }
                )
              ),
              SettingsTile(
                title: Text('Language'),
                leading: Icon(Icons.language),
                trailing: DropdownButton<String>(
            value: controller.language,
            onChanged: (newValue) {controller.updateLanguage(newValue!);},
            items: controller.getLanguages()
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
              )
              ),
            ]
            )
          ])
      //     DropdownButton<ThemeMode>(
      //     // Read the selected themeMode from the controller
      //     value: controller.themeMode,
      //     // Call the updateThemeMode method any time the user selects a theme.
      //     onChanged: controller.updateThemeMode,
      //     items: const [
      //       DropdownMenuItem(
      //         value: ThemeMode.system,
      //         child: Text('System Theme'),
      //       ),
      //       DropdownMenuItem(
      //         value: ThemeMode.light,
      //         child: Text('Light Theme'),
      //       ),
      //       DropdownMenuItem(
      //         value: ThemeMode.dark,
      //         child: Text('Dark Theme'),
      //       )
      //     ],
      //   ),
      ),
    );
  }
}
