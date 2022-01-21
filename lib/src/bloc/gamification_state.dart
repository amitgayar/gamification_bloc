part of 'gamification_bloc.dart';

class GameState extends Equatable {
  const GameState._(
      {this.gameData, this.boardIndex = 0, this.board, this.campaignList, this.campaignId});

  const GameState.initial() : this._();

  const GameState.loadInProgress() : this._();

  const GameState.gameLoadedState(
      {GamificationDataMeta? gameData, int? boardIndex = -1, Board? board,
        List<Campaign>? campaignList, int? campaignId = -1
      })
      : this._(gameData: gameData, boardIndex: boardIndex, board: board,
       campaignList:campaignList, campaignId:campaignId);

  // const GameState.showMessageState(
  //     {int? boardIndex = 0,
  //     GamificationDataMeta? gameData,
  //       Board? board
  //     })
  //     : this._(
  //     boardIndex: boardIndex, gameData: gameData, board: board);


  GameState copyWith(
      {GamificationDataMeta? gameData,
      int? boardIndex,
        List<Campaign>? campaignList, int? campaignId
      }) {
    return GameState._(
        gameData: gameData ?? this.gameData,
      boardIndex: boardIndex ?? this.boardIndex,
         campaignList: campaignList??this.campaignList, campaignId: campaignId??this.campaignId);
  }

  final GamificationDataMeta? gameData;
  final int? boardIndex;
  final Board? board;
  final List<Campaign>? campaignList;
  final int? campaignId;

  bool get isComplete => ([gameData].isNotEmpty);

  @override
  List get props => [gameData, boardIndex, board, campaignList, campaignId];
}
