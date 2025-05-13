import 'package:diplom/presentation/main/wiki_page.dart';
import 'package:diplom/presentation/open_lib.dart/open_lib.dart';
import 'package:diplom/presentation/rifma_screen/rifma_screen.dart';
import 'package:diplom/presentation/settings/settings.dart';
import 'package:diplom/presentation/youtube/youtube_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int pageIndex = 0;

  final pages = [WikiPage(), OpenLib(), RifmaScreen(), Youtube(), Settings()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        selectedItemColor:
            Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
        unselectedItemColor:
            Theme.of(context).brightness == Brightness.dark
                ? Colors.white54
                : Colors.black26,
        currentIndex: pageIndex,
        onTap: (value) {
          setState(() {
            pageIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            backgroundColor: Color(0xff601fb4),
            label: 'Wiki',
            icon: FaIcon(FontAwesomeIcons.wikipediaW),
          ),
          BottomNavigationBarItem(
            backgroundColor: Color(0xff9b1dba),
            label: 'Open Library',
            icon: Icon(Icons.library_books_outlined),
          ),
          BottomNavigationBarItem(
            backgroundColor: Color(0xffba1db5),
            label: 'Open Rima',
            icon: Icon(Icons.workspaces_filled),
          ),
          BottomNavigationBarItem(
            label: 'Youtube',
            icon: FaIcon(FontAwesomeIcons.youtube),
          ),
          BottomNavigationBarItem(
            label: 'Settings',
            icon: Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: pages[pageIndex],
    );
  }
}
