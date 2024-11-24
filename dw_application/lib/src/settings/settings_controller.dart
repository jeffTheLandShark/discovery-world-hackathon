import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'settings_service.dart';

/// A class that many Widgets can interact with to read user settings, update
/// user settings, or listen to user settings changes.
///
/// Controllers glue Data Services to Flutter Widgets. The SettingsController
/// uses the SettingsService to store and retrieve user settings.
class SettingsController with ChangeNotifier {
  SettingsController(this._settingsService);

  // Make SettingsService a private variable so it is not used directly.
  final SettingsService _settingsService;

  // Make ThemeMode a private variable so it is not updated directly without
  // also persisting the changes with the SettingsService.
  late ThemeMode _themeMode;
  late SharedPreferences _preferences;

  // Allow Widgets to read the user's preferred ThemeMode.
  ThemeMode get themeMode => _themeMode;

  int? getDifficulty() {
    return _preferences.getInt("Difficulty");
  }

  Future<void> setDifficulty(int difficulty) {
    return _preferences.setInt("Difficulty", difficulty);
  }

  String? getLanguage() {
    return _preferences.getString("Language");
  }

  Future<void> setLanguage(String language) {
    return _preferences.setString("Language", language);
  }

  /// Load the user's settings from the SettingsService. It may load from a
  /// local database or the internet. The controller only knows it can load the
  /// settings from the service.
  Future<void> loadSettings() async {
    _themeMode = await _settingsService.themeMode();
    _preferences = await SharedPreferences.getInstance();
    for (String key in SettingsService.keys) {
      if (!_preferences.containsKey(key)) {
        initPreferences();
        break;
      }
    }
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  void initPreferences() {
    setDifficulty(1);
    setLanguage("English");
  }

  /// Update and persist the ThemeMode based on the user's selection.
  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;

    // Do not perform any work if new and old ThemeMode are identical
    if (newThemeMode == _themeMode) return;

    // Otherwise, store the new ThemeMode in memory
    _themeMode = newThemeMode;

    // Important! Inform listeners a change has occurred.
    notifyListeners();

    // Persist the changes to a local database or the internet using the
    // SettingService.
    await _settingsService.updateThemeMode(newThemeMode);
  }
}
