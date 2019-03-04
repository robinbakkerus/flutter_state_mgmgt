import 'package:flutter/material.dart';

class CardData {
  CardData(this.nr, this.score, this.color, this.detail);

  num nr;
  num score;
  Color color;
  bool detail;

  @override
  String toString() {
    return 'nr:$nr score:$score  detail:$detail  col:$color  hash:$hashCode';
  }

  static CardData clone(CardData cd) {
    return CardData(cd.nr, cd.score, cd.color, cd.detail);
  }
}
