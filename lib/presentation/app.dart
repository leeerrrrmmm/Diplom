import 'package:diplom/data/local/theme/theme_storage.dart';
import 'package:diplom/generated/l10n.dart';
import 'package:diplom/presentation/first/first_screen.dart';
import 'package:diplom/presentation/service/common/lang/locale_provider.dart';
import 'package:diplom/presentation/service/common/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
    final localeProvider = Provider.of<LocaleProvider>(context);

    if (!localeProvider.isLoaded) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator.adaptive()),
        ),
      );
    }

    return ThemeProvider(
      themeMode: _themeMode,
      toggleTheme: _toggleTheme,
      child: Builder(
        builder: (context) {
          final mode = ThemeProvider.of(context).themeMode;
          return MaterialApp(
            locale: localeProvider.locale,
            localizationsDelegates: [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            supportedLocales: S.delegate.supportedLocales,
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: mode,
            home: FirstScreen(),
          );
        },
      ),
    );
  }
}
