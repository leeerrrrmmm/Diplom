import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diplom/presentation/screens/bottom_nav_bar/custom_bottom_nav_bar.dart';
import 'package:diplom/presentation/screens/first/first_screen.dart';
import 'package:diplom/presentation/screens/login/login_screen.dart';
import 'package:diplom/presentation/screens/register/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  Future<String?> getExitType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('exit_type');
  }

  Future<bool> userExistsInFirestore(String uid) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return doc.exists;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getExitType(),
      builder: (context, exitSnapshot) {
        if (exitSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator.adaptive()),
          );
        }

        final exitType = exitSnapshot.data;

        return StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, authSnapshot) {
            if (authSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator.adaptive()),
              );
            }

            if (authSnapshot.hasError) {
              return Scaffold(
                body: Center(child: Text(authSnapshot.error.toString())),
              );
            }

            final user = authSnapshot.data;

            if (user != null) {
              // Проверяем наличие пользователя в Firestore
              return FutureBuilder<bool>(
                future: userExistsInFirestore(user.uid),
                builder: (context, firestoreSnapshot) {
                  if (firestoreSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Scaffold(
                      body: Center(child: CircularProgressIndicator.adaptive()),
                    );
                  }

                  if (firestoreSnapshot.data == true) {
                    return const CustomBottomNavBar();
                  } else {
                    return const CustomBottomNavBar();
                  }
                },
              );
            } else {
              if (exitType == 'logout') {
                return const LoginScreen();
              } else if (exitType == 'delete') {
                return const FirstScreen();
              } else {
                return const RegisterScreen();
              }
            }
          },
        );
      },
    );
  }
}
