import 'package:diplom/generated/l10n.dart';
import 'package:diplom/presentation/service/common/lang/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../service/common/theme/theme_provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    final localString = S.of(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final currentCode = localeProvider.locale?.languageCode ?? 'en';

    final themeProvider = ThemeProvider.of(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(title: Text(localString.settings)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 16.0,
            ),
            child: _buildLanguageTile(
              title: localString.locale,
              icon: Icons.language,
              currentCode: currentCode,
              onLocaleChanged:
                  (value) => localeProvider.updateLocale(Locale(value)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 16.0,
            ),
            child: _buildThemeTile(
              title: localString.theme,
              themeTitle: isDark ? localString.dark : localString.light,
              icon: Icons.light_mode_outlined,
              currentCode: currentCode,
              onTap: () => themeProvider.toggleTheme(),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildThemeTile({
  required String title,
  required String themeTitle,
  required IconData icon,
  required String currentCode,
  required void Function()? onTap,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: Colors.grey),
    ),
    width: double.infinity,
    height: 80,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: [
            Icon(icon),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        GestureDetector(
          onTap: onTap,
          child: SizedBox(
            width: 140,
            height: 50,
            child: Center(child: Text(themeTitle)),
          ),
        ),
      ],
    ),
  );
}

// 📌 Метод: Смена языка
Widget _buildLanguageTile({
  required String title,
  required IconData icon,
  required String currentCode,
  required void Function(String) onLocaleChanged,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: Colors.grey),
    ),
    width: double.infinity,
    height: 80,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: [
            Icon(icon),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        DropdownButton<String>(
          value: currentCode,
          underline: const SizedBox(),
          items: const [
            DropdownMenuItem(value: 'en', child: Text('English')),
            DropdownMenuItem(value: 'ru', child: Text('Русский')),
            DropdownMenuItem(value: 'uk', child: Text('Українська')),
          ],
          onChanged: (value) {
            if (value != null) onLocaleChanged(value);
          },
        ),
      ],
    ),
  );
}
