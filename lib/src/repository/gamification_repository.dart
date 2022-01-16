import '../models/gamification_data.dart';
import '../repository/apis.dart';


class GameRepository {
  GameRepository({
    required this.dataConst
});
  final DataConst dataConst;

  final GamificationApiProvider _gameApiProvider = GamificationApiProvider();
  Future<GamificationDataMeta>  getGameData(String? userId) => _gameApiProvider.getGameData(userId, dataConst.baseUrl, testApi: dataConst.testApi);
  Future<GamificationDataMeta> postGameData(Map eventData) => _gameApiProvider. postGameEvent(eventData, dataConst.baseUrl, testApi: dataConst.testApi );
}


class DataConst{
  DataConst({
    required this.baseUrl, this.testApi = false
});
  final String baseUrl;
  final bool testApi;
}