import 'dart:developer';
import 'package:animate_do/animate_do.dart';
import 'package:diplom/core/components/build_button.dart';
import 'package:diplom/core/components/build_button_with_icon.dart';
import 'package:diplom/core/components/build_text.dart';
import 'package:diplom/domain/auth/auth_service.dart';
import 'package:diplom/presentation/screens/bottom_nav_bar/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  bool obscured = true;
  bool readPrivacy = false;
  bool regBtnClick = false;

  Future<void> _registerWithCredential() async {
    if (!_key.currentState!.validate()) {
      return;
    }

    try {
      AuthService authService = AuthService();

      await authService.registerWithEmailAndPassword(
        _emailController.text,
        _pwController.text,
        _nameController.text,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CustomBottomNavBar()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Ошибка: Регистрации")));
    }
  }

  Future<void> _registerWithGoogle() async {
    try {
      AuthService authService = AuthService();
      authService
          .registerGoogle()
          .then((userCredential) {
            final user = userCredential?.user;
            if (user != null) {
              if (!mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => CustomBottomNavBar()),
              );
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("Успешная регистрация")));
            } else {
              if (!mounted) return;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("Пользователь не найден")));
            }
          })
          .catchError((e) {
            String errorMessage = "Ошибка регистрации: $e";
            if (e.toString().contains('network')) {
              errorMessage = "Проверьте подключение к интернету.";
            }
            if (!mounted) return;

            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(errorMessage)));
          });
    } catch (e) {
      log('Register error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                        text: 'Create your account!',
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                      // CONTINUE WITH FACEBOOK
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
                        padding: const EdgeInsets.only(top: 40.0, bottom: 40.0),
                        child: BuildButtonWithIconOrImage(
                          onTap: _registerWithGoogle,
                          faIcons: FontAwesomeIcons.google,
                          iconColor: const Color.fromARGB(255, 228, 209, 36),
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
                              // NAME
                              TextFormField(
                                controller: _nameController,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Введите имя';
                                  } else if (value.trim().length < 4) {
                                    return 'Имя должно содержать не менее 4 символов';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color(0xffF2F3F7),
                                  hintText: 'ENTER YOUR NAME',
                                  hintStyle: TextStyle(
                                    color: Color(0xffA1A4B2),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                              // EMAIL
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20.0,
                                ),
                                child: TextFormField(
                                  controller: _emailController,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
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
                                    hintText: 'EMAIL',
                                    hintStyle: TextStyle(
                                      color: Color(0xffA1A4B2),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                              TextFormField(
                                keyboardType: TextInputType.visiblePassword,
                                controller: _pwController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Введите пароль';
                                  } else if (value.length < 6) {
                                    return 'Пароль должен быть не менее 6 символов';
                                  }
                                  return null;
                                },
                                obscureText: obscured,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color(0xffF2F3F7),
                                  hintText: 'PASSWORD',
                                  hintStyle: TextStyle(
                                    color: Color(0xffA1A4B2),
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        obscured = !obscured;
                                      });
                                    },
                                    icon:
                                        obscured
                                            ? Icon(Icons.visibility_outlined)
                                            : Icon(
                                              Icons.visibility_off_outlined,
                                            ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                              // LOGIN BUTTON
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: [
                                BuildText(
                                  text: 'I have read the',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    //TODO create a method wich has buildet some window who have information about privacy and policy
                                  },
                                  child: BuildText(
                                    text: '\tPrivacy Policy',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    textColor: Color(0xff8E97FD),
                                  ),
                                ),
                              ],
                            ),
                            Checkbox.adaptive(
                              value: readPrivacy,
                              onChanged: (_) {
                                setState(() {
                                  readPrivacy = !readPrivacy;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      BuildButton(
                        onTap: () {
                          if (readPrivacy) {
                            _registerWithCredential();
                          } else {
                            setState(() {
                              regBtnClick = true;
                            });
                          }
                        },
                        btnColor: Color(0xff8E97FD),
                        text: 'GET STARTED',
                        textSize: 16,
                        textFontWeight: FontWeight.w600,
                        textColor: Colors.white,
                      ),
                      if (!readPrivacy && regBtnClick)
                        ElasticIn(
                          child: Text(
                            'Firstly you must read the PRIVACY AND POLICY',
                            style: TextStyle(color: Colors.redAccent),
                          ),
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
