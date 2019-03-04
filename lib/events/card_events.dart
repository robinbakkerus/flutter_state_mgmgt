import 'package:event_bus/event_bus.dart';
import 'package:state_mgmt/card/card_data.dart';

/**
 * All Card Events are maintainded here.
 */
class CardEvent {
  CardEvent(this.cardData);
  final CardData cardData;
}

class CardTabbedEvent extends CardEvent {
  CardTabbedEvent(CardData card) : super(card);
}

class CardsUpdatedEvent extends CardEvent {
  CardsUpdatedEvent(CardData card) : super(card);
}

class CardSetStateEvent extends CardEvent {
  CardSetStateEvent(CardData card) : super(card);
}

class CardEvents {
  static final EventBus _sEventBus = new EventBus();

  // Only needed if clients want all EventBus functionality.
  // static EventBus ebus() => _sEventBus;

  /**
 * The methods below are just convenience shortcuts to make it easier for the client to use.
 */
  static void fireCardTabbed(CardData card) =>
      _sEventBus.fire(new CardTabbedEvent(card));
  static void fireUpdateCards(CardData card) =>
      _sEventBus.fire(new CardsUpdatedEvent(card));
  static void fireCardSetState(CardData card) =>
      _sEventBus.fire(new CardSetStateEvent(card));
  static void onCardTabbed(OnCardTabbedFunc func) =>
      _sEventBus.on<CardTabbedEvent>().listen((event) => func(event));
  static void onCardSetState(OnCardSetStateFunc func) =>
      _sEventBus.on<CardSetStateEvent>().listen((event) => func(event));
}

typedef void OnCardTabbedFunc(CardTabbedEvent event);
typedef void OnCardSetStateFunc(CardSetStateEvent event);
