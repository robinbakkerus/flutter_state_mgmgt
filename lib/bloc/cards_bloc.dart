import 'package:flutter/material.dart';
import 'dart:math';
import 'package:state_mgmt/card/card_widget.dart';
import 'package:state_mgmt/card/card_data.dart';
import 'package:state_mgmt/events/card_events.dart';

/**
 * Imo it is good practise to provide an interface for your BloC, even though currently there is only one implementation.
 * This abstract class interface also takes care that there is only 1 instance.
 */
abstract class CardsBloc {
  List<CardWg> fetchAllCards();
  CardWg fetchDetailCard();
  num totalScore();

  static CardsBloc _singleton;

  factory CardsBloc() {
    if (_singleton==null) {
      _singleton = _CardsBlocImpl();
    }
    return _singleton;
  }
}

/**
 * The implementation. No special extends needed apart the interface from above.
 */
class _CardsBlocImpl implements CardsBloc {
  _CardsBlocImpl() {
    _allCards = _buildCards(); 
    CardEvents.onCardTabbed(_onCardTabbed);
  }

  final Random _rnd = Random(100);
  List<CardWg> _allCards = List();
  CardWg _detailCard;

  
  //--- public api
  List<CardWg> fetchAllCards() => _allCards;
  CardWg fetchDetailCard() => _detailCard;
  num totalScore() => _calcTotalScore();

  //--- private methods 
  List<CardWg> _buildCards() {
    List<CardWg> items = List();
    for (var i = 0; i < 10; i++) {
      Color c = Color.fromRGBO(_color(), _color(), _color(), 10.0);
      items.add(CardWg(CardData(i, 0, c, false)));
    }
    return items;
  }

  /**
   * each time a card is clicked (either a top or detail card), via the eventbus, this function is triggered.
   * based on the 'isDetail' property we know what type was clicked and different actions can be performed.
   */
  void _onCardTabbed(CardEvent event) {
    CardData cd = event.cardData;
    if (cd.isDetail) {
      _incScore(event.cardData.nr);
    } else {
      CardWg cw = _findCard(event.cardData.nr);
      _detailCard = CardWg(CardData.clone(cw.cardData));
      _detailCard.cardData.isDetail = true;
    }
    //we trigger 2 events, one for the gui and one for the cards.
    CardEvents.fireUpdateCards(_detailCard.cardData);
    CardEvents.fireCardSetState(_detailCard.cardData);
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

  int _color() => _rnd.nextInt(255);
}
