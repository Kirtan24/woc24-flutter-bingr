import 'package:shared_preferences/shared_preferences.dart';

class LoginController {
  Future<void> saveLoginDetails(
      String email, String password, bool rememberMe) async {
    if (rememberMe) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', email);
      await prefs.setString('password', password);
      await prefs.setBool('rememberMe', rememberMe);
    }
  }

  Future<Map<String, dynamic>> getLoginDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString('email');
    final String? password = prefs.getString('password');
    final bool? rememberMe = prefs.getBool('rememberMe');

    return {'email': email, 'password': password, 'rememberMe': rememberMe};
  }

  Future<void> clearLoginDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
