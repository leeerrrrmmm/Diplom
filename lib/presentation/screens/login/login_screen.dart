import 'dart:developer';
import 'package:diplom/core/components/build_button.dart';
import 'package:diplom/core/components/build_button_with_icon.dart';
import 'package:diplom/core/components/build_text.dart';
import 'package:diplom/domain/auth/auth_service.dart';
import 'package:diplom/presentation/screens/bottom_nav_bar/custom_bottom_nav_bar.dart';
import 'package:diplom/presentation/screens/register/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final obscured = true;

  Future<void> _loginWithCredential() async {
    if (!_key.currentState!.validate()) {
      return;
    }

    try {
      AuthService authService = AuthService();

      await authService.loginWithEmailAndPassword(
        _emailController.text,
        _pwController.text,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('exit_type');
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CustomBottomNavBar()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Align(
            alignment: Alignment.center,
            child: Text("Ошибка авторизации"),
          ),
        ),
      );
    }
  }

  Future<void> _loginWithGoogle() async {
    try {
      final userCredential = await AuthService().registerGoogle();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('exit_type');
      if (userCredential != null && mounted) {
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CustomBottomNavBar()),
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Google Sign In was CANCELLED')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            child: Image.asset('assets/topp.png', color: Colors.black12),
          ),
          Positioned.fill(
            top: 80,
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      BuildText(
                        text: 'Welcome Back!',
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                      // CONTINUE WITH FACEBOOK AND GOOGLE
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          //CONTINUE WITH FACEBOOK
                          Padding(
                            padding: const EdgeInsets.only(top: 40.0),
                            child: BuildButtonWithIconOrImage(
                              onTap: () {
                                log('CONTINUE WITH FACEBOOK');
                              },
                              faIcons: FontAwesomeIcons.facebookF,
                              iconColor: Colors.white,
                              btnColor: Color(0xff7583CA),
                              text: 'CONTINUE WITH FACEBOOK',
                              textSize: 16,
                              textFontWeight: FontWeight.bold,
                              textColor: Colors.white,
                              isIcon: true,
                            ),
                          ),
                          // CONTINUE WITH GOOGLE
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 40.0,
                              bottom: 40.0,
                            ),
                            child: BuildButtonWithIconOrImage(
                              onTap: () {
                                _loginWithGoogle();
                              },
                              faIcons: FontAwesomeIcons.google,
                              iconColor: const Color.fromARGB(
                                255,
                                228,
                                209,
                                36,
                              ),
                              btnColor: Colors.transparent,
                              text: 'CONTINUE WITH GOOGLE',
                              textSize: 16,
                              textFontWeight: FontWeight.bold,
                              textColor: Colors.black,
                              isIcon: false,
                              assetName: 'assets/ggg.png',
                            ),
                          ),
                          // OR LOGIN WITH EMAIL TEXT && LOGIN TEXTFIELD WITH LOGIN BTN
                          BuildText(
                            text: 'OR LOGIN WITH EMAIL ',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            textColor: Color(0xffA1A4B2),
                          ),
                          // TEXT FIELD WITH FORM
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Form(
                              key: _key,
                              child: Column(
                                children: <Widget>[
                                  // EMAIL
                                  TextFormField(
                                    controller: _emailController,
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'Введите email';
                                      }
                                      final emailRegex = RegExp(
                                        r'^[^@]+@[^@]+\.[^@]+',
                                      );
                                      if (!emailRegex.hasMatch(value.trim())) {
                                        return 'Введите корректный email';
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Color(0xffF2F3F7),
                                      hintText: 'EMAIL ADRESS',
                                      hintStyle: TextStyle(
                                        color: Color(0xffA1A4B2),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          15.0,
                                        ),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                  // PASSWORD
                                  Padding(
                                    padding: const EdgeInsets.only(top: 40.0),
                                    child: TextFormField(
                                      controller: _pwController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Введите пароль';
                                        } else if (value.length < 6) {
                                          return 'Пароль должен быть не менее 6 символов';
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Color(0xffF2F3F7),
                                        hintText: 'PASSWORD',
                                        hintStyle: TextStyle(
                                          color: Color(0xffA1A4B2),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            15.0,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                  ),

                                  // LOGIN BUTTON
                                ],
                              ),
                            ),
                          ),
                          BuildButton(
                            onTap: () {
                              _loginWithCredential();
                            },
                            btnColor: Color(0xff8E97FD),
                            text: 'LOG IN',
                            textSize: 16,
                            textFontWeight: FontWeight.w600,
                            textColor: Colors.white,
                          ),
                          const SizedBox(height: 20.0),
                          GestureDetector(
                            onTap: () {
                              log('press on FORGOT PASS');
                            },
                            child: BuildText(
                              text: 'Forgot password ?',
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      // HAVE AN ACCOUNT
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BuildText(
                            text: 'ALREADY HAVE AN ACCOUNT?',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            textColor: Color(0xffA1A4B2),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegisterScreen(),
                                ),
                              );
                            },
                            child: BuildText(
                              text: '\tSIGN IN',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              textColor: Color(0xff8E97FD),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
