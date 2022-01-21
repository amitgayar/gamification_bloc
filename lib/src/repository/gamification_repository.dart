import 'package:gamification_bloc/src/models/campaign_model.dart';

import '../models/gamification_data.dart';
import '../repository/apis.dart';


class GameRepository {
  GameRepository({
    required this.dataConst
});
  final DataConst dataConst;

  final GamificationApiProvider _gameApiProvider = GamificationApiProvider();
  Future<GamificationDataMeta>  getGameData(String? userId) => _gameApiProvider.getGameData(userId, dataConst.baseUrl, testApi: dataConst.testApi);
  Future<GamificationDataMeta> postGameData(Map postData) => _gameApiProvider. postGameEvent(postData, dataConst.baseUrl, testApi: dataConst.testApi );

  Future<CampaignListMeta> fetchCampaignData (String? userId) => _gameApiProvider.fetchCampaign(userId,dataConst.baseUrl, testApi: dataConst.testApi);
}


class DataConst{
  DataConst({
    required this.baseUrl, this.testApi = false
});
  final String baseUrl;
  final bool testApi;
}