import 'dart:async';
import 'dart:math';

import 'package:author_info_app/views/screens/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Myapp(),
    theme: ThemeData(useMaterial3: true),
    routes: {
      // "/":(context) =>Myapp(),
      'Home_Page': (context) => Home_Page()
    },
  ));
}

class Myapp extends StatefulWidget {
  const Myapp({Key? key}) : super(key: key);

  @override
  State<Myapp> createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 4), () {
      Navigator.of(context).pushReplacementNamed("Home_Page");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen.shade200,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 2 * pi),
              duration: Duration(seconds: 2),
              curve: Curves.fastOutSlowIn,
              builder: (context, double angle, _) {
                return Transform.rotate(
                  angle: angle,
                  child: Text(
                    "Author's",
                    style: GoogleFonts.aclonica(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        letterSpacing: 4),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
