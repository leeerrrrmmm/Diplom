import 'package:diplom/data/local/theme/theme_storage.dart';
import 'package:diplom/presentation/bottom_nav_bar/custom_bottom_nav_bar.dart';
import 'package:diplom/presentation/service/common/theme/theme_provider.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    _themeMode = await ThemeStorage.getThemeMode();
    setState(() {});
  }

  Future<void> _toggleTheme() async {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
    await ThemeStorage.saveThemeMode(_themeMode);
  }

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      themeMode: _themeMode,
      toggleTheme: _toggleTheme,
      child: Builder(
        builder: (context) {
          final mode = ThemeProvider.of(context).themeMode;
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: mode,
            home: CustomBottomNavBar(),
          );
        },
      ),
    );
  }
}
