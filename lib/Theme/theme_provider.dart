import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      final brightness = SchedulerBinding.instance.window.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return _themeMode == ThemeMode.dark;
    }
  }

  ThemeMode get themeMode => _themeMode;

  void toggleTheme(bool isOn) {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class AppThemeData {
  final Color primaryColor = Color.fromRGBO(34, 111, 39, 1);
  final Color secondaryColor = Colors.grey.shade900;
  final Color accentColor = Color.fromRGBO(50, 163, 57, 1);
  final Color redColor = Colors.red;
  final Color blueColor = Colors.blue;
  final Color deepBlueColor = Colors.blue.shade800;
  final Color yellowColor = Colors.yellow;
  final Color whiteColor = Colors.white;
  final Color greyColor = Colors.grey;
  final Color grey200Color = Colors.grey.shade200;

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Color.fromRGBO(34, 111, 39, 1),
    backgroundColor: Colors.grey.shade900,
    fontFamily: 'Open Sans',
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.grey.shade900,
    ),
    appBarTheme: AppBarTheme(color: Colors.white, elevation: 0.0),
    iconTheme: IconThemeData(color: Colors.grey.shade900),
    textTheme: TextTheme(
      headline1: TextStyle(fontSize: 96.0, fontWeight: FontWeight.bold),
      headline2: TextStyle(fontSize: 60.0, fontWeight: FontWeight.bold),
      headline3: TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold),
      headline4: TextStyle(fontSize: 34.0, fontWeight: FontWeight.bold),
      headline5: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
      headline6: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      subtitle1: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      subtitle2: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
      bodyText1: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
      bodyText2: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
      caption: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal),
      overline: TextStyle(fontSize: 10.0, fontWeight: FontWeight.normal),
    ),
    colorScheme:
        ColorScheme.light().copyWith(secondary: Color.fromRGBO(50, 163, 57, 1)),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor:
        Colors.grey.shade900, // Set the scaffold background color for dark mode
    backgroundColor: Colors.grey.shade900,
    primaryColor: Color.fromRGBO(34, 111, 39, 1),
    fontFamily: 'Open Sans',
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.grey.shade900,
    ),
    appBarTheme: AppBarTheme(color: Colors.grey.shade900, elevation: 0.0),
    iconTheme: IconThemeData(color: Colors.white),
    textTheme: TextTheme(
      headline1: TextStyle(fontSize: 96.0, fontWeight: FontWeight.bold),
      headline2: TextStyle(fontSize: 60.0, fontWeight: FontWeight.bold),
      headline3: TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold),
      headline4: TextStyle(fontSize: 34.0, fontWeight: FontWeight.bold),
      headline5: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
      headline6: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      subtitle1: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      subtitle2: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
      bodyText1: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
      bodyText2: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
      caption: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal),
      overline: TextStyle(fontSize: 10.0, fontWeight: FontWeight.normal),
    ),
    colorScheme:
        ColorScheme.dark().copyWith(secondary: Color.fromRGBO(50, 163, 57, 1)),
  );
}
