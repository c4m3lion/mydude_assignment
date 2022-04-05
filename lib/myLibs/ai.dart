import 'package:mydude_assignment/myLibs/gamefuncs.dart';

class AI {
  void doMove() async {
    if (Game.currentPlayer == 0 ||
        Game.player[1].helth <= 0 ||
        Game.player[0].helth <= 0) return;
    int mxPoint = -999;

    Abilities move = Abilities.Attack;

    if (Game.player[1].mana >= CardTypes.attackMana) {
      List<fooPlayer> _foo = [
        fooPlayer(
            Game.player[0].helth, Game.player[0].mana, Game.player[0].shield),
        fooPlayer(
            Game.player[1].helth, Game.player[1].mana, Game.player[1].shield)
      ];
      _foo[0].getDamage();
      _foo[1].attack();
      var copy = _foo.map((item) => fooPlayer.clone(item)).toList();

      int mx = 0;
      try {
        mx = minimax(copy, false);
      } catch (e) {
        print("ESKIP");
      }
      if (mx > mxPoint) {
        mxPoint = mx;
        move = Abilities.Attack;
      }
    }

    if (Game.player[1].mana >= CardTypes.defenseMana) {
      List<fooPlayer> _foo = [
        fooPlayer(
            Game.player[0].helth, Game.player[0].mana, Game.player[0].shield),
        fooPlayer(
            Game.player[1].helth, Game.player[1].mana, Game.player[1].shield)
      ];
      _foo[1].defence();
      var copy = _foo.map((item) => fooPlayer.clone(item)).toList();

      int mx = minimax(copy, false);

      if (mx > mxPoint) {
        mxPoint = mx;
        move = Abilities.Defence;
      }
    }

    if (Game.player[1].mana >= CardTypes.healMana) {
      List<fooPlayer> _foo = [
        fooPlayer(
            Game.player[0].helth, Game.player[0].mana, Game.player[0].shield),
        fooPlayer(
            Game.player[1].helth, Game.player[1].mana, Game.player[1].shield)
      ];
      _foo[1].heal();
      var copy = _foo.map((item) => fooPlayer.clone(item)).toList();

      int mx = minimax(copy, false);

      if (mx > mxPoint) {
        mxPoint = mx;
        move = Abilities.Heal;
      }
    }

    if (Game.player[1].mana >= 0) {
      List<fooPlayer> _foo = [
        fooPlayer(
            Game.player[0].helth, Game.player[0].mana, Game.player[0].shield),
        fooPlayer(
            Game.player[1].helth, Game.player[1].mana, Game.player[1].shield)
      ];
      _foo[1].skip();
      var copy = _foo.map((item) => fooPlayer.clone(item)).toList();
      int mx = 0;
      mx = minimax(copy, false);

      if (mx > mxPoint) {
        mxPoint = mx;
        move = Abilities.Skip;
      }
    }

    await Future.delayed(Duration(seconds: 1));
    print(move.toString());
    switch (move) {
      case Abilities.Attack:
        Game.attack(1);
        break;
      case Abilities.Defence:
        Game.defend(1);
        break;
      case Abilities.Heal:
        Game.heal(1);
        break;
      case Abilities.Skip:
        Game.skip(1);
        break;
    }
    Game.skip(1);
  }

  ///MainAI
  int minimax(List<fooPlayer> foo, bool maximizePlayer) {
    if (foo[0].hp <= 0) return 1;
    if (foo[1].hp <= 0) return -1;

    if (maximizePlayer) {
      int bestScore = -999;

      if (foo[1].mana >= CardTypes.attackMana) {
        List<fooPlayer> _foo =
            foo.map((item) => fooPlayer.clone(item)).toList();
        _foo[0].getDamage();
        _foo[1].attack();
        int mx = minimax(_foo, false);

        if (mx > bestScore) {
          bestScore = mx;
        }
      }

      if (foo[1].mana >= CardTypes.defenseMana) {
        List<fooPlayer> _foo =
            foo.map((item) => fooPlayer.clone(item)).toList();
        _foo[1].defence();

        int mx = minimax(_foo, false);

        if (mx > bestScore) {
          bestScore = mx;
        }
      }

      if (foo[1].mana >= CardTypes.healMana) {
        List<fooPlayer> _foo =
            foo.map((item) => fooPlayer.clone(item)).toList();
        _foo[1].heal();

        int mx = minimax(_foo, false);

        if (mx > bestScore) {
          bestScore = mx;
        }
      }
      return bestScore;
    } else {
      int bestScore = 999;

      if (foo[0].mana >= CardTypes.attackMana) {
        List<fooPlayer> _foo =
            foo.map((item) => fooPlayer.clone(item)).toList();
        _foo[1].getDamage();
        _foo[0].attack();

        int mx = minimax(_foo, true);

        if (mx < bestScore) {
          bestScore = mx;
        }
      }

      if (foo[0].mana >= CardTypes.defenseMana) {
        List<fooPlayer> _foo =
            foo.map((item) => fooPlayer.clone(item)).toList();
        _foo[0].defence();

        int mx = minimax(_foo, true);

        if (mx < bestScore) {
          bestScore = mx;
        }
      }

      if (foo[0].mana >= CardTypes.healMana) {
        List<fooPlayer> _foo =
            foo.map((item) => fooPlayer.clone(item)).toList();
        _foo[0].heal();

        int mx = minimax(_foo, true);

        if (mx < bestScore) {
          bestScore = mx;
        }
      }
      return bestScore;
    }
  }
}

class fooPlayer {
  fooPlayer(this.hp, this.mana, this.isDefence);
  int hp = 15;
  int mana = 15;
  bool isDefence = false;

  void getDamage() {
    hp -= CardTypes.attackDamage;
    if (isDefence) {
      hp += CardTypes.defenseBlock;
      isDefence = false;
    }
  }

  void attack() {
    mana -= CardTypes.attackMana;
  }

  void heal() {
    hp += CardTypes.healSize;
    if (hp > 15) {
      hp = 15;
    }
    mana -= CardTypes.healMana;
  }

  void defence() {
    isDefence = true;
    mana -= CardTypes.defenseMana;
  }

  void skip() {
    mana += CardTypes.skipMana;
    if (mana > 15) {
      mana = 15;
    }
  }

  fooPlayer.clone(fooPlayer source)
      : this.hp = source.hp,
        this.mana = source.mana,
        this.isDefence = source.isDefence;
}
