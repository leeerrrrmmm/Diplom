import 'package:diplom/core/components/build_button.dart';
import 'package:diplom/core/components/build_text.dart';
import 'package:diplom/presentation/login/login_screen.dart';
import 'package:flutter/material.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: 500,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/frame.png'),

                filterQuality: FilterQuality.high,
              ),
            ),
            child: Center(
              child: Image.asset(
                'assets/peo.png',
                filterQuality: FilterQuality.high,
              ),
            ),
          ),
          BuildText(
            text: 'We are what we do',
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: BuildText(
              textAlign: TextAlign.center,
              text:
                  ' Here you can quickly find:\nbrief Wikipedia info\nhelpful books and resources from Open Library,\nwords with rhymes, antonyms, synonyms, and related meanings,\nYouTube videos on the selected topic.',
              fontSize: 16,
              fontWeight: FontWeight.w300,
              textColor: Colors.black45,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 20.0,
            ),
            child: BuildButton(
              onTap: () {
                // TODO have realise navigate to reg screen
              },
              btnColor: Color(0xff8E97FD),
              text: "Let's start!",
              textSize: 18,
              textFontWeight: FontWeight.bold,
              textColor: Colors.white,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BuildText(
                text: 'LREADY HAVE AN ACCOUNT?',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                textColor: Color(0xffA1A4B2),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: BuildText(
                  text: '\tLOG IN',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  textColor: Color(0xff8E97FD),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
