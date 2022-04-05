import 'dart:math';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class Game {
  static List<Player> player = [];
  static int currentPlayer = 0;

  static late Function page;

  static String winner = "";

  static bool isBot = false;

  static List<Player> getPlayers() {
    return player;
  }

  void initPlayers() {
    print(isBot);
    winner = "";
    player = [
      Player(Colors.blue, "Left Player"),
      Player(Colors.red, "Right Player"),
    ];
    currentPlayer = 0;
    for (int i = 0; i < 2; i++) {
      player[i].attack1Controller = OneShotAnimation(
        'Attack1',
        autoplay: false,
        onStop: () => {},
        onStart: () {},
      );
      player[i].attack2Controller = OneShotAnimation(
        'Attack2',
        autoplay: false,
        onStop: () => {},
        onStart: () {},
      );
    }
  }

  static void attack(int _player) {
    if (_player != currentPlayer) {
      print("This is not your turn!!!");
      return;
    }
    if (player[_player].mana < 3) {
      print("You don't have mana");
      return;
    }
    player[(_player + 1) % 2].getDamage(CardTypes.attackDamage);
    player[_player].attack();
    if (player[(_player + 1) % 2].helth <= 0) {
      Game.winner = player[_player].name;
      player[(_player + 1) % 2].loser = true;
    }

    currentPlayer = (_player + 1) % 2;
    page();
  }

  static void defend(int _player) {
    if (_player != currentPlayer) {
      print("This is not your turn!!!");
      return;
    }

    if (player[_player].mana < 4) {
      print("You don't have mana");
      return;
    }
    player[_player].getShield();

    currentPlayer = (_player + 1) % 2;
    page();
  }

  static void heal(int _player) {
    if (_player != currentPlayer) {
      print("This is not your turn!!!");
      return;
    }

    if (player[_player].mana < 5) {
      print("You don't have mana");
      return;
    }
    player[_player].heal();

    currentPlayer = (_player + 1) % 2;
    page();
  }

  static void skip(int _player) {
    if (_player != currentPlayer) {
      print("This is not your turn!!!");
      return;
    }
    player[_player].skip();

    currentPlayer = (_player + 1) % 2;
    page();
  }
}

class Player {
  Player(this.color, this.name);
  String name = "Left Player";
  int helth = 15;
  int mana = 15;
  bool shield = false;
  bool loser = false;

  late RiveAnimationController attack1Controller;
  late RiveAnimationController attack2Controller;
  Color color = Colors.red;

  void getDamage(int _dmg) {
    if (shield) {
      _dmg -= CardTypes.defenseBlock;
      shield = false;
    }
    helth -= _dmg;
    if (helth <= 0) {
      helth = 0;
    }
  }

  void attack() {
    int _k = randomInt(0, 1);
    mana -= CardTypes.attackMana;
    if (_k == 0) {
      attack1Controller.isActive = true;
    } else {
      attack2Controller.isActive = true;
    }
  }

  void fooAttack() {
    mana -= CardTypes.attackMana;
  }

  void manaCost(int _cost) {
    mana -= _cost;
  }

  void getShield() {
    if (shield) return;
    shield = true;
    mana -= CardTypes.defenseMana;
  }

  void heal() {
    helth += CardTypes.healSize;
    if (helth >= 15) {
      helth = 15;
    }
    mana -= CardTypes.healMana;
  }

  void skip() {
    mana += CardTypes.skipMana;
    if (mana > 15) {
      mana = 15;
    }
  }

  static int randomInt(int min, int max) {
    return Random().nextInt(max - min + 1) + min;
  }
}

class CardTypes {
  static int attackDamage = 3;
  static int attackMana = 3;

  static int defenseMana = 4;
  static int defenseBlock = 2;

  static int healMana = 5;
  static int healSize = 3;

  static int skipMana = 4;
}

enum Abilities { Attack, Defence, Heal, Skip }
