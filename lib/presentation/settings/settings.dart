import 'package:flutter/material.dart';
import '../service/common/theme/theme_provider.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = ThemeProvider.of(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(title: Text("Theme: ${isDark ? "Dark" : "Light"}")),
      body: Center(
        child: ElevatedButton(
          onPressed: () => themeProvider.toggleTheme(),
          child: Text(isDark ? 'Светлая тема' : 'Тёмная тема'),
        ),
      ),
    );
  }
}
