import 'package:flutter/material.dart';
import 'package:mydude_assignment/pages/game.dart';
import 'package:mydude_assignment/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyDude Game',
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
              side: BorderSide(
                width: 0.0,
              ),
            ),
          ),
        ),
        hoverColor: Colors.cyan,
        buttonTheme: ButtonThemeData(
          hoverColor: Colors.cyan,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(
              width: 0.0,
            ),
          ),
        ),
        brightness: Brightness.dark,
        primarySwatch: Colors.orange,
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => HomePage(),
        '/game': (context) => GamePage(),
      },
    );
  }
}
