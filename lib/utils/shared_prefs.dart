import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreferences {
  static SharedPreferences _myPrefs;

  static const _walkthroughkey = "openedbefore";
  static const _login = "login";

  static Future init() async => _myPrefs = await SharedPreferences.getInstance();


  static setWalkthroughBooleanValue(bool value) async {
    await _myPrefs.setBool(_walkthroughkey, value);
  }

  static bool getWalkthroughBooleanValue() {
    return _myPrefs.getBool("openedbefore") ?? false;
  }

  static setLoginBooleanValue(bool value) async {
    await _myPrefs.setBool(_login, value);
  }

  static bool getLoginBooleanValue() {
    return _myPrefs.getBool("login") ?? false;
  }



}