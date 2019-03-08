import 'package:flutter/material.dart';
import 'package:state_mgmt/bloc/cards_bloc.dart';
import 'package:state_mgmt/card/card_widget.dart';
import 'package:state_mgmt/events/card_events.dart';

void main() {
  
  return runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext ctxt) {
    return new MaterialApp(
      home: new ListDisplay(),
    );
  }
}

class ListDisplay extends StatefulWidget {
  @override
  State createState() => new _ListDisplay();
}

class _ListDisplay extends State<ListDisplay> {
  final TextEditingController eCtrl = new TextEditingController();
  List<CardBloc> _cardBlocs = CardsBlocFactory().cardBlocs;

  num _totalScore = 0;
  List<CardWg> _allCards = List();
  CardWg _detailCard;

  _ListDisplay() {
    CardEvents.onCardsUpdated((e) => _onCardsUpdated(e));
    CardEvents.fireCardSetup();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text("$_totalScore"),
        Divider(),
        Container(
            padding: EdgeInsets.only(top: 10),
            height: 100,
            child: new ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _allCards.length,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                      width: 100,
                      child: StatefulBuilder(builder:
                          (BuildContext context, StateSetter setState) {
                        return _allCards[index];
                      }));
                })),
        Divider(),
        Container(
            height: 200,
            child: _detailCard == null
                ? Text("...")
                : SizedBox(
                    height: 300,
                    width: 300,
                    child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return _detailCard;
                    }))),
        Divider(),
        Container(
            padding: EdgeInsets.only(top: 10),
            height: 50,
            child: new ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _cardBlocs.length,
                itemBuilder: (BuildContext context, int index) {
                  return RaisedButton(
                      child: Text(_cardBlocs[index].blocName),
                      onPressed: () => CardEvents.fireActivateBloc(_cardBlocs[index].blocName),
                      );
                })),
      ],
    );
  }

  void _onCardsUpdated(CardsUpdatedEvent event) {
    setState(() {
      _allCards = event.allCards;
      _detailCard = event.detailCard;
      _totalScore = event.totalScore;
    });
  }
}
