part of 'gamification_bloc.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object?> get props => [];
}

class GameLoadingEvent extends GameEvent {
  const GameLoadingEvent();
}
class GameLoadedEvent extends GameEvent {
  const GameLoadedEvent({required this.userId});
  final String userId;
  @override
  List<Object> get props => [];
}

class GameFinishedEvent extends GameEvent {
  const GameFinishedEvent({required this.gameMap, required this.userId});
  final Map<String, dynamic> gameMap;
  final String userId;

  @override
  List<Object> get props => [gameMap, userId];
}


class GameLoginEvent extends GameEvent {
  const GameLoginEvent(this.loginCred);
  final Map<String, dynamic> loginCred;

  @override
  List<Object> get props => [loginCred];
}


class ShowBoardEvent extends GameEvent {
  const ShowBoardEvent({this.index});
  final int? index;


  @override
  List<Object> get props => [index!];
}

class GameSharedEvent extends GameEvent {
  const GameSharedEvent({required this.name, required this.userId});
  final String? name;
  final String userId;

  @override
  List<Object> get props => [name!, userId];
}



class SelectCampaign extends GameEvent{
  const SelectCampaign(this.campaignId);
  final int? campaignId;
  @override
  List<Object?> get props => [campaignId];
}

