import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
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
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.all(16),
          // Glue the SettingsController to the theme selection DropdownButton.
          //
          // When a user selects a theme from the dropdown list, the
          // SettingsController is updated, which rebuilds the MaterialApp.
          child: 
            SettingsList(
              sections: [
                SettingsSection(
                  // title: Text('General'),
                  tiles: [
                    SettingsTile(
                      title: Text('Website Theme'),
                      leading: Icon(Icons.dark_mode),
                      trailing: DropdownButton<ThemeMode>(
                        value: controller.themeMode,
                        onChanged: (newValue) {controller.updateThemeMode(newValue!);},
                        items: <ThemeMode>[ThemeMode.system, ThemeMode.dark, ThemeMode.light]
                            .map<DropdownMenuItem<ThemeMode>>((ThemeMode value) {
                          return DropdownMenuItem<ThemeMode>(
                            value: value,
                            child: Text(value.name),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ],
            )
          // DropdownButton<ThemeMode>(
          //   // Read the selected themeMode from the controller
          //   value: controller.themeMode,
          //   // Call the updateThemeMode method any time the user selects a theme.
          //   onChanged: controller.updateThemeMode,
          //   items: const [
          //     DropdownMenuItem(
          //       value: ThemeMode.system,
          //       child: Text('System Theme'),
          //     ),
          //     DropdownMenuItem(
          //       value: ThemeMode.light,
          //       child: Text('Light Theme'),
          //     ),
          //     DropdownMenuItem(
          //       value: ThemeMode.dark,
          //       child: Text('Dark Theme'),
          //     )
          //   ],
          // ),
        ),
        Image.asset(
          'assets/images/website_bb.png',
          fit: BoxFit.cover,
        ),
      ]),
    );
  }
}
