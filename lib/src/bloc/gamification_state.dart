part of 'gamification_bloc.dart';

class GameState extends Equatable {
  const GameState._(
      {this.gameData, this.board = const <Board>[]});

  const GameState.initial() : this._();

  const GameState.loadInProgress() : this._();

  const GameState.gameLoadedState(
      {GamificationDataMeta? gameData, List<Board>? board = const <Board>[]})
      : this._(gameData: gameData, board: board);

  const GameState.showMessageState(
      {List<Board>? board = const [],
      GamificationDataMeta? gameData,
      })
      : this._(
            board: board, gameData: gameData);

  const GameState.screenSelectState(
      {
      List<Board>? board = const [],
      GamificationDataMeta? gameData})
      : this._(
            board: board, gameData: gameData);

  const GameState.showLeaderBoardState() : this._();

  GameState copyWith(
      {GamificationDataMeta? gameData,
      List<Board>? board,
      }) {
    return GameState._(
        gameData: gameData ?? this.gameData,
        board: board ?? this.board,
    );
  }

  final GamificationDataMeta? gameData;
  final List<Board>? board;

  bool get isComplete => ([gameData].isNotEmpty);

  @override
  List get props => [gameData, board];
}
