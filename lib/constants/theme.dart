import 'package:flutter/material.dart';
import 'package:marketplace_app/constants/colors.dart';

ThemeData buildMarketlyTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  final scheme = ColorScheme.fromSeed(
    seedColor: kDefaultRedColor,
    brightness: brightness,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor:
        isDark ? const Color(0xFF0D0E12) : const Color(0xFFF6F7F9),
    fontFamily: 'Nunito',
    appBarTheme: AppBarTheme(
      backgroundColor: isDark ? const Color(0xFF0D0E12) : Colors.white,
      foregroundColor: isDark ? Colors.white : const Color(0xFF17181C),
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      shape: const Border(bottom: BorderSide(color: Color(0x12000000))),
    ),
    cardTheme: CardThemeData(
      color: isDark ? const Color(0xFF17191F) : Colors.white,
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: isDark ? const Color(0xFF191B21) : Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: kDefaultRedColor, width: 1.4),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
    ),
    iconTheme: IconThemeData(
      color: isDark ? Colors.white70 : const Color(0xFF34363D),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: isDark ? const Color(0xFF111318) : Colors.white,
      indicatorColor: kDefaultRedColor.withOpacity(.16),
      labelTextStyle: MaterialStatePropertyAll(
        TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: kDefaultRedColor,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    ),
  );
}

final lightTheme = buildMarketlyTheme(Brightness.light);
final darkTheme = buildMarketlyTheme(Brightness.dark);
