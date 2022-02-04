part of 'gamification_bloc.dart';

class GameState extends Equatable {
  const GameState._(
      {this.gameData,
      this.boardIndex = 0,
      this.board,
      this.campaignList,
      this.campaignId,
      this.userData,
      this.isCampaignLoaded = true,
      this.isGameLoaded = true});

  const GameState.initial() : this._();

  const GameState.loadInProgress() : this._();

  const GameState.gameLoadedState(
      {GamificationDataMeta? gameData,
      int? boardIndex = 0,
      Board? board,
      List<Campaign>? campaignList,
      int? campaignId = -1,
      GameUserData? userData,
      bool? isGameLoaded,
      bool? isCampaignLoaded})
      : this._(
            gameData: gameData,
            boardIndex: boardIndex,
            board: board,
            campaignList: campaignList,
            campaignId: campaignId,
            userData: userData,
            isGameLoaded: isGameLoaded,
            isCampaignLoaded: isCampaignLoaded);

  GameState copyWith({
    GamificationDataMeta? gameData,
    int? boardIndex = 0,
    Board? board,
    List<Campaign>? campaignList,
    int? campaignId,
    GameUserData? userData,
    bool? isGameLoaded,
    bool? isCampaignLoaded,
  }) {
    return GameState._(
        gameData: gameData ?? this.gameData,
        boardIndex: boardIndex,
        board: board ?? this.board,
        campaignList: campaignList ?? this.campaignList,
        campaignId: campaignId ?? this.campaignId,
        userData: userData ?? this.userData,
        isGameLoaded: isGameLoaded ?? this.isGameLoaded,
        isCampaignLoaded: isCampaignLoaded ?? this.isCampaignLoaded);
  }

  final GamificationDataMeta? gameData;
  final int? boardIndex;
  final Board? board;
  final List<Campaign>? campaignList;
  final int? campaignId;
  final GameUserData? userData;
  final bool? isGameLoaded;
  final bool? isCampaignLoaded;

  bool get isComplete => ([gameData].isNotEmpty);

  @override
  List get props => [
        gameData,
        boardIndex,
        board,
        campaignList,
        campaignId,
        userData,
        isGameLoaded,
        isCampaignLoaded
      ];
}
