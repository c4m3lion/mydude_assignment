import 'package:flutter/material.dart';
import 'package:mydude_assignment/myLibs/gamefuncs.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => {
              Game.isBot = false,
              Navigator.pushNamed(context, '/game'),
            },
            child: Text("Player vs Player"),
          ),
          const SizedBox(
            width: double.infinity,
            height: 30,
          ),
          ElevatedButton(
            onPressed: () => {
              Game.isBot = true,
              Navigator.pushNamed(context, '/game'),
            },
            child: Text("Player vs Bot"),
          ),
        ],
      ),
    );
  }
}
