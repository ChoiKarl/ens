import 'package:shared_preferences/shared_preferences.dart';

class UserDefault {
  static late SharedPreferences shared;

  static Future<void> init() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    shared = sharedPreferences;
    return;
  }
}