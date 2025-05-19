import 'package:diplom/core/components/build_text.dart';
import 'package:diplom/domain/auth/auth_service.dart';
import 'package:diplom/presentation/first/first_screen.dart';
import 'package:diplom/presentation/login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreens extends StatefulWidget {
  const ProfileScreens({super.key});

  @override
  State<ProfileScreens> createState() => _ProfileScreensState();
}

class _ProfileScreensState extends State<ProfileScreens> {
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
      backgroundColor: const Color(0xfff8ecd6),
      body: Stack(
        children: [
          Positioned(
            right: 0,
            bottom: 0,
            child: Image.asset('assets/img/botFlow.png'),
          ),
          Positioned(
            child: Container(
              width: double.infinity,
              height: 240,
              decoration: BoxDecoration(
                color: const Color(0xfffbe7c3),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.elliptical(300, 25),
                  bottomRight: Radius.elliptical(300, 25),
                ),
              ),
            ),
          ),
          Positioned(
            top: 70,
            left: 24,
            child: BuildText(
              text: 'MindHorizon',
              fontSize: 19,
              fontWeight: FontWeight.w700,
              textColor: const Color(0xfffea386),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 100),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: const BoxDecoration(
                        color: Color(0xfffea386),
                        shape: BoxShape.circle,
                      ),
                      child:
                          user?.photoURL != null
                              ? ClipOval(
                                child: Image.network(
                                  user!.photoURL!,
                                  fit: BoxFit.cover,
                                ),
                              )
                              : Image.asset('assets/img/cuate.png'),
                    ),
                  ),
                  BuildText(
                    text: user?.displayName ?? 'User',
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    textColor: const Color(0xfff19584),
                  ),
                  BuildText(
                    text: user?.email ?? 'user@gmail.com',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    textColor: const Color(0xfff19584),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 48),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 32, bottom: 16),
                          child: _buildMenuContainer([
                            _buildMenuItem(
                              Icons.manage_accounts_outlined,
                              'Edit profile information',
                              () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder:
                                //         (_) => DetailProfileScreens(index: 0),
                                //   ),
                                // );
                              },
                            ),
                            _buildMenuItem(
                              Icons.notifications_outlined,
                              'Notifications',
                              () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder:
                                //         (_) => DetailProfileScreens(index: 1),
                                //   ),
                                // );
                              },
                            ),
                            _buildMenuItem(Icons.exit_to_app, 'Exit', () {
                              _showDialog(
                                'Exit',
                                'Are you sure you want to sign out?',
                                _logout,
                              );
                            }),
                            _buildMenuItem(
                              Icons.delete_outline,
                              'Delete Account',
                              () {
                                _showDialog(
                                  'Delete',
                                  'Are you sure you want to delete your account?',
                                  _deleteAccount,
                                );
                              },
                            ),
                          ]),
                        ),
                        SizedBox(height: 5),
                        _buildMenuContainer([
                          _buildMenuItem(
                            Icons.wifi_protected_setup_sharp,
                            'Help & Support',
                            () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (_) => DetailProfileScreens(index: 2),
                              //   ),
                              // );
                            },
                          ),
                          _buildMenuItem(
                            Icons.mark_email_read_outlined,
                            'Contact us',
                            () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (_) => DetailProfileScreens(index: 3),
                              //   ),
                              // );
                            },
                          ),
                          _buildMenuItem(
                            Icons.lock_clock_outlined,
                            'Privacy policy',
                            () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (_) => DetailProfileScreens(index: 4),
                              //   ),
                              // );
                            },
                          ),
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuContainer(List<Widget> children) {
    return Container(
      width: double.infinity,
      height: 160,
      decoration: BoxDecoration(
        color: const Color(0xfffbe7c3),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff000000).withValues(alpha: 0.05),
            offset: Offset(10, 20),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: children,
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: <Widget>[
          Icon(icon, color: const Color(0xfff19584)),
          SizedBox(width: 8),
          Text(text, style: TextStyle(color: const Color(0xfff19584))),
        ],
      ),
    );
  }

  void _showDialog(String title, String content, VoidCallback onYes) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onYes();
                },
                child: const Text('Yes'),
              ),
            ],
          ),
    );
  }
}
