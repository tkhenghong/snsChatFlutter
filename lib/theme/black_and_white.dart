
// Default theme details in the app
import 'dart:ui';

import 'package:flutter/material.dart';

Brightness primaryBrightness = Brightness.light;

// https://material.io/design/color/the-color-system.html#tools-for-picking-colors
// Flutter Theme Color Palette Resource: https://material.io/resources/color/#!/

int primaryColorValue = 0xFF000000;
int primaryLightColorValue = 0xFF2C2C2C;
int primaryDarkColorValue = 0xFF000000;
int secondaryColorValue = 0xFFFFFFFF;
int secondaryLightColorValue = 0xFFFFFFFF;
int secondaryDarkColorValue = 0xFFCCCCCC;
int primaryTextColorValue = 0xFFFFFFFF;
int secondaryTextColorValue = 0xFF000000;

// Black theme. Black is not MaterialColor, which has a list of colors within it
// https://github.com/flutter/flutter/issues/15658
MaterialColor primaryColor = MaterialColor(
  primaryColorValue,
  <int, Color>{
    50: Color(0xFFF5F5F5),
    100: Color(0xFFE9E9E9),
    200: Color(0xFFD9D9D9),
    300: Color(0xFFC4C4C4),
    400: Color(0xFF9D9D9D),
    500: Color(0xFF7B7B7B),
    600: Color(0xFF555555),
    700: Color(0xFF434343),
    800: Color(0xFF262626),
    900: Color(primaryColorValue),
  },
);

MaterialColor secondaryColor = MaterialColor(
  secondaryColorValue,
  <int, Color>{
    50: Color(0xFFFFFFFF), // #FFFFFF
    100: Color(0xFFFAFAFA), // #FAFAFA
    200: Color(0xFFF5F5F5), // #F5F5F5
    300: Color(0xFFF0F0F0), // #F0F0F0
    400: Color(0xFFDEDEDE), // #DEDEDE
    500: Color(0xFFC2C2C2), // #C2C2C2
    600: Color(0xFF979797), // #979797
    700: Color(0xFF818181), // #818181
    800: Color(0xFF606060), // #606060
    900: Color(secondaryColorValue), // #3C3C3C
  },
);

ThemeData themeData = ThemeData(
  fontFamily: 'Roboto',
  brightness: primaryBrightness,
  primarySwatch: primaryColor,
  primaryColor: primaryColor,
  accentColor: primaryColor,
  cursorColor: primaryColor,
  scaffoldBackgroundColor: secondaryColor,
  backgroundColor: secondaryColor,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: secondaryColor,
    selectedItemColor: primaryColor,
    unselectedItemColor: primaryColor[500],
    selectedIconTheme: IconThemeData(color: primaryColor),
    selectedLabelStyle: TextStyle(color: primaryColor),
    unselectedIconTheme: IconThemeData(color: primaryColor[500]),
    unselectedLabelStyle: TextStyle(color: primaryColor[500]),
  ),
  highlightColor: primaryColor[500],
  textSelectionColor: primaryColor[400],
  textSelectionHandleColor: primaryColor,
  indicatorColor: secondaryColor,
  buttonColor: primaryColor,
  buttonTheme: ButtonThemeData(buttonColor: primaryColor, textTheme: ButtonTextTheme.primary),
  errorColor: primaryColor,
  bottomAppBarColor: primaryColor,
  bottomAppBarTheme: BottomAppBarTheme(
    color: primaryColor,
  ),
  // Invert color
  // appBarTheme: AppBarTheme(color: secondaryColor, textTheme: TextTheme(headline6: TextStyle(color: primaryColor))),
);