part of 'gamification_bloc.dart';

class GameState extends Equatable {
  const GameState._(
      {this.gameData, this.boardIndex = 0, this.board});

  const GameState.initial() : this._();

  const GameState.loadInProgress() : this._();

  const GameState.gameLoadedState(
      {GamificationDataMeta? gameData, int? boardIndex = -1, Board? board})
      : this._(gameData: gameData, boardIndex: boardIndex, board: board);

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
      }) {
    return GameState._(
        gameData: gameData ?? this.gameData,
      boardIndex: boardIndex ?? this.boardIndex,
    );
  }

  final GamificationDataMeta? gameData;
  final int? boardIndex;
  final Board? board;

  bool get isComplete => ([gameData].isNotEmpty);

  @override
  List get props => [gameData, boardIndex, board];
}
