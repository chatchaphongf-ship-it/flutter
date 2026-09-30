import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  double _fontSizeScale = 1.0; // 1.0 = ปกติ (Small), 1.3 = ใหญ่ (Large)
  bool _isDarkMode = false;

  // Getters
  double get fontSizeScale => _fontSizeScale;
  bool get isDarkMode => _isDarkMode;

  // โหลดค่าตั้งค่าที่เคยบันทึกไว้ในเครื่อง
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _fontSizeScale = prefs.getDouble('fontSizeScale') ?? 1.0;
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }

  // เปลี่ยนขนาดตัวหนังสือ
  Future<void> setFontSizeScale(double scale) async {
    _fontSizeScale = scale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSizeScale', scale);
  }

  // เปลี่ยนโหมดมืด/สว่าง
  Future<void> toggleDarkMode(bool value) async {
    _isDarkMode = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
  }
}