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
        // SettingsList(sections: [
        //     SettingsSection(title: const Text('Settings'), tiles: [
        //       SettingsTile.switchTile(
        //         title: const Text('Dark Mode'),
        //         leading: const Icon(Icons.dark_mode),
        //         onToggle: (bool value) {
        //           if (value) {
        //             controller.updateThemeMode(ThemeMode.dark);
        //           } else {
        //             controller.updateThemeMode(ThemeMode.light);
        //           }
        //         },
        //         initialValue: controller.themeMode == ThemeMode.dark,
        //       ),
        //       SettingsTile(
        //           title: const Text("About"),
        //           leading: const Icon(Icons.info),
        //           onPressed: (context) {
        //             showDialog(
        //               context: context,
        //               builder: (BuildContext context) {
        //                 return AlertDialog(
        //                   title: const Text("About This App"),
        //                   content: const Text(
        //                     "This app is used for assisting the Discovery World attendants with understanding the exhibits. \n"
        //                     "Select 'Help' for instructions on how to use this app.",
        //                     style: TextStyle(fontSize: 16),
        //                   ),
        //                   actions: [
        //                     TextButton(
        //                       onPressed: () {
        //                         Navigator.of(context).pop();
        //                       },
        //                       child: const Text("OK"),
        //                     ),
        //                   ],
        //                 );
        //               },
        //             );
        //           }),
        //       SettingsTile(
        //           title: const Text("Help"),
        //           leading: const Icon(Icons.help),
        //           onPressed: (context) {
        //             showDialog(
        //               context: context,
        //               builder: (BuildContext context) {
        //                 return AlertDialog(
        //                   title: const Text("Help"),
        //                   content: const Text(
        //                     "To scan an NFC tag, press Scan NFC and hold your phone next to the tag. \n"
        //                     "This will have info on the exhibit.",
        //                     style: TextStyle(fontSize: 16),
        //                   ),
        //                   actions: [
        //                     TextButton(
        //                       onPressed: () {
        //                         Navigator.of(context).pop();
        //                       },
        //                       child: const Text("OK"),
        //                     ),
        //                   ],
        //                 );
        //               },
        //             );
        //           }),
        //       SettingsTile(
        //           title: const Text('Difficulty'),
        //           leading: const Icon(Icons.description),
        //           trailing: Slider(
        //               min: 1,
        //               max: 3,
        //               divisions: 2,
        //               value: controller.difficulty.toDouble(),
        //               onChanged: (newValue) {
        //                 controller.updateDifficulty(newValue.toInt());
        //               })),
        //       SettingsTile(
        //           title: const Text('Language'),
        //           leading: const Icon(Icons.language),
        //           trailing: DropdownButton<String>(
        //             value: controller.language,
        //             onChanged: (newValue) {
        //               controller.updateLanguage(newValue!);
        //             },
        //             items: controller
        //                 .getLanguages()
        //                 .map<DropdownMenuItem<String>>((String value) {
        //               return DropdownMenuItem<String>(
        //                 value: value,
        //                 child: Text(value),
        //               );
        //             }).toList(),
        //           )),
        //     ]),
        //   ]),
        Image.asset(
          'assets/images/website_bb.png',
          fit: BoxFit.cover,
        ),
      ]),
    );
  }
}
