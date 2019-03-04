import 'package:flutter/material.dart';
import 'package:state_mgmt/events/card_events.dart';
import 'card_data.dart';

class CardWg extends StatefulWidget {
  CardWg(this.cardData);

  final CardData cardData;

  @override
  _CardWgState createState() => _CardWgState();
}

//------- 
class _CardWgState extends State<CardWg> with AutomaticKeepAliveClientMixin {
  _CardWgState() {
    CardEvents.onCardSetState(_handleEvent);
  }

  num _score = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 5,
        height: 20,
        color: widget.cardData.color,
        child: Text(_score.toString()),
      ),
      onTap: _onTap,
    );
  }

  void _onTap() {
    CardEvents.fireCardTabbed(widget.cardData);
  }

  void _handleEvent(CardSetStateEvent event) {
    if (mounted) {
      setState(() {
        if (widget.cardData.detail || event.cardData.nr == widget.cardData.nr ) {
          _score = event.cardData.score;
        } 
      });
    }
  }

  @override
  bool get wantKeepAlive => true;
}
