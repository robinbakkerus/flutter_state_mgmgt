import 'package:flutter/material.dart';

class CardData {
  CardData(this.nr, this.score, this.color, this.isDetail);

  num nr;
  num score;
  Color color;
  bool isDetail;

  @override
  String toString() {
    return 'nr:$nr score:$score  detail:$isDetail  col:$color  hash:$hashCode';
  }

  static CardData clone(CardData cd) {
    return CardData(cd.nr, cd.score, cd.color, cd.isDetail);
  }
}
