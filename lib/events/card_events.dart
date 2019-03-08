import 'package:event_bus/event_bus.dart';
import 'package:state_mgmt/card/card_data.dart';
import 'package:state_mgmt/card/card_widget.dart';

/*
 * All Card Events are maintainded here.
 */
class CardEvent {
  CardEvent(this.cardData);
  final CardData cardData;
}

class CardTabbedEvent extends CardEvent {
  CardTabbedEvent(CardData card) : super(card);
}

class CardsUpdatedEvent {
  CardsUpdatedEvent(this.allCards, this.detailCard, this.totalScore);
  final List<CardWg> allCards;
  final CardWg detailCard;
  final num totalScore;
}

class CardSetStateEvent extends CardEvent {
  CardSetStateEvent(CardData card) : super(card);
}

class CardSetupEvent {}

class ActivateBlocEvent {
  ActivateBlocEvent(this.blocName);
  final String blocName;
}

class CardEvents {
  static final EventBus _sEventBus = new EventBus();

  // Only needed if clients want all EventBus functionality.
  // static EventBus ebus() => _sEventBus;

  /*
  * The methods below are just convenience shortcuts to make it easier for the client to use.
  */
  static void fireCardTabbed(CardData card) =>
      _sEventBus.fire(new CardTabbedEvent(card));
  static void fireUpdateCards(
          List<CardWg> allCards, CardWg detailCard, num totalScore) =>
      _sEventBus.fire(new CardsUpdatedEvent(allCards, detailCard, totalScore));
  static void fireCardSetState(CardData card) =>
      _sEventBus.fire(new CardSetStateEvent(card));
  static void fireCardSetup() => _sEventBus.fire(new CardSetupEvent());
  static void fireActivateBloc(String blocName) => _sEventBus.fire(new ActivateBlocEvent(blocName));

  static void onCardTabbed(OnCardTabbedFunc func) =>
      _sEventBus.on<CardTabbedEvent>().listen((event) => func(event));
  static void onCardSetState(OnCardSetStateFunc func) =>
      _sEventBus.on<CardSetStateEvent>().listen((event) => func(event));
  static void onCardsUpdated(OnCardsUpdatedFunc func) =>
      _sEventBus.on<CardsUpdatedEvent>().listen((event) => func(event));
  static void onCardsSetup(OnCardsSetupFunc func) =>
      _sEventBus.on<CardSetupEvent>().listen((event) => func(event));
  static void onActivateBloc(OnActivateBlocFunc func) =>
      _sEventBus.on<ActivateBlocEvent>().listen((event) => func(event));      
}

typedef void OnCardTabbedFunc(CardTabbedEvent event);
typedef void OnCardSetStateFunc(CardSetStateEvent event);
typedef void OnCardsUpdatedFunc(CardsUpdatedEvent event);
typedef void OnCardsSetupFunc(CardSetupEvent event);
typedef void OnActivateBlocFunc(ActivateBlocEvent event);
