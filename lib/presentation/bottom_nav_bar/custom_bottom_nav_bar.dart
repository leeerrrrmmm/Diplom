import 'package:diplom/presentation/main/wiki_page.dart';
import 'package:diplom/presentation/open_lib.dart/open_lib.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int pageIndex = 0;

  final pages = [WikiPage(), OpenLib()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageIndex,
        onTap: (value) {
          setState(() {
            pageIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            label: 'Wiki',
            icon: FaIcon(FontAwesomeIcons.wikipediaW),
          ),
          BottomNavigationBarItem(
            label: 'Open Library',
            icon: Icon(Icons.library_books_outlined),
          ),
        ],
      ),
      body: pages[pageIndex],
    );
  }
}
