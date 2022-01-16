import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import '../repository/gamification_repository.dart';
import '../models/gamification_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

part 'gamification_event.dart';
part 'gamification_state.dart';


Logger logBloc = Logger();


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
    if (event is ShowMessageEvent) return _showMessageEvent(event, emit);
    if (event is GameLoginEvent) return _gameLoginEvent(event, emit);
    if (event is GameSharedEvent) return _gameShareEvent(event, emit);
  }

  void _onGameLoading(
      GameLoadingEvent event,
      Emitter<GameState> emit,
      ) async {
    emit( const GameState.loadInProgress());
    var v = state;
    logBloc.d('props = $v');
  }

  void _onGameLoad(
      GameLoadedEvent event,
      Emitter<GameState> emit,
      ) async {
    emit( const GameState.loadInProgress());
    final SharedPreferences prefs = await _prefs;

    var _firstAccessToday = await checkInitialAppOpen();
    final GamificationDataMeta myGame = await _gameRepository.getGameData(prefs.getString('uid'));
    var _gameData = myGame.toJson();

    if (_firstAccessToday) {
      // Todo:  show message locally
    }
    // todo: mercy points for game failure
    // todo : first game today


    logBloc.d("state.props = ${state.props}");
    emit(GameState.gameLoadedState(
      gameData: GamificationDataMeta.fromJson(_gameData),
        board:myGame.board)
    );
    logBloc.d("state.props after emitting= ${state.props}");
  }

  void _showMessageEvent(
      ShowMessageEvent event,
      Emitter<GameState> emit,
      )async{
    final SharedPreferences prefs = await _prefs;

    var _data = state.copyWith();
    var _updatedBoard = event.messages;
    for (var element in event.messages!) {
          if(element.type == 'leaderBoardUpdate'){
            var boardIndex = event.messages!.indexOf(element);
                  var _temp = element.toJson();
                  _temp['selectedPlayer'] = prefs.getString('uid');
                  var updatedPlayers = playersRankwise(_temp['player'], _updatedBoard![boardIndex].points, prefs.getString('uid'));
                  _temp['player'] = updatedPlayers;
                  _updatedBoard[boardIndex] = Board.fromJson(_temp);
          }
    }



    emit(
        GameState.showMessageState(
        board: _updatedBoard,
      gameData: _data.gameData,
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
    var _newMeta = GamificationDataMeta.fromJson(_new);

    emit(GameState.gameLoadedState(gameData: _newMeta, board: const []));
    // Todo : loading screen/message

    // adding data in event map
    final GamificationDataMeta _myGame = await _gameRepository.postGameData(_new);
    emit(GameState.gameLoadedState(gameData: _myGame, board: _myGame.board));
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
    emit(GameState.gameLoadedState(gameData: _myGame, board: _myGame.board));
  }

  void _gameShareEvent(
      GameSharedEvent event,
      Emitter<GameState> emit,
      )async{
    final SharedPreferences prefs = await _prefs;
    Map _eventData = {};
    _eventData["firstGame"] = await checkInitialPlay();
    Map _new = {
      "eventType": "share",
      "userId": prefs.getString('uid'),
    };
    final GamificationDataMeta _myGame = await _gameRepository.postGameData(_new);
    logBloc.d('Game-shared');
    emit(GameState.gameLoadedState(gameData: _myGame, board: _myGame.board));
  }

  Future<bool> checkInitialAppOpen() async {
    final SharedPreferences prefs = await _prefs;
    final int initialDayOpen = (prefs.getInt('initialDayOpen') ?? DateTime.now().day-1) ;
    if(initialDayOpen - DateTime.now().day != 0){
      await prefs.setInt('initialDayOpen', DateTime.now().day).then((bool success) => true);
      logBloc.d('First visit of the Day - sharedPref[initialDayOpen] = $initialDayOpen');
      return true;
    }
    else {
      logBloc.d('You have opened the App earlier today - sharedPref[initialDayOpen] = $initialDayOpen');
      return false;
    }
  }

  Future<bool> checkInitialPlay() async {
    final SharedPreferences prefs = await _prefs;
    final int initialPlay = (prefs.getInt('initialPlay') ?? DateTime.now().day-1) ;
    if(initialPlay - DateTime.now().day != 0){
      await prefs.setInt('initialPlay', DateTime.now().day).then((bool success) => true);
      logBloc.d('Initial game of the day');
      return true;
    }
    else {
      logBloc.d('This is not your first game');
      return false;
    }
  }

   playersRankwise(List players, int? points, String? uid){
    var index = 0;
    for (var player in players){
      if(player['points'] < points){
        index = players.indexOf(player);
      }
    }
    return players;
  }


}