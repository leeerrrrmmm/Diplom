import 'package:diplom/presentation/main/wiki_page.dart';
import 'package:diplom/presentation/open_lib.dart/open_lib.dart';
import 'package:diplom/presentation/profile/profile_screen.dart';
import 'package:diplom/presentation/rifma_screen/rifma_screen.dart';
import 'package:diplom/presentation/youtube/youtube_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int pageIndex = 4;

  final pages = [
    WikiPage(),
    OpenLib(),
    RifmaScreen(),
    Youtube(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Цвета для каждой вкладки по индексу
    final darkThemeColors = [
      const Color(0xff601fb4), // Wiki
      const Color(0xff9b1dba), // Open Library
      const Color(0xffba1db5), // Open Rima
      Colors.red, // YouTube
      Colors.black, // Settings
    ];

    final lightThemeColors = [
      const Color(0xffb388ff), // Wiki
      const Color(0xffce93d8), // Open Library
      const Color(0xfff48fb1), // Open Rima
      Colors.redAccent, // YouTube (яркий)
      const Color.fromARGB(255, 235, 228, 228), // Settings
    ];

    final selectedBackgroundColor =
        isDark ? darkThemeColors[pageIndex] : lightThemeColors[pageIndex];

    return Scaffold(
      backgroundColor: selectedBackgroundColor,
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        currentIndex: pageIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: isDark ? Colors.white54 : Colors.black26,
        backgroundColor: selectedBackgroundColor,
        onTap: (value) {
          setState(() {
            pageIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            backgroundColor: selectedBackgroundColor,
            label: 'Wiki',
            icon: const FaIcon(FontAwesomeIcons.wikipediaW),
          ),
          BottomNavigationBarItem(
            backgroundColor: selectedBackgroundColor,
            label: 'Open Library',
            icon: const Icon(Icons.library_books_outlined),
          ),
          BottomNavigationBarItem(
            backgroundColor: selectedBackgroundColor,
            label: 'Open Rima',
            icon: const Icon(Icons.workspaces_filled),
          ),
          BottomNavigationBarItem(
            backgroundColor: selectedBackgroundColor,
            label: 'YouTube',
            icon: const FaIcon(FontAwesomeIcons.youtube),
          ),
          BottomNavigationBarItem(
            backgroundColor: selectedBackgroundColor,
            label: 'Settings',
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: pages[pageIndex],
    );
  }
}
