import 'package:dogeeexd/AppTheme.dart';
import 'package:flutter/cupertino.dart';

class ThemeProvider with ChangeNotifier {
  var _currentTheme = AppTheme.lightTheme;

  get currentTheme {
    return _currentTheme;
  }

  // set currentTheme(bool isDarkMode) {
  //   if (isDarkMode == true) {
  //     _currentTheme = AppTheme.darkTheme;
  //     notifyListeners();
  //   } else {
  //     _currentTheme = AppTheme.lightTheme;
  //     notifyListeners();
  //   }
  // }

  setTheme(bool isDarkMode) {
    if (isDarkMode == true) {
      _currentTheme = AppTheme.darkTheme;
      notifyListeners();
    } else {
      _currentTheme = AppTheme.lightTheme;
      notifyListeners();
    }
  }
}
