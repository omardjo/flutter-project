import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettings extends ChangeNotifier {
  late SharedPreferences _prefs;

  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _locationServices = false;

  bool get pushNotifications => _pushNotifications;
  bool get emailNotifications => _emailNotifications;
  bool get locationServices => _locationServices;

  NotificationSettings() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _prefs = await SharedPreferences.getInstance();
    _pushNotifications = _prefs.getBool('pushNotifications') ?? true;
    _emailNotifications = _prefs.getBool('emailNotifications') ?? false;
    _locationServices = _prefs.getBool('locationServices') ?? false;
    notifyListeners();
  }

  Future<void> _saveSettings() async {
    await _prefs.setBool('pushNotifications', _pushNotifications);
    await _prefs.setBool('emailNotifications', _emailNotifications);
    await _prefs.setBool('locationServices', _locationServices);
  }

  void setPushNotifications(bool value) {
    _pushNotifications = value;
    _saveSettings();
    notifyListeners();
  }

  void setEmailNotifications(bool value) {
    _emailNotifications = value;
    _saveSettings();
    notifyListeners();
  }

  void setLocationServices(bool value) {
    _locationServices = value;
    _saveSettings();
    notifyListeners();
  }
}
