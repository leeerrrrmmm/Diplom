import 'package:diplom/core/components/build_text.dart';
import 'package:diplom/domain/auth/auth_service.dart';
import 'package:diplom/presentation/first/first_screen.dart';
import 'package:diplom/presentation/login/login_screen.dart';
import 'package:diplom/presentation/settings/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() {
    user = AuthService().getCurrentUser();
    setState(() {});
  }

  Future<void> _logout() async {
    await AuthService().logout(context).then((_) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    });
  }

  Future<void> _deleteAccount() async {
    await AuthService().deleteAccount(context).then((_) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => FirstScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BuildText(
          text: 'Profile',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: <Widget>[
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 4, color: Colors.blueAccent),
                ),
                child: CircleAvatar(
                  radius: 70,
                  backgroundColor: Color(0xff84C6AE),
                  backgroundImage: AssetImage('assets/pro.png'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  children: [
                    BuildText(
                      text: user!.displayName ?? 'user',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    BuildText(
                      text: user!.email ?? 'user@gmail.com',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
              ),
              _buildButton(
                () => Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => Settings()),
                ),
                'Settings',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: _buildButton(() {
                  _logout();
                }, 'Log Out'),
              ),
              _buildButton(() {
                _deleteAccount();
              }, 'Delete Account'),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector _buildButton(
    final void Function()? onTap,
    final String text,
  ) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        border: Border.all(width: 0.5),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Center(
        child: BuildText(text: text, fontSize: 24, fontWeight: FontWeight.bold),
      ),
    ),
  );
}
