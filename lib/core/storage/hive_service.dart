import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  HiveService._();

  static const String settingsBoxName = 'app_settings';
  static const String profileBoxName = 'user_profile';
  static const String applicationsBoxName = 'job_applications';

  static Future<void> init() async {
    try {
      if (!kIsWeb) {
        final appDir = await getApplicationDocumentsDirectory();
        await Hive.initFlutter(appDir.path);
      } else {
        await Hive.initFlutter();
      }

      // Open boxes
      await Hive.openBox(settingsBoxName);
      await Hive.openBox(profileBoxName);
      await Hive.openBox(applicationsBoxName);
      
      // Seed default profile data if empty
      final profileBox = Hive.box(profileBoxName);
      if (profileBox.isEmpty) {
        await profileBox.putAll({
          'name': 'John Doe',
          'email': 'john.doe@university.edu',
          'rollNo': 'CS20261042',
          'department': 'Computer Science & Engineering',
          'gpa': '9.2',
          'skills': ['Flutter', 'Dart', 'Clean Architecture', 'Riverpod', 'Hive'],
          'resumeName': 'John_Doe_Resume_2026.pdf',
        });
      }
    } catch (e) {
      debugPrint('Error initializing Hive: $e');
    }
  }

  // Getters for boxes
  static Box get settingsBox => Hive.box(settingsBoxName);
  static Box get profileBox => Hive.box(profileBoxName);
  static Box get applicationsBox => Hive.box(applicationsBoxName);

  // Helper Methods
  static T? getSetting<T>(String key, {T? defaultValue}) {
    return settingsBox.get(key, defaultValue: defaultValue) as T?;
  }

  static Future<void> saveSetting<T>(String key, T value) async {
    await settingsBox.put(key, value);
  }

  static T? getProfileValue<T>(String key, {T? defaultValue}) {
    return profileBox.get(key, defaultValue: defaultValue) as T?;
  }

  static Future<void> saveProfileValue<T>(String key, T value) async {
    await profileBox.put(key, value);
  }

  static Future<void> clearAll() async {
    await settingsBox.clear();
    await profileBox.clear();
  }
}
