import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:gamification_bloc/src/models/campaign_model.dart';
import 'package:gamification_bloc/src/models/user.dart';
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
  final userData = UserData();

  void _onEvent(GameEvent event, Emitter<GameState> emit) {
    if (event is GameLoadingEvent) return _onGameLoading(event, emit);
    if (event is GameLoadedEvent) return _onGameLoad(event, emit);
    if (event is GameFinishedEvent) return _gameFinishedEvent(event, emit);
    if (event is ShowBoardEvent) return _showBoardEvent(event, emit);
    if (event is GameLoginEvent) return _gameLoginEvent(event, emit);
    if (event is GameSharedEvent) return _gameShareEvent(event, emit);
    if (event is LoadCampaign) return _onCampaignLoad(event, emit);

  }

  void _onCampaignLoad(
      LoadCampaign event,
      Emitter<GameState> emit,
      )async{
    logPrint.d("_onCampaignLoad executed");
    var _campaignList = await _gameRepository.fetchCampaignData(userData.uid);
    logPrint.d("_campaignList.isEmpty =  ${_campaignList.campaign!.isEmpty}");

    var _data = state.copyWith();

    emit(GameState.gameLoadedState(campaignList: _campaignList.campaign!, gameData: _data.gameData));
  }





  void _onGameLoading(
      GameLoadingEvent event,
      Emitter<GameState> emit,
      ) async {
    emit( const GameState.loadInProgress());
    var v = state;
    logPrint.d('props = $v');
  }



  void _onGameLoad(
      GameLoadedEvent event,
      Emitter<GameState> emit,
      ) async {
    emit( const GameState.loadInProgress());
    final SharedPreferences prefs = await _prefs;

    var _firstAccessToday = await checkInitialAppOpen();
    final GamificationDataMeta myGame = await _gameRepository.getGameData(prefs.getString('uid'));
    var _campaignList = await _gameRepository.fetchCampaignData(prefs.getString('uid'));

    logPrint.d('_campaignList = $_campaignList, myGame = $myGame');

    var _gameData = myGame.toJson();

    if (_firstAccessToday) {
      // todo:  show message locally
      // todo : first game today
    }
    var _boards = myGame.board;
    Board? _processedBoard;

    if(_boards!.isNotEmpty){
      _processedBoard =  processBoard(_boards[0], prefs) ;
    }

    emit(GameState.gameLoadedState(
      gameData: GamificationDataMeta.fromJson(_gameData),
        boardIndex:0,
      board: _processedBoard,
      campaignList: _campaignList.campaign
    )
    );
  }

  void _showBoardEvent(
      ShowBoardEvent event,
      Emitter<GameState> emit,
      )async{

    logPrint.d('_showMessageEvent');
    final SharedPreferences prefs = await _prefs;

    var _data = state.copyWith();
    var _boards = _data.gameData!.board;
    Board? _processedBoard;

    if(_boards! != [] && event.index! < _boards.length){
      logPrint.d('processBoard called');
      _processedBoard =  processBoard(_boards[event.index!], prefs);
    }

    emit(
        GameState.gameLoadedState(
        boardIndex: event.index,
        gameData: _data.gameData,
          board: _processedBoard,
          campaignList: _data.campaignList
    ));
  }



  void _gameFinishedEvent(
      GameFinishedEvent event,
      Emitter<GameState> emit,
      )async{
    final SharedPreferences prefs = await _prefs;
    // var _data = state.copyWith();
    // var _eventData = _data.gameDa
    // ta!.eventData!.toJson();
    Map _eventData = {};
    _eventData["gameMap"] = event.gameMap;
    _eventData["firstGame"] = await checkInitialPlay();
    Map _new = {
      "eventType": "gameFinish",
      "userId": prefs.getString('uid'),
      "eventData": _eventData,
    };
    // todo : ghghghghghghg store campaign id to DB HIVE and gameMap

    var _newMeta = GamificationDataMeta.fromJson(_new);

    emit(GameState.gameLoadedState(gameData: _newMeta));
    // Todo : loading screen/message

    // adding data in event map
    final GamificationDataMeta _myGame = await _gameRepository.postGameData(_new);
    emit(GameState.gameLoadedState(gameData: _myGame));
  }

  void _gameLoginEvent(
      GameLoginEvent event,
      Emitter<GameState> emit,
      )async{
    final SharedPreferences prefs = await _prefs;
    Map _eventData = {};
    _eventData["firstGame"] = await checkInitialPlay();
    _eventData["email"] = prefs.getString('email');
    _eventData["name"] = prefs.getString('name');
    _eventData["image"] = prefs.getString('photoURL');
    Map _new = {
      "eventType": "login",
      "userId": prefs.getString('uid'),
      "eventData": _eventData,
    };

    final GamificationDataMeta _myGame = await _gameRepository.postGameData(_new);
    emit(GameState.gameLoadedState(gameData: _myGame));
  }

  void _gameShareEvent(
      GameSharedEvent event,
      Emitter<GameState> emit,
      )async{
    final SharedPreferences prefs = await _prefs;
    Map _eventData = {};
    _eventData["firstGame"] = await checkInitialPlay();
    Map _new = {
      "eventType": event.name,
      "userId": prefs.getString('uid'),
    };
    final GamificationDataMeta _myGame = await _gameRepository.postGameData(_new);
    logPrint.d('Game-shared in bloc');
    emit(GameState.gameLoadedState(gameData: _myGame, boardIndex: 0, board: _myGame.board!=null?_myGame.board![0]:null));
  }

  Board? processBoard(Board board, SharedPreferences prefs) {
    logPrint.d('processing Board ');

    if(board.type == 'leaderBoardUpdate'){
        logPrint.d('processBoard board.type = leaderBoardUpdate');

        dynamic playerIndex;
        dynamic playerToEdit;
        var oldPlayer = board.player;
        board.player!.asMap().forEach((key, value) {
          if(
          value.userId == prefs.getString('uid')
          // value.name == prefs.getString('name')
          // todo :  value.userId == prefs.getString('uid')
          ){
            logPrint.d('value.name = ${value.name}');

            playerToEdit = value.toJson();
            playerToEdit["points"] = board.points;
            playerToEdit = Player.fromJson(playerToEdit);
            playerIndex = key;
          }
        });
        board.player!.removeAt(playerIndex);
        board.player!.add(playerToEdit);
        board.player!.sort((a,b) => b.points!.compareTo(a.points!.toInt()));
        logPrint.d('board = ${board.toJson()}');

        var _newUpdatedBoard = board.toJson();
        // todo : selectedPlayer, oldIndex, newIndex, oldPlayer(keep or delete)
        _newUpdatedBoard.addAll({
          "selectedPlayer": prefs.getString('uid'),
          "oldIndex": playerIndex,
          "newIndex": board.player!.indexWhere((e) => e.userId == prefs.getString('uid')),
          "oldPlayer": oldPlayer!.map((e) => e.toJson()).toList(),

        });
        board = Board.fromJson(_newUpdatedBoard);
        logPrint.d('board = ${board.toJson()}');
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


}