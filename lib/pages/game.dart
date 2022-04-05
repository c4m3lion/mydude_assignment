import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mydude_assignment/myLibs/ai.dart';
import 'package:mydude_assignment/myLibs/gamefuncs.dart';
import 'package:rive/rive.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  void updatePage() {
    if (Game.isBot) {
      AI().doMove();
    }
    setState(() {});
  }

  @override
  void initState() {
    Game().initPlayers();
    Game.page = updatePage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: PlayerDeck(0),
              ),
              Expanded(
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(pi),
                  child: PlayerDeck(1),
                ),
              ),
            ],
          ),
          Container(
            color: Game.winner == "" ? null : Colors.grey.withOpacity(0.6),
            alignment: Alignment.center,
            child: Game.winner == ""
                ? null
                : Text(
                    "Winner is ${Game.winner}",
                    style: TextStyle(
                      color: Color.fromARGB(255, 160, 52, 45),
                      fontSize: 50,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          )
        ],
      ),
    );
  }
}

class PlayerDeck extends StatefulWidget {
  final int playerNum;
  const PlayerDeck(this.playerNum);

  @override
  State<PlayerDeck> createState() => _PlayerDeckState();
}

class _PlayerDeckState extends State<PlayerDeck> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: AnimatedRotation(
            alignment: Alignment(0.3, 0.2),
            turns: Game.player[widget.playerNum].loser ? -0.25 : 0,
            duration: Duration(milliseconds: 500),
            child: RiveAnimation.asset(
              'assets/Jeff.riv',
              animations: ['Idle'],
              controllers: [
                Game.player[widget.playerNum].attack1Controller,
                Game.player[widget.playerNum].attack2Controller
              ],
            ),
          ),
        ),
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                //alignment: Alignment.centerLeft,
                children: [
                  Container(
                    width: 150,
                    height: 30,
                    color: Colors.grey,
                  ),
                  Container(
                    width: Game.player[widget.playerNum].helth * 10,
                    height: 30,
                    color: Colors.red,
                  ),
                  Text("Helth"),
                ],
              ),
              Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Container(
                    width: 150,
                    height: 30,
                    color: Colors.grey,
                  ),
                  Container(
                    width: Game.player[widget.playerNum].mana * 10,
                    height: 30,
                    color: Colors.blue,
                  ),
                  Text("Mana"),
                ],
              ),
              const Expanded(child: SizedBox()),
              Container(
                color: Game.player[widget.playerNum].color,
                width: double.infinity,
                height: 100,
                child: (Game.currentPlayer != widget.playerNum) ||
                        (Game.currentPlayer == 1 && Game.isBot)
                    ? null
                    : ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Game.attack(widget.playerNum);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'assets/battle.png',
                                width: 60,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Game.heal(widget.playerNum);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'assets/patch.png',
                                width: 60,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Game.defend(widget.playerNum);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'assets/security.png',
                                width: 60,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Game.skip(widget.playerNum);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'assets/next.png',
                                width: 60,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
