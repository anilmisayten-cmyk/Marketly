import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:marketplace_app/constants/theme.dart';
import 'package:marketplace_app/pages/auth_page.dart';
import 'package:marketplace_app/utilities/utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MarketlyApp());
}

class MarketlyApp extends StatefulWidget {
  const MarketlyApp({super.key});
  @override
  State<MarketlyApp> createState() => _MarketlyAppState();
}

class _MarketlyAppState extends State<MarketlyApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleTheme() => setState(() {
        _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: Utils.messengerKey,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeMode,
      home: AuthPage(),
      builder: (context, child) => ThemeModeOverlay(
        themeMode: _themeMode,
        onToggle: _toggleTheme,
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}

class ThemeModeOverlay extends StatelessWidget {
  final ThemeMode themeMode;
  final VoidCallback onToggle;
  final Widget child;
  const ThemeModeOverlay({super.key, required this.themeMode, required this.onToggle, required this.child});

  @override
  Widget build(BuildContext context) => _ThemeScope(onToggle: onToggle, child: child);
}

class _ThemeScope extends InheritedWidget {
  final VoidCallback onToggle;
  const _ThemeScope({required this.onToggle, required super.child});
  static _ThemeScope? of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<_ThemeScope>();
  @override
  bool updateShouldNotify(_ThemeScope oldWidget) => oldWidget.onToggle != onToggle;
}

VoidCallback? themeToggle(BuildContext context) => _ThemeScope.of(context)?.onToggle;
