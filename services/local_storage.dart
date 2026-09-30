import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';
import '../models/clothing_item.dart';

class LocalStorageService {
  static const String _profileKey = 'user_profile';
  static const String _wardrobeKey = 'wardrobe_items';

  // บันทึกข้อมูลโปรไฟล์
  static Future<void> saveProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileKey, jsonEncode(profile.toJson()));
  }

  // โหลดข้อมูลโปรไฟล์
  static Future<UserProfile?> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_profileKey);
    if (data == null) return null;
    return UserProfile.fromJson(jsonDecode(data));
  }

  // บันทึกรายการเสื้อผ้า
  static Future<void> saveWardrobe(List<ClothingItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final listJson = items.map((e) => e.toJson()).toList();
    await prefs.setString(_wardrobeKey, jsonEncode(listJson));
  }

  // โหลดรายการเสื้อผ้า
  static Future<List<ClothingItem>> loadWardrobe() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_wardrobeKey);
    if (data == null) return [];
    final list = jsonDecode(data) as List;
    return list.map((e) => ClothingItem.fromJson(e)).toList();
  }
}