import 'dart:async';

import 'package:gamification_bloc/gamification_bloc.dart';
import 'package:gamification_bloc/src/models/campaign_model.dart';
import 'package:gamification_bloc/src/utils/util_functions.dart';
import "package:http/http.dart" as http;
import "../models/gamification_data.dart";
import "dart:convert";

Map<String, dynamic> gameResult = {
  "eventType": "gameFinish",
  "userId": "dWCkqd8GGYbmzyxc6nETI6U7sbs1",
  "eventData": {
    "firstGame": false,
    "gameMap": {
      "level": 1,
      "campaignId": 1,
      "datetime": "2021-12-11 07:54:16.084",
      "timezone": "UTC",
      "result": "success",
      "time": 600,
      "hint": 3,
      "life": 3,
      "puzzle": [
        -1,
        -1,
        -1,
        -1,
        4,
        5,
        -1,
        -1,
        9,
        -1,
        -1,
        4,
        -1,
        -1,
        8,
        -1,
        2,
        3,
        -1,
        -1,
        -1,
        -1,
        -1,
        -1,
        -1,
        -1,
        -1,
        -1,
        1,
        -1,
        3,
        -1,
        -1,
        -1,
        9,
        -1,
        -1,
        7,
        8,
        -1,
        -1,
        -1,
        -1,
        4,
        6,
        -1,
        9,
        -1,
        -1,
        2,
        -1,
        -1,
        -1,
        -1,
        -1,
        -1,
        -1,
        4,
        -1,
        2,
        -1,
        6,
        -1,
        -1,
        -1,
        -1,
        -1,
        -1,
        6,
        -1,
        7,
        -1,
        9,
        -1,
        7,
        5,
        -1,
        1,
        -1,
        -1,
        -1
      ]
    }
  }
};
Map<String, dynamic> gamificationDataInit = {
  "responseCode": 200,
  "gameMap": {"hint": 1, "life": 1}
};
Map<String, dynamic> gameDataRestartInit = {
  "responseCode": 200,
  "gameMap": {"hint": 179, "life": 189}
};

Map<String, dynamic> gamificationDataSend = {
  // "eventType": "firstOpen",// todo : ask?
  // "eventType": "share",
  // "eventType": "referral",
  // "eventType": "gameFinish",
  // "eventType": "login",
  "eventType": "login",
  "userId": "CUo8yIA6HDTvzfwUrQAQVhGoXtp2",
  "eventData": {
    "email": "tim@gmail.com",
    "name": "Tim",
    "image": "image.com",
    "gameMap": {
      "level": 1,
      "dateTime": "2021-12-11 07:54:16.084",
      "timeZone": "UTC",
      "result": 1, // SUCCESS
      // "result": 0,  // FAIL
      "time": "0",
      "hint": 3,
      "life": 3,
      "puzzle": []
    }
  }
};

Map<String, dynamic> gamificationDataReceive = {
  "board": [
    {
      // "type": "leaderBoardUpdate",
      // "type": "normal",
      "type": "normal",
      "name": "Level 1 completed",
      "desc": "Awarded 40 gems. You stand second",
      "image": "gif1.com",
      "share": "normal share message",
      "table": {"points": 45, "gems": 12}
    },
    {
      "type": "normal",
      "name": "Level 2 completed",
      "desc": "Awarded 140 gems. You stand second",
      "image": "gif1.com",
      "table": {"points": 45, "gems": 12, "ingots": 12, "boost": "combo"}
    },
    {
      "type": "leaderBoardUpdate",
      "name": "Title 2",
      "share": "leader share message",
      "player": [
        {
          "name": "ABC",
          "points": 1345,
          "image": "https://source.unsplash.com/random/200x200?sig=1",
          "userId": "ABC12"
        },
        {
          "name": "Mon",
          "points": 745,
          "image": "https://source.unsplash.com/random/200x200?sig=3",
          "userId": "Mon"
        },
        {
          "name": "Man",
          "points": 744,
          "image": "https://source.unsplash.com/random/200x200?sig=4",
          "userId": "Man"
        },
        {"name": "KLM", "points": 741, "image": "image.com", "userId": "ABC12"},
        {
          "name": "LMN",
          "points": 735,
          "image": "https://picsum.photos/250?image=9",
          "userId": "LMN12"
        },
        {"name": "MNO", "points": 725, "image": "image.com", "userId": "MNO12"},
        {"name": "NOP", "points": 715, "image": "image.com", "userId": "NOP12"},
        {"name": "OPQ", "points": 615, "image": "image.com", "userId": "OPQ12"},
        {"name": "PQR", "points": 605, "image": "image.com", "userId": "PQR12"},
        {
          "name": "Amit",
          "points": 535,
          "image": "https://source.unsplash.com/random/200x200?sig=2",
          "userId": "CUo8yIA6HDTvzfwUrQAQVhGoXtp2"
        },
        {"name": "QRS", "points": 515, "image": "image.com", "userId": "QRS12"},
      ],
      "points": 1000
    }
  ]
};
Map<String, dynamic> gameRestartReceive = {
  "board": [
    {
      "type": "normal",
      "name": "Game Restarted",
      "image": "gif1.com",
      "share": "normal share message"
    }
  ]
};
Map<String, dynamic> gamificationDataJsonDummy = {
  "board": [
    {
      "type": "normal",
      "name": "Error!!",
      "image": "gif1.com",
    },
  ]
};
Map<String, dynamic> gamificationDataDemo = {
  "gameMap": {"hint": 3, "life": 3},
  "eventType": "login",
  "userId": "CUo8yIA6HDTvzfwUrQAQVhGoXtp2",
  "eventData": {
    "email": "tim@gmail.com",
    "name": "Tim",
    "image": "image.com",
    "firstGame": true,
    "gameMap": {
      "level": 1,
      "dateTime": "2021-12-11 07:54:16.084",
      "timeZone": "UTC",
      "result": 1, // SUCCESS
      // "result": 0,  // FAIL
      "time": "0",
      "hint": 3,
      "life": 3,
      "puzzle": []
    }
  },
  "board": [
    {
      "type": "normal",
      "name": "Level 1 completed",
      "desc": "Awarded 40 gems. You stand second",
      "image": "gif1.com",
      "table": {"points": 45, "gems": 12}
    },
    {
      "type": "normal",
      "name": "Level 2 completed",
      "desc": "Awarded 140 gems. You stand second",
      "image": "gif1.com",
      "table": {"points": 45, "gems": 12, "ingots": 12, "boost": "combo"}
    },
    {
      "type": "leaderBoardUpdate",
      "name": "Title 2",
      "player": [
        {
          "name": "ABC",
          "points": 1345,
          "image": "https://source.unsplash.com/random/200x200?sig=1",
          "userId": "ABC12"
        },
        {
          "name": "Mohit Bagga",
          "points": 745,
          "image": "https://source.unsplash.com/random/200x200?sig=3",
          "userId": "Mohit Bagga"
        },
        {
          "name": "Manav Garg",
          "points": 744,
          "image": "https://source.unsplash.com/random/200x200?sig=4",
          "userId": "Manav Garg"
        },
        {
          "name": "Amit",
          "points": 743,
          "image": "https://source.unsplash.com/random/200x200?sig=2",
          "userId": "Amit"
        },
        {"name": "KLM", "points": 741, "image": "image.com", "userId": "ABC12"},
        {
          "name": "LMN",
          "points": 735,
          "image": "https://picsum.photos/250?image=9",
          "userId": "LMN12"
        },
        {"name": "MNO", "points": 725, "image": "image.com", "userId": "MNO12"},
        {"name": "NOP", "points": 715, "image": "image.com", "userId": "NOP12"}
      ],
      "points": 1400
    }
  ]
};

Map<String, dynamic> gamificationLoginDataReceive = {
  "responseCode": 200,
  "board": [
    {
      "type": "normal",
      "name": "Login Completed",
      "desc": "Awarded 20 gems",
      "image": "gif1.com",
    }
  ]
};
Map<String, dynamic> gamificationShareDataReceive = {
  "board": [
    {
      "type": "normal",
      "name": "App shared",
      "desc": "Awarded 120 gems",
      "image": "gif1.com",
    }
  ]
};
Map<String, dynamic> gamificationRateAppDataReceive = {
  "board": [
    {
      "type": "normal",
      "name": "App got rated",
      "desc": "Awarded 120 gems",
      "image": "gif1.com",
    }
  ]
};
Map<String, dynamic> gamificationCampaignDataReceive = {
  "responseCode": 200,
  "board": [
    {
      "type": "normal",
      "name": "ad campaign success",
      "desc": "Awarded 120 gems",
      "image": "gif1.com",
    }
  ]
};

Map<String, dynamic> campaignJson = {
  "campaign": [
    {
      "id": 0,
      "name": "Daily Challenge",
      "desc":
          "daily challenge for progressing daily challenge for progressing daily challenge for progressing ",
      "image": "https://source.unsplash.com/random/200x200?sig=1",
      "gameMap": {
        "hint": 2,
        "life": 1,
      }
    },
    {
      "id": 1,
      "name": "Practice",
      "desc":
          "Practice for progressing Practice for progressing Practice for progressing Practice for progressing ",
      "image": "https://source.unsplash.com/random/200x200?sig=2",
      "gameMap": {"hint": 3, "life": 3, "level": 0}
    },
    {
      "id": 2,
      "name": "Unlimited",
      "desc": "Unlimited for progressing",
      "image": "https://source.unsplash.com/random/200x200?sig=3",
      "gameMap": {"hint": 4, "life": 4, "level": 2, "pencil": 0}
    },
    {
      "id": 3,
      "name": "Weekly Challenge",
      "desc": "Weekly challenge for progressing",
      "image": "https://source.unsplash.com/random/200x200?sig=4",
      "gameMap": {"hint": 5, "level": 5, "pencil": 0}
    },
    {
      "id": 4,
      "name": "Time Bound",
      "desc": "Complete with in this time bound",
      "image": "https://source.unsplash.com/random/200x200?sig=5",
      "gameMap": {
        "hint": 6,
        "life": 6,
        "time": 10
      }
    },
    {
      "id": 5,
      "isAd": true,
      "adCount": 2,
      "name": "Ad Benefits",
      "desc": "Watch ad to judge to get more hints",
      "image": "https://source.unsplash.com/random/200x200?sig=5"
    }
  ]
};
Map<String, dynamic> campaignJsonDummy = {
  "campaign": [
    {
      "id": 0,
      "name": "Daily Challenge",
      "desc":
          "daily challenge for progressing daily challenge for progressing daily challenge for progressing ",
      "image": "https://source.unsplash.com/random/200x200?sig=1",
      "gameMap": {
        "hint": 4,
        "life": 4,
        "level": 0
        // "level": 0,1,2,3  (int value [0,1,2,3])
      }
    },
    {
      "id": 1,
      "name": "Practice",
      "desc":
          "Practice for progressing Practice for progressing Practice for progressing Practice for progressing ",
      "image": "https://source.unsplash.com/random/200x200?sig=2",
      "gameMap": {"hint": 10000, "life": 10000, "level": 0}
    },
    {
      "id": 2,
      "name": "Unlimited",
      "desc": "Unlimited for progressing",
      "image": "https://source.unsplash.com/random/200x200?sig=3",
      "gameMap": {"hint": 14, "life": 14, "level": 2}
    },
    {
      "id": 3,
      "name": "Weekly Challenge",
      "desc": "Weekly challenge for progressing",
      "image": "https://source.unsplash.com/random/200x200?sig=4",
      "gameMap": {"hint": 4, "life": 4, "level": 3}
    },
    {
      "id": 4,
      "name": "Monthly Challenge",
      "desc": "daily challenge for progressing",
      "image": "https://source.unsplash.com/random/200x200?sig=5",
      "gameMap": {"hint": 4, "life": 4, "level": 1}
    }
  ]
};

class GamificationApiProvider {
  final successCode = 200;

  Future<GamificationDataMeta> getGameData(String? userId, String baseUrl,
      {testApi = false, testEvent = ''}) async {
    if (testApi) {
      if (testEvent == 'restart') {
        logPrint.d('testApi : gameDataInit  - $gameDataRestartInit');

        return GamificationDataMeta.fromJson(gameDataRestartInit);
      }
      logPrint.d('testApi :  gameDataInit  - $gamificationDataInit');

      return GamificationDataMeta.fromJson(gamificationDataInit);
    }
    var _url = baseUrl + "/gameData/$userId";
    logPrint.d("fetching GameInitData from URL- $_url");
    http.Response _response;
    try {
      _response =
          await http.get(Uri.parse(_url)).timeout(const Duration(seconds: 10));
      return GamificationDataMeta.fromJson(
          {"gameMap": parseResponse(_response)});
    } on TimeoutException catch (e) {
      logPrint.w('Timeout in fetching GameData : $e');
      return GamificationDataMeta.fromJson({});
    } on Error catch (e) {
      logPrint.w('Error in fetching GameData: $e');
      return GamificationDataMeta.fromJson({});
    }
  }

  Future<GamificationDataMeta> postGameEvent(Map postData, String baseUrl,
      {testApi = false}) async {
    if (testApi) {
      switch (postData['eventType']) {
        case "login":
          logPrint.d('testApi : login event  - $gamificationLoginDataReceive');
          return GamificationDataMeta.fromJson(gamificationLoginDataReceive);
        case "gameFinish":
          if (postData['eventData']['gameMap']['result'] == 'restart') {
            logPrint.d('testApi : gameFinish event  - $gameRestartReceive');
            return GamificationDataMeta.fromJson(gameRestartReceive);
          }
          logPrint.d('testApi : gameFinish event  - $gamificationDataReceive');
          return GamificationDataMeta.fromJson(gamificationDataReceive);
        case "share":
          logPrint
              .d('testApi : gameShared event  - $gamificationShareDataReceive');
          return GamificationDataMeta.fromJson(gamificationShareDataReceive);
        case "rateApp":
          logPrint
              .d('testApi : gameShared event  - $gamificationRateAppDataReceive');
          return GamificationDataMeta.fromJson(gamificationRateAppDataReceive);
        case "campaignAd":
          logPrint.d(
              'testApi : campaignAd event  - $gamificationCampaignDataReceive');
          return GamificationDataMeta.fromJson(gamificationCampaignDataReceive);
        default:
          logPrint
              .w('testApi : unknown? event -gamificationDataReceive returned');
          return GamificationDataMeta.fromJson({});
      }
    }

    // todo:  post url type?
    dynamic _url = baseUrl + "/gameData/event?type=" + postData["eventType"];
    // dynamic _url = baseUrl + "/gameData/event";

    logPrint.d("posting event with data- $postData and url : $_url");

    final response = await http.post(
      Uri.parse(_url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(postData),
    );
    return GamificationDataMeta.fromJson(parseResponse(response));
  }

  Future<CampaignListMeta> fetchCampaign(String? userId, String baseUrl,
      {testApi = false}) async {
    if (testApi) {
      return CampaignListMeta.fromJson(campaignJson);
    }
    String _url = baseUrl + "/gameData/campaign/$userId";
    logPrint.d("fetching campaign from URL- $_url");

    http.Response _response;
    try {
      _response =
          await http.get(Uri.parse(_url)).timeout(const Duration(seconds: 10));
      return CampaignListMeta.fromJson(parseResponse(_response));
    } on TimeoutException catch (e) {
      logPrint.w('Timeout in fetching campaign : $e');
      return CampaignListMeta.fromJson(campaignJsonDummy);
    } on Error catch (e) {
      logPrint.w('Error in fetching campaign: $e');
      return CampaignListMeta.fromJson(campaignJsonDummy);
    }
  }

  // RESPONSE PARSERS

  Map<String, dynamic> parseResponse(http.Response response) {
    final responseString = jsonDecode(response.body);
    if (response.statusCode == successCode) {
      logPrint.d('responseString from API : $responseString');
      return responseString;
    } else {
      // throw Exception('failed to fetch data with response.statusCode = ${response.statusCode}');
      logPrint.w(
          'failed to fetch data with response.statusCode = ${response.statusCode}');
      return {"responseCode": response.statusCode};
    }
  }
}
