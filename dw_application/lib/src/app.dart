import 'package:dw_application/src/exhibit_popup/exhibit_popup.dart';
import 'package:dw_application/src/mapping/main_map.dart';
import 'package:flutter/material.dart';
import 'appTheme.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'exhibits/exhibit.dart';
import 'package:dw_application/src/exhibits/exhibit_details_view.dart';
import 'package:dw_application/src/exhibits/exhibit_list_view.dart';
import 'nfc_reader/exhibit_scan_view.dart';
import 'dart:convert';

class DiscoveryApp extends StatefulWidget {
  const DiscoveryApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  DiscoveryAppState createState() => DiscoveryAppState();
}

class DiscoveryAppState extends State<DiscoveryApp> {
  late List<Widget> _widgetOptions;

  final GlobalKey<ExhibitListViewState> _exhibitListViewKey =
      GlobalKey<ExhibitListViewState>();
  final GlobalKey<MainMapState> _mainMapKey = GlobalKey<MainMapState>();

  final ValueNotifier<List<ExhibitMapEntry>> _exhibitMapDetailsNotifier =
      ValueNotifier([]);
  final ValueNotifier<List<Exhibit>> _exhibitsNotifier = ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    readJson();
    _widgetOptions = <Widget>[
      ExhibitPopup(
          exhibits: _exhibitsNotifier,
          exhibitMapEntries: _exhibitMapDetailsNotifier,
          settingsController: widget.settingsController,
          key: _mainMapKey),
      ExhibitListView(key: _exhibitListViewKey, exhibits: _exhibitsNotifier),
      const ExhibitScanView(),
      SettingsView(controller: widget.settingsController),
    ];
  }

  // Fetch content from the json file
  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/exhibits/exhibits.json');
    final data = await json.decode(response);
    _exhibitsNotifier.value =
        (data["exhibits"] as List).map((e) => Exhibit.fromJson(e)).toList();
    _exhibitMapDetailsNotifier.value = (data["mapPoints"] as List)
        .map((e) => ExhibitMapEntry.fromJson(e))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
            restorationScopeId: 'app',
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''),
              Locale('es', ''),
              Locale('hmn', ''),
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale?.languageCode &&
                    supportedLocale.countryCode == locale?.countryCode) {
                  return supportedLocale;
                }
              }
              return supportedLocales.first;
            },
            onGenerateTitle: (BuildContext context) =>
                AppLocalizations.of(context)!.appTitle,
            theme: appThemeLight,
            darkTheme: appThemeDark,
            themeMode: widget.settingsController.themeMode,
            onGenerateRoute: (RouteSettings routeSettings) {
              return MaterialPageRoute<void>(
                settings: routeSettings,
                builder: (BuildContext context) {
                  switch (routeSettings.name) {
                    case SettingsView.routeName:
                      return SettingsView(
                          controller: widget.settingsController);
                    case ExhibitDetailsView.routeName:
                      final id = routeSettings.arguments as String;
                      final exhibit =
                          _exhibitsNotifier.value.firstWhere((e) => e.id == id);
                      return ExhibitDetailsView(exhibit: exhibit, settingsController: widget.settingsController);
                    case ExhibitListView.routeName:
                      return ExhibitListView(
                          key: _exhibitListViewKey,
                          exhibits: _exhibitsNotifier);
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
            home: HomeNavigation(widgetOptions: _widgetOptions));
      },
    );
  }
}

class HomeNavigation extends StatefulWidget {
  const HomeNavigation({Key? key, required List<Widget> widgetOptions})
      : _widgetOptions = widgetOptions,
        super(key: key);

  final List<Widget> _widgetOptions;
  HomeNavigationState createState() => HomeNavigationState();
}

class HomeNavigationState extends State<HomeNavigation> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/Discovery-World.png',
          width: MediaQuery.of(context).size.width * 0.25,
          height: MediaQuery.of(context).size.height * 0.1,
          fit: BoxFit.contain,
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: widget._widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            // map
            icon: const Icon(Icons.map),
            label: AppLocalizations.of(context)!.map,
          ),
          BottomNavigationBarItem(
            // exhibits
            icon: const Icon(Icons.list),
            label: AppLocalizations.of(context)!.exhibits,
          ),
          BottomNavigationBarItem(
            // scan to see
            icon: const Icon(Icons.tap_and_play),
            label: AppLocalizations.of(context)!.scanNfc,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: AppLocalizations.of(context)!.settingsTitle,
          )
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Theme.of(context).disabledColor,
        selectedItemColor: const Color.fromARGB(255, 231, 64, 120),
        onTap: _onItemTapped,
      ),
    );
  }
}
