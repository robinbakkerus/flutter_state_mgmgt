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
  final CardsBloc _cardsBloc = CardsBloc();
  num _totalScore = 0;

  _ListDisplay() {
    CardEvents.onCardTabbed((e) => _fetchTotalScore());
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _fetchTotalScore();
  // }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text("$_totalScore"),
        Divider(),
        Container(
            padding: EdgeInsets.only(top: 10),
            height: 150,
            child: new ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _getAllCards().length,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                      width: 100,
                      child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                        return _getAllCards()[index];
                      }));
                })),
        Divider(),
        Container(
            height: 300,
            child: _getDetailCard() == null
                ? Text("...")
                : SizedBox(
                    height: 300,
                    width: 300,
                    child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return _getDetailCard();
                    })))
      ],
    );
  }

  void _fetchTotalScore() {
    setState(() {
      _totalScore = _cardsBloc.totalScore();
    });
    if (_getDetailCard() != null) {
      CardEvents.fireCardSetState(_getDetailCard().cardData);
    }
  }

  List<CardWg> _getAllCards() => _cardsBloc.fetchAllCards();
  CardWg _getDetailCard() => _cardsBloc.fetchDetailCard();
}
