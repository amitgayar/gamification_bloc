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
        super(const GameState.initial()) {
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
    logPrint.e("game bloc event ");

    emit(const GameState.loadInProgress());
  }

  void _selectCampaignEvent(
    SelectCampaign event,
    Emitter<GameState> emit,
  ) {
    logPrint.e("game bloc event ");

    logPrint.w("SelectCampaignEvent campaignId = ${event.campaignId}");
    emit(state.copyWith(
      campaignId: event.campaignId,
    ));
  }

  void _onGameLoad(
    GameLoadedEvent event,
    Emitter<GameState> emit,
  ) async {
    logPrint.e("game bloc event ");

    logPrint.v('GameLoadedEvent called');

    emit(const GameState.gameLoadedState(
        isGameLoaded: false, isCampaignLoaded: false));
    if ((event.userId).isNotEmpty) {
      GamificationDataMeta _myGame = GamificationDataMeta.fromJson({});
      var _appOpen = await checkInitialAppOpen();
      if(_appOpen){
        Map _new = {
          "eventType": _appOpen,
          "userId": event.userId,
        };

        _myGame =
        await _gameRepository.postGameData(_new);
        emit(state.copyWith(
          gameData: _myGame,
          board: getBoard(_myGame, 0),
          boardIndex: 0,
        ));
      }

      var _gameInitData = await _gameRepository.getGameData(event.userId);
      var _campaignList = await _gameRepository.fetchCampaignData(event.userId);

      emit(state.copyWith(
          gameData: _myGame.copyWith(gameMap: _gameInitData.gameMap),
          campaignList: _campaignList.campaign,
          isGameLoaded: true,
          isCampaignLoaded: true));

    } else {
      logPrint.w("userId is empty i.e. Not allowed to send request");

      /// updating with default values
      GamificationDataMeta? _data = GamificationDataMeta.fromJson({});
      emit(state.copyWith(
          isGameLoaded: true, isCampaignLoaded: true, gameData: _data));
    }
  }

  void _showBoardEvent(
    ShowBoardEvent event,
    Emitter<GameState> emit,
  ) async {
    logPrint.e("game bloc event ");

    logPrint.v('next ShowBoardEvent called');
    var _data = state.copyWith();
    emit(state.copyWith(
      boardIndex: event.index,
      board: getBoard(_data.gameData!, event.index),
    ));
  }

  void _gameFinishedEvent(
    GameFinishedEvent event,
    Emitter<GameState> emit,
  ) async {
    logPrint.e("game bloc event ");

    logPrint.v("_gameFinishedEvent called with gameMap = ${event.gameMap}");
    var _data = state.copyWith();
    Map _eventData = {};
    _eventData["gameMap"] = event.gameMap;
    _eventData["campaignId"] = _data.campaignId;
    _eventData["firstGame"] = await checkInitialPlay();
    Map _new = {
      "eventType": "gameFinish",
      "userId": event.userId,
      "eventData": _eventData,
    };
    emit(state.copyWith(isGameLoaded: false, isCampaignLoaded: false));

    final GamificationDataMeta _myGame =
        await _gameRepository.postGameData(_new);
    emit(state.copyWith(
      gameData: _myGame,
      board: getBoard(_myGame, 0),
    ));
    var _gameInitData = await _gameRepository.getGameData(event.userId);
    var _campaignList = await _gameRepository.fetchCampaignData(event.userId);

    emit(state.copyWith(
        gameData: _myGame.copyWith(gameMap: _gameInitData.gameMap),
        campaignList: _campaignList.campaign,
        isGameLoaded: true,
        isCampaignLoaded: true));
  }

  void _campaignAdEvent(
    CampaignADEvent event,
    Emitter<GameState> emit,
  ) async {
    logPrint.e("game bloc event ");

    logPrint.d("CampaignAdEvent called with adWatched map = ${event.data}");
    var _data = state.copyWith();
    Map _eventData = {};
    _eventData["adWatched"] = event.data['adWatched'];
    _eventData["campaignId"] = event.data['campaignId'];
    Map _new = {
      "eventType": "campaignAd",
      "userId": event.userId,
      "eventData": _eventData,
    };
    final GamificationDataMeta _myGame =
        await _gameRepository.postGameData(_new);
    final _campaignList = await _gameRepository.fetchCampaignData(event.userId);
    var _board = getBoard(_myGame, 0);
    emit(state.copyWith(
        gameData: _myGame,
        board: _board,
        campaignList: _campaignList.campaign,
        userData: _data.userData));
  }

  void _gameLoginEvent(
    GameLoginEvent event,
    Emitter<GameState> emit,
  ) async {
    logPrint.e("game bloc event ");

    logPrint.d("game login event  = ${event.loginCred}");
    Map _eventData = {};
    _eventData["email"] = event.loginCred['email'];
    _eventData["name"] = event.loginCred['name'];
    _eventData["image"] = event.loginCred['image'];
    Map _postData = {
      "eventType": "login",
      "userId": event.loginCred['uid'],
      "eventData": _eventData,
    };

    logPrint.d("game login event  isCampaignLoaded: false, isGameLoaded:false");

    /// loading state
    emit(state.copyWith(
        isGameLoaded: false,
        isCampaignLoaded: false,
        userData: GameUserData.fromJson(event.loginCred)));

    /// posting loginData
    GamificationDataMeta? _loginRes =
        await _gameRepository.postGameData(_postData);

    logPrint.d("game login event  responseCode =  ${_loginRes.responseCode}");

    logPrint.d(
        'state.copyWith in login with board = ${getBoard(_loginRes, 0)?.toJson()}');

    emit(state.copyWith(
        gameData: _loginRes,
        board: getBoard(_loginRes, 0),
        isGameLoaded: false,
        isCampaignLoaded: false));

    GamificationDataMeta? _myInitGame =
        await _gameRepository.getGameData(event.loginCred['uid']);
    var _campaignList =
        await _gameRepository.fetchCampaignData(event.loginCred['uid']);
    emit(state.copyWith(
        gameData: _myInitGame.copyWith(board: _loginRes.board),
        campaignList: _campaignList.campaign,
        isGameLoaded: _myInitGame.responseCode == 200,
        isCampaignLoaded: _campaignList.responseCode == 200));
  }

  void _gameShareEvent(
    GameSharedEvent event,
    Emitter<GameState> emit,
  ) async {
    logPrint.e("game bloc event ");

    var _data = state.copyWith();
    Map _eventData = {};
    Map _new = {
      "eventType": event.name,
      "userId": event.userId,
      "eventData": _eventData
    };
    final GamificationDataMeta _myGame =
        await _gameRepository.postGameData(_new);
    logPrint.d('Game-shared in bloc ${_myGame.board}');
    // GamificationDataMeta? _myInitGame =
    //     await _gameRepository.getGameData(event.userId);
    // var _campaignList = await _gameRepository.fetchCampaignData(event.userId);

    emit(GameState.gameLoadedState(
        gameData: _myGame,
        board: getBoard(_myGame, 0),
        campaignList: _data.campaignList,
        campaignId: _data.campaignId,
        userData: _data.userData));
  }

  ///
  ///
  ///
  ///
  ///
  /// utility functions :
  ///
  ///
  ///
  ///
  ///

  Future<bool> checkInitialAppOpen() async {
    final SharedPreferences prefs = await _prefs;
    final int initialDayOpen =
        (prefs.getInt('initialDayOpen') ?? DateTime.now().day - 1);
    if (initialDayOpen - DateTime.now().day != 0) {
      await prefs
          .setInt('initialDayOpen', DateTime.now().day)
          .then((bool success) => true);
      logPrint.d(
          'First visit of the Day - sharedPref[initialDayOpen] = $initialDayOpen');
      return true;
    } else {
      logPrint.d(
          'You have opened the App earlier today - sharedPref[initialDayOpen] = $initialDayOpen');
      return false;
    }
  }

  Future<bool> checkInitialPlay() async {
    final SharedPreferences prefs = await _prefs;
    final int initialPlay =
        (prefs.getInt('initialPlay') ?? DateTime.now().day - 1);
    if (initialPlay - DateTime.now().day != 0) {
      await prefs
          .setInt('initialPlay', DateTime.now().day)
          .then((bool success) => true);
      logPrint.d('Initial game of the day');
      return true;
    } else {
      logPrint.d('This is not your first game');
      return false;
    }
  }

  getBoard(myGame, index) {
    logPrint.v("getting board");
    var _boards = myGame.board ?? [];
    Board? _processedBoard = Board.fromJson({});
    if (_boards.isNotEmpty && index < _boards.length) {
      logPrint.v("board exists");
      _processedBoard = _boards[index];
    } else {
      logPrint.v("No board found");
    }
    return _processedBoard;
  }

// todo : checkInitialAppOpen and checkInitialPlay -- where to put in POST gameData API

}
