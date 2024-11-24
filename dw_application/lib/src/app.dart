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

import 'map_page.dart';

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

  List<Exhibit> _exhibits = [];

  @override
  void initState() {
    super.initState();
    readJson();
    _widgetOptions = <Widget>[
      MapView(),
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
            theme: appTheme,
            darkTheme: ThemeData.dark(),
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
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width * 0.25,
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
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
