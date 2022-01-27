import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import '../models/campaign_model.dart';
import '../models/user.dart';
import '../repository/gamification_repository.dart';
import '../models/gamification_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/util_functions.dart';

part 'gamification_event.dart';
part 'gamification_state.dart';




class GamificationBloc extends Bloc<GameEvent, GameState> {
  GamificationBloc({GameRepository? gameRepository})
      : _gameRepository = gameRepository!,
        super( const GameState.initial()) {
    on<GameEvent>(_onEvent, transformer: sequential());
  }

  final GameRepository _gameRepository;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void _onEvent(GameEvent event, Emitter<GameState> emit) {
    if (event is GameLoadingEvent) return _onGameLoading(event, emit);
    if (event is GameLoadedEvent) return _onGameLoad(event, emit);
    if (event is GameFinishedEvent) return _gameFinishedEvent(event, emit);
    if (event is CampaignADEvent) return _campaignAdEvent(event, emit);
    if (event is ShowBoardEvent) return _showBoardEvent(event, emit);
    if (event is GameLoginEvent) return _gameLoginEvent(event, emit);
    if (event is GameSharedEvent) return _gameShareEvent(event, emit);
    if (event is SelectCampaign) return _selectCampaignEvent(event, emit);




  }



  void _onGameLoading(
      GameLoadingEvent event,
      Emitter<GameState> emit,
      ) async {
    emit( const GameState.loadInProgress());
  }

  void _selectCampaignEvent(
      SelectCampaign event,
      Emitter<GameState> emit,
      ){
    var _data = state.copyWith();
    emit( GameState.gameLoadedState(
        gameData: _data.gameData,
        campaignList: _data.campaignList,
        campaignId: event.campaignId,
        userData: _data.userData
    ));
  }

  void _onGameLoad(
      GameLoadedEvent event,
      Emitter<GameState> emit,
      ) async {
    logPrint.d('GameLoadedEvent called');

    final GamificationDataMeta myGame = await _gameRepository.getGameData(event.userId);
    final  _campaignList = await _gameRepository.fetchCampaignData(event.userId);

    emit(GameState.gameLoadedState(
      gameData: myGame,
        campaignList: _campaignList.campaign,
      userData: GameUserData()
    )
    );
  }

  void _showBoardEvent(
      ShowBoardEvent event,
      Emitter<GameState> emit,
      )async{
    logPrint.d('next ShowBoardEvent called');

    var _data = state.copyWith();
    var _boards = _data.gameData!.board;
    Board? _processedBoard;

    if(_boards! != [] && event.index! < _boards.length){
      logPrint.d('processBoard called');
      _processedBoard =  processBoard(_boards[event.index!], _data.userData!.uid);
    }


    emit(
        GameState.gameLoadedState(
        boardIndex: event.index,
        gameData: _data.gameData,
          board: _processedBoard,
          campaignList: _data.campaignList,
          userData: _data.userData
    ));
  }



  void _gameFinishedEvent(
      GameFinishedEvent event,
      Emitter<GameState> emit,
      )async{
    logPrint.d("_gameFinishedEvent called with gameMap = ${event.gameMap}");
    var _data = state.copyWith();
    var _userJson = _data.userData!.toJson();
    _userJson.addAll({'uid':event.userId});
    var _user = GameUserData.fromJson(_userJson);
    Map _eventData = {};
    _eventData["gameMap"] = event.gameMap;
    _eventData["campaignId"] = _data.campaignId;
    _eventData["firstGame"] = await checkInitialPlay();
    Map _new = {
      "eventType": "gameFinish",
      "userId": event.userId,
      "eventData": _eventData,
    };
    final GamificationDataMeta _myGame = await _gameRepository.postGameData(_new);
    var _campaignList = await _gameRepository.fetchCampaignData(event.userId);
    var _boards = _myGame.board??[];
    Board? _processedBoard;

    if(_boards.isNotEmpty){
      _processedBoard =  processBoard(_boards[0], event.userId) ;
    }

    emit(GameState.gameLoadedState(gameData: _myGame, board: _processedBoard,
        campaignList: _campaignList.campaign, userData: _user));
  }

  void _campaignAdEvent(
      CampaignADEvent event,
      Emitter<GameState> emit,
      )async{
    logPrint.d("CampaignADEvent called with gameMap = ${event.gameMap}");
    var _data = state.copyWith();
    Map _eventData = {};
    _eventData["gameMap"] = event.gameMap;
    _eventData["campaignId"] = _data.campaignId;
    _eventData["firstGame"] = await checkInitialPlay();
    Map _new = {
      "eventType": "campaignAd",
      "userId": event.userId,
      "eventData": _eventData,
    };
    final GamificationDataMeta _myGame = await _gameRepository.postGameData(_new);
    var _campaignList = await _gameRepository.fetchCampaignData(event.userId);
    var _boards = _myGame.board??[];
    Board? _processedBoard;

    if(_boards.isNotEmpty){
      _processedBoard =  processBoard(_boards[0], event.userId) ;
    }

    emit(GameState.gameLoadedState(gameData: _myGame, board: _processedBoard,
        campaignList: _campaignList.campaign, userData: _data.userData));
  }

  void _gameLoginEvent(
      GameLoginEvent event,
      Emitter<GameState> emit,
      )async{
    // todo : login cred storing
    var _data = state.copyWith();
    Map _eventData = {};
    _eventData["firstGame"] = await checkInitialPlay();
    _eventData["email"] = event.loginCred['email'];
    _eventData["name"] = event.loginCred['name'];
    _eventData["image"] = event.loginCred['image'];
    Map _new = {
      "eventType": "login",
      "userId": event.loginCred['uid'],
      "eventData": _eventData,
    };


    /// first login detection
    GameUserData? _user;
    GamificationDataMeta? _myGame;
    if(_data.userData!.uid != ''){
      _user = GameUserData.fromJson(event.loginCred);
      _myGame = await _gameRepository.postGameData(_new);
    }
    else{
      _user = _data.userData;
      _myGame = _data.gameData;
    }

   /// fetch campaigns
    var _campaignList = await _gameRepository.fetchCampaignData(_data.userData!.uid);

    emit(GameState.gameLoadedState(gameData: _myGame, board: (_myGame!.board!.isEmpty || _myGame.board == null)?null:_myGame.board![0],
        campaignList: _campaignList.campaign, userData: _user));
  }

  void _gameShareEvent(
      GameSharedEvent event,
      Emitter<GameState> emit,
      )async{
    var _data = state.copyWith();
    Map _eventData = {};
    Map _new = {
      "eventType": event.name,
      "userId": event.userId,
      "eventData" : _eventData
    };
    final GamificationDataMeta _myGame = await _gameRepository.postGameData(_new);
    logPrint.d('Game-shared in bloc ${_myGame.board}');
    emit(GameState.gameLoadedState(gameData: _myGame, board: (_myGame.board!.isEmpty || _myGame.board == null)?null:_myGame.board![0],
                             campaignList: _data.campaignList, campaignId: _data.campaignId, userData: _data.userData
    ));
  }






  /// utility functions :
  Board? processBoard(Board? board, String? uid) {
    logPrint.d('processing Board with uid : $uid');

    if(board!.type == 'leaderBoardUpdate'){
        logPrint.d('processing Board type = leaderBoardUpdate');
        // todo : sort this function
        dynamic _playerIndex = -1;
        dynamic _playerToEdit = <String, dynamic>{};
        board.player?.asMap().forEach((key, value) {
          if(value.userId == uid){
            _playerToEdit = value.toJson();
            _playerToEdit["points"] = board!.points;
            _playerIndex = key;
          }
        });
        if(_playerIndex != -1){
          board.player!.removeAt(_playerIndex);
          board.player!.add(Player.fromJson(_playerToEdit));
        }

        board.player?.sort((a,b) => b.points!.compareTo(a.points!.toInt()));
        var _newRank = board.player?.indexWhere((element) => element.userId == uid);
        if(_newRank != -1) {
          _playerToEdit = board.player?.removeAt(_newRank!);
        }


        // logPrint.d('board = ${board.toJson()}');

        var _newUpdatedBoard = board.toJson();
        _newUpdatedBoard.addAll({
          "selectedPlayer": uid,
          "oldIndex": _playerIndex,
          "newIndex": _newRank,
          "oldPlayer": board.player?.map((e) => e.toJson()).toList(),
          "selectedPlayerData" : _playerToEdit.toJson()
        });
        board = Board.fromJson(_newUpdatedBoard);
        logPrint.d('_newUpdatedBoard = $_newUpdatedBoard');
    }
    return board;
  }

  Future<bool> checkInitialAppOpen() async {
    final SharedPreferences prefs = await _prefs;
    final int initialDayOpen = (prefs.getInt('initialDayOpen') ?? DateTime.now().day-1) ;
    if(initialDayOpen - DateTime.now().day != 0){
      await prefs.setInt('initialDayOpen', DateTime.now().day).then((bool success) => true);
      logPrint.d('First visit of the Day - sharedPref[initialDayOpen] = $initialDayOpen');
      return true;
    }
    else {
      logPrint.d('You have opened the App earlier today - sharedPref[initialDayOpen] = $initialDayOpen');
      return false;
    }
  }

  Future<bool> checkInitialPlay() async {
    final SharedPreferences prefs = await _prefs;
    final int initialPlay = (prefs.getInt('initialPlay') ?? DateTime.now().day-1) ;
    if(initialPlay - DateTime.now().day != 0){
      await prefs.setInt('initialPlay', DateTime.now().day).then((bool success) => true);
      logPrint.d('Initial game of the day');
      return true;
    }
    else {
      logPrint.d('This is not your first game');
      return false;
    }
  }
  // todo : checkInitialAppOpen and checkInitialPlay -- where to put in POST gameData API


}