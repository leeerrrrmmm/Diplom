import 'package:diplom/presentation/bottom_nav_bar/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CustomBottomNavBar(),
      debugShowCheckedModeBanner: false,
    );
  }
}
