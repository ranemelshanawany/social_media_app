import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreferences {
  static SharedPreferences _myPrefs;

  static const _walkthroughkey = "openedbefore";

  static Future init() async => _myPrefs = await SharedPreferences.getInstance();


  static setBooleanValue(bool value) async {
    await _myPrefs.setBool(_walkthroughkey, value);
  }

  static bool getBooleanValue() {
    return _myPrefs.getBool("openedbefore") ?? false;
  }

}