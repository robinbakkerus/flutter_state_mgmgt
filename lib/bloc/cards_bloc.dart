import 'package:flutter/material.dart';
import 'dart:math';
import 'package:state_mgmt/card/card_widget.dart';
import 'package:state_mgmt/card/card_data.dart';
import 'package:state_mgmt/events/card_events.dart';

class CardsBloc {
  final Random _rnd = Random(100);
  List<CardWg> _allCards = List();
  CardWg _detailCard;

  static final CardsBloc _singleton = new CardsBloc._internal();
  factory CardsBloc() => _singleton;

  CardsBloc._internal() {
    _allCards = _buildCards();
    CardEvents.onCardTabbed(_onCardTabbed);
  }
  
  //--- public api
  List<CardWg> fetchAllCards() => _allCards;
  CardWg fetchDetailCard() => _detailCard;
  num totalScore() => _calcTotalScore();

  //--- private --
  List<CardWg> _buildCards() {
    List<CardWg> items = List();
    for (var i = 0; i < 10; i++) {
      Color c = Color.fromRGBO(_color(), _color(), _color(), 10.0);
      items.add(CardWg(CardData(i, 0, c, false)));
    }
    return items;
  }

  int _color() => _rnd.nextInt(255);
  
  void _onCardTabbed(CardEvent event) {
    CardData cd = event.cardData;
    if (cd.detail) {
      _incScore(event.cardData.nr);
    } else {
      CardWg cw = _findCard(event.cardData.nr);
      _detailCard = CardWg(CardData.clone(cw.cardData));
      _detailCard.cardData.detail = true;
    }
    CardEvents.fireUpdateCards(_detailCard.cardData);
  }

  void _incScore(num cardNr) {
    var cw = _findCard(cardNr);
    if (cw != null) {
      cw.cardData.score += 1;
      _detailCard.cardData.score = cw.cardData.score;
    }
  }

  CardWg _findCard(num cardNr) =>
      _allCards.firstWhere((c) => c.cardData.nr == cardNr, orElse: () => null);

  num _calcTotalScore() {
    num sum = 0;
    _allCards.forEach((c) => sum += c.cardData.score);
    return sum;
  }
}
