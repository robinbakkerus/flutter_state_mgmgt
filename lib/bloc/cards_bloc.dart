import 'package:flutter/material.dart';
import 'dart:math';
import 'package:state_mgmt/card/card_widget.dart';
import 'package:state_mgmt/card/card_data.dart';
import 'package:state_mgmt/events/card_events.dart';

class CardsBlocFactory {
  static CardsBlocFactory _singleton = new CardsBlocFactory._internal();
  List<CardBloc> cardBlocs;

  factory CardsBlocFactory() {
    return _singleton;
  }

  CardsBlocFactory._internal() {
    cardBlocs = List();
    cardBlocs.add(_CardsBlocImpl1('Bloc-1'));
    cardBlocs.add(_CardsBlocImpl2('Bloc-2'));
    CardEvents.onActivateBloc(_onActivateBloc);
  }

  void _onActivateBloc(ActivateBlocEvent event) {
    cardBlocs.forEach((cb) {
      (cb.blocName == event.blocName) ? cb.activate() : cb.deActivate();
    });
  }
}

//----------
abstract class CardBloc {
  CardBloc(this.blocName, this.active) {
    CardBloc._allCards = _buildCards();
    CardEvents.fireUpdateCards(
        CardBloc._allCards, CardBloc._detailCard, _calcTotalScore());
    CardEvents.onCardTabbed(_onCardTabbed);
    CardEvents.onCardsSetup(_onCardsSetup);
  }

  static final Random _rnd = Random(100);
  static List<CardWg> _allCards = List();
  static CardWg _detailCard;

  bool active;
  final String blocName;

  // These are abstract methods
  void _incScore(num cardNr);

  /*
   * each time a card is clicked (either a top or detail card), via the eventbus, this function is triggered.
   * based on the 'isDetail' property we know what type was clicked and different actions can be performed.
   */
  void _onCardTabbed(CardEvent event) {
    if (!this.active) return;
    
    CardData cd = event.cardData;
    if (cd.isDetail) {
      _incScore(event.cardData.nr);
    } else {
      CardWg cw = _findCard(event.cardData.nr);
      CardBloc._detailCard = CardWg(CardData.clone(cw.cardData));
      CardBloc._detailCard.cardData.isDetail = true;
    }
    //we trigger 2 events, one for the gui and one for the cards.
    CardEvents.fireUpdateCards(
        CardBloc._allCards, CardBloc._detailCard, _calcTotalScore());
    CardEvents.fireCardSetState(CardBloc._detailCard.cardData);
  }

  void _onCardsSetup(CardSetupEvent event) => _fireCards();

  void activate() => active = true;
  void deActivate() => active = false;

  void _fireCards() => CardEvents.fireUpdateCards(
      CardBloc._allCards, CardBloc._detailCard, _calcTotalScore());

  List<CardWg> _buildCards() {
    List<CardWg> items = List();
    for (var i = 0; i < 10; i++) {
      Color c = Color.fromRGBO(_color(), _color(), _color(), 10.0);
      items.add(CardWg(CardData(i, 0, c, false)));
    }
    return items;
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

//--------
class _CardsBlocImpl1 extends CardBloc {
  _CardsBlocImpl1(String name) : super(name, true);

  @override
  void _incScore(num cardNr) {
    var cw = _findCard(cardNr);
    if (cw != null) {
      cw.cardData.score += 1;
      CardBloc._detailCard.cardData.score = cw.cardData.score;
    }
  }
}

//--------
class _CardsBlocImpl2 extends CardBloc {
  _CardsBlocImpl2(String name) : super(name, false);

  @override
  void _incScore(num cardNr) {
    var cw = _findCard(cardNr);
    if (cw != null) {
      cw.cardData.score += 2;
      CardBloc._detailCard.cardData.score = cw.cardData.score;
    }
  }
}
