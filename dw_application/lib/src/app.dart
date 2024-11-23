import 'dart:convert';

import 'package:dw_application/src/exhibits/exhibit_details_view.dart';
import 'package:dw_application/src/exhibits/exhibit_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

import 'nfc_reader/exhibit_scan_view.dart';
import 'exhibits/exhibit.dart';

/// The Widget that configures your application.
class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  late List<Widget> _widgetOptions;
  final GlobalKey<ExhibitListViewState> _exhibitListViewKey =
      GlobalKey<ExhibitListViewState>();
  List<Exhibit> _exhibits = [];

  @override
  void initState() {
    super.initState();
    readJson();
    _widgetOptions = <Widget>[
      ExhibitListView(key: _exhibitListViewKey, exhibits: _exhibits),
      const ExhibitScanView(),
      SettingsView(controller: widget.settingsController),
    ];
  }

  // Fetch content from the json file
  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/example.json');
    final data = await json.decode(response);

    setState(() {
      _exhibits =
          (data["exhibits"] as List).map((e) => Exhibit.fromJson(e)).toList();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _exhibitListViewKey.currentState?.updateExhibits(_exhibits);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return ListenableBuilder(
      listenable: widget.settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',

          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],

          // Use AppLocalizations to configure the correct application title
          // depending on the user's locale.
          //
          // The appTitle is defined in .arb files found in the localization
          // directory.
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: widget.settingsController.themeMode,

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    return SettingsView(controller: widget.settingsController);
                  case ExhibitDetailsView.routeName:
                    final id = routeSettings.arguments as String;
                    final exhibit = _exhibits.firstWhere((e) => e.id == id);
                    return ExhibitDetailsView(exhibit: exhibit);
                  case ExhibitListView.routeName:
                    return ExhibitListView(
                        key: _exhibitListViewKey, exhibits: _exhibits);
                  case ExhibitScanView.routeName:
                    return const ExhibitScanView();
                  default:
                    return const Scaffold(
                      body: Center(
                        child: Text('Not Found'),
                      ),
                    );
                }
              },
            );
          },
          home: Scaffold(
            body: Center(
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.list),
                  label: 'List',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.nfc),
                  label: 'Scan NFC',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.amber[800],
              onTap: _onItemTapped,
            ),
          ),
        );
      },
    );
  }
}
