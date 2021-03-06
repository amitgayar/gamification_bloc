import 'package:gamification_bloc/src/models/campaign_model.dart';
import 'package:gamification_bloc/src/models/data_const_http.dart';

import '../models/gamification_data.dart';
import '../repository/apis.dart';

class GameRepository {
  GameRepository({required this.dataConst});

  final DataConst dataConst;

  final GamificationApiProvider _gameApiProvider = GamificationApiProvider();

  Future<GamificationDataMeta> getGameData(String? userId, {testEvent = ''}) => _gameApiProvider
      .getGameData(userId, dataConst.baseUrl, testApi: dataConst.testApi, testEvent : testEvent);

  Future<GamificationDataMeta> postGameData(Map postData) => _gameApiProvider
      .postGameEvent(postData, dataConst.baseUrl, testApi: dataConst.testApi);

  Future<CampaignListMeta> fetchCampaignData(String? userId) => _gameApiProvider
      .fetchCampaign(userId, dataConst.baseUrl, testApi: dataConst.testApi);
}
