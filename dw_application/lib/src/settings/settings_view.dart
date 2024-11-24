import 'package:dw_application/src/appTheme.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'settings_controller.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatefulWidget {
  const SettingsView({super.key, required this.controller});

  static const routeName = '/settings';

  final SettingsController controller;

  @override
  SettingsViewState createState() => SettingsViewState();
}

class SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: buildSettingsList(),
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
      // ),
      // Image.asset(
      //   'assets/images/website_bb.png',
      //   fit: BoxFit.cover,
      // ),
    );
  }

  SettingsList buildSettingsList() {
    return SettingsList(
      sections: [
        SettingsSection(
          title: Text('General'),
          tiles: [
            SettingsTile(
              title: Text('Website Theme'),
              leading: Icon(Icons.dark_mode),
              trailing: DropdownButton<ThemeMode>(
                value: widget.controller.themeMode,
                onChanged: (newValue) {
                  setState(() {
                    widget.controller.updateThemeMode(newValue);
                  });
                },
                items: [ThemeMode.system, ThemeMode.dark, ThemeMode.light]
                    .map<DropdownMenuItem<ThemeMode>>((ThemeMode value) {
                  return DropdownMenuItem<ThemeMode>(
                    value: value,
                    child: Text(value.name),
                  );
                }).toList(),
              ),
            ),
            SettingsTile(
                title: const Text("About"),
                leading: const Icon(Icons.info),
                onPressed: (context) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("About This App"),
                        content: const Text(
                          "This app is used for assisting the Discovery World attendants with understanding the exhibits. \n"
                          "Select 'Help' for instructions on how to use this app.",
                          style: TextStyle(fontSize: 16),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("OK"),
                          ),
                        ],
                      );
                    },
                  );
                }),
            SettingsTile(
                title: const Text("Help"),
                leading: const Icon(Icons.help),
                onPressed: (context) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Help"),
                        content: const Text(
                          "To scan an NFC tag, press Scan NFC and hold your phone next to the tag. \n"
                          "This will have info on the exhibit.",
                          style: TextStyle(fontSize: 16),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("OK"),
                          ),
                        ],
                      );
                    },
                  );
                }),
            SettingsTile(
                title: Text('Difficulty'),
                leading: Icon(Icons.description),
                trailing: Slider(
                    min: 1,
                    max: 3,
                    divisions: 2,
                    value: widget.controller.difficulty.toDouble(),
                    onChanged: (newValue) {
                      setState(() {
                        widget.controller.updateDifficulty(newValue.toInt());
                      });
                    }
                    )
                    ),
            SettingsTile(
                title: Text('Language'),
                leading: Icon(Icons.language),
                trailing: DropdownButton<String>(
                  value: widget.controller.language,
                  onChanged: (newValue) {
                    setState(() {
                      widget.controller.updateLanguage(newValue!);
                    });
                    },
                  items: widget.controller.getLanguages().map(
                    ( key,  value ) {
                      return MapEntry(
                        key,  
                        DropdownMenuItem(
                        value: key,
                        child: Text(value)
                        )
                      );                      
                    }
                  ).values.toList(),
                  
                )
                ),
          ],
        ),
        CustomSettingsSection(
          child: Image.asset(
            'assets/images/website_bb.png',
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}
