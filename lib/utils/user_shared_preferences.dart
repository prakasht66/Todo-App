import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPreference {
  static SharedPreferences? _preferences;
  static const _keyimagePath = 'image_path';
  static const _keyuserbio = 'user_bio';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setUserImage(String path) async {
    _preferences?.setString(_keyimagePath, path);
  }

  static String? getUserImage() => _preferences?.getString(_keyimagePath);

  static Future setUserBio(String description) async {
    _preferences?.setString(_keyuserbio, description);
  }

  static String? getUserBio() => _preferences?.getString(_keyuserbio);
}
