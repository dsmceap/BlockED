import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeStateNotifier extends ChangeNotifier{
  bool isDarkMode = false;

  ThemeStateNotifier(bool isDark){
    if(isDark){
      isDarkMode = true;
    } else {
      isDarkMode = false;
    }
  }

  darkTheme(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    this.isDarkMode = isDarkMode;
    await prefs.setBool("isDarkMode", isDarkMode);
    notifyListeners();
  }
}
