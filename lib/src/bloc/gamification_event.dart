part of 'gamification_bloc.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object> get props => [];
}

class GameLoadingEvent extends GameEvent {
  const GameLoadingEvent();
}
class GameLoadedEvent extends GameEvent {
  const GameLoadedEvent({this.userId = ""});
  final String userId;
  @override
  List<Object> get props => [];
}

class GameFinishedEvent extends GameEvent {
  const GameFinishedEvent({this.gameMap = const {}});
  final Map<String, dynamic> gameMap;

  @override
  List<Object> get props => [gameMap];
}


class GameLoginEvent extends GameEvent {
  const GameLoginEvent(this.loginCred);
  final Map<String, dynamic> loginCred;

  @override
  List<Object> get props => [loginCred];
}


class ShowMessageEvent extends GameEvent {
  const ShowMessageEvent({this.index});
  final int? index;

  @override
  List<Object> get props => [index!];
}

class GameSharedEvent extends GameEvent {
  const GameSharedEvent();
}
