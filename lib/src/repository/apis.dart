import "package:http/http.dart" as http;
import "../models/gamification_data.dart";
import "dart:convert";

// const String baseUrl = 'http://sudoku.playappster.com/';

Map<String, dynamic> gamificationDataInit = {
  "hint": 3,
  "life": 3
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
  }
};

Map<String, dynamic> gamificationDataReceive = {
  "board": [
    {
      // "type": "leaderBoardUpdate",
      // "type": "normal",
      "type": "normal",
      "title": "Level 1 completed",
      "subtitle": "Awarded 40 gems. You stand second",
      "image": "gif1.com",
      "table": {
        "points": 45,
        "gems": 12
      }
    },
    {
      "type": "normal",
      "title": "Level 2 completed",
      "subtitle": "Awarded 140 gems. You stand second",
      "image": "gif1.com",
      "table": {"points": 45, "gems": 12, "ingots": 12, "boost": "combo"}
    },
    {
      "type": "leaderBoardUpdate",
      "title": "Title 2",
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
          "name": "Amit Gayar",
          "points": 743,
          "image": "https://source.unsplash.com/random/200x200?sig=2",
          "userId": "Amit Gayar"
        },
        {
          "name": "KLM",
          "points": 741,
          "image": "image.com",
          "userId": "ABC12"
        },
        {
          "name": "LMN",
          "points": 735,
          "image": "https://picsum.photos/250?image=9",
          "userId": "LMN12"
        },
        {
          "name": "MNO",
          "points": 725,
          "image": "image.com",
          "userId": "MNO12"
        },
        {
          "name": "NOP",
          "points": 715,
          "image": "image.com",
          "userId": "NOP12"
        }
      ],
      "points": 30 // todo: new points for leaderBoardUpdate animation
    }
  ]
};
Map<String, dynamic> gamificationDataDemo = {
  "hint": 3,
  "life": 3,
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
      "title": "Level 1 completed",
      "subtitle": "Awarded 40 gems. You stand second",
      "image": "gif1.com",
      "table": {
        "points": 45,
        "gems": 12
      }
    },
    {
      "type": "normal",
      "title": "Level 2 completed",
      "subtitle": "Awarded 140 gems. You stand second",
      "image": "gif1.com",
      "table": {"points": 45, "gems": 12, "ingots": 12, "boost": "combo"}
    },
    {
      "type": "leaderBoardUpdate",
      "title": "Title 2",
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
          "name": "Amit Gayar",
          "points": 743,
          "image": "https://source.unsplash.com/random/200x200?sig=2",
          "userId": "Amit Gayar"
        },
        {
          "name": "KLM",
          "points": 741,
          "image": "image.com",
          "userId": "ABC12"
        },
        {
          "name": "LMN",
          "points": 735,
          "image": "https://picsum.photos/250?image=9",
          "userId": "LMN12"
        },
        {
          "name": "MNO",
          "points": 725,
          "image": "image.com",
          "userId": "MNO12"
        },
        {
          "name": "NOP",
          "points": 715,
          "image": "image.com",
          "userId": "NOP12"
        }
      ],
      "points": 1400
    }
  ]
};

Map<String, dynamic> gamificationLoginDataReceive = {
  "board": [
    {
      "type": "normal",
      "title": "Login Completed",
      "subtitle": "Awarded 20 gems",
      "image": "gif1.com",
    }
  ]
};
Map<String, dynamic> gamificationShareDataReceive = {
  "board": [
    {
      "type": "normal",
      "title": "App shared",
      "subtitle": "Awarded 120 gems",
      "image": "gif1.com",
    }
  ]
};

class GamificationApiProvider {
  final successCode = 200;

  Future<GamificationDataMeta> getGameData(String? userId, String baseUrl, {testApi=false}) async {
    if (testApi) return GamificationDataMeta.fromJson(gamificationDataReceive);
    final response = await http.get(Uri.parse(baseUrl + "/gameData/$userId"));
    return parseResponse(response);
  }

  Future<GamificationDataMeta> postGameEvent(
      Map postData, String baseUrl, {testApi=false}) async {
    if (testApi) {
      if (postData['eventType'] == "login"){
        return GamificationDataMeta.fromJson(gamificationLoginDataReceive);
      }
      if (postData['eventType'] == "gameFinish"){
        return GamificationDataMeta.fromJson(gamificationDataReceive);

      }
      if (postData['eventType'] == "share"){
        return GamificationDataMeta.fromJson(gamificationShareDataReceive);
      }
      else{
        return GamificationDataMeta.fromJson(gamificationDataReceive);
      }
    }



    final response = await http.post(
      Uri.parse(baseUrl + "/gameData/event"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(postData),
    );
    return parseResponse(response);
  }

  // RESPONSE PARSERS

  GamificationDataMeta parseResponse(http.Response response) {
    final responseString = jsonDecode(response.body);

    if (response.statusCode == successCode) {
      return GamificationDataMeta.fromJson(responseString);
    } else {
      throw Exception('failed to load game');
    }
  }
}
