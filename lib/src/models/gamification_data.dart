class GamificationDataMeta {
  // String? eventType;
  // String? userId;
  // EventData? eventData;
  int? responseCode;
  List<Board>? board;
  Map<String, dynamic>? gameMap;

  GamificationDataMeta({
    // this.eventType,
    // this.userId,
    // this.eventData,
    this.responseCode,
    this.board,
    this.gameMap,
  });

  GamificationDataMeta? copyWith(
      {int? responseCode, List<Board>? board, Map<String, dynamic>? gameMap}) {
    return GamificationDataMeta(
        responseCode: responseCode ?? this.responseCode,
        board: board ?? this.board,
        gameMap: gameMap ?? this.gameMap);
  }

  GamificationDataMeta.fromJson(Map<dynamic, dynamic> json) {
    // eventType = json['eventType'] as String?;
    // userId = json['userId'] as String?;
    // eventData = (json['eventData'] as Map<String,dynamic>?) != null ? EventData.fromJson(json['eventData'] as Map<String,dynamic>) : null;
    responseCode = json['responseCode'] as int?;
    board = (json['board'] as List?)
        ?.map((dynamic e) => Board.fromJson(e as Map<String, dynamic>))
        .toList();
    gameMap = (json['gameMap']) != null
        ? (json['gameMap'] as Map<String, dynamic>?)
        : <String, dynamic>{};
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    // json['eventType'] = eventType;
    // json['userId'] = userId;
    // json['eventData'] = eventData?.toJson();
    json['responseCode'] = responseCode;
    json['board'] = board?.map((e) => e.toJson()).toList();
    json['gameMap'] = gameMap;
    return json;
  }
}

class EventData {
  String? email;
  String? name;
  String? image;
  bool? firstGame;
  Map<String, dynamic>? gameMap;

  EventData({
    this.email,
    this.name,
    this.image,
    this.firstGame,
    this.gameMap,
  });

  EventData.fromJson(Map<String, dynamic> json) {
    email = json['email'] as String?;
    name = json['name'] as String?;
    image = json['image'] as String?;
    firstGame = json['firstGame'] as bool?;
    gameMap = json['gameMap'] as Map<String, dynamic>?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['email'] = email;
    json['name'] = name;
    json['image'] = image;
    json['firstGame'] = firstGame;
    json['gameMap'] = gameMap;
    return json;
  }
}

class Board {
  String? type;
  String? title;
  String? subtitle;
  String? image;
  String? share;
  Map? table;
  List<Player>? player;
  String? selectedPlayer;
  int? points;
  int? oldIndex;
  int? newIndex;
  List<Player>? oldPlayer;

  Board({
    this.type,
    this.title,
    this.subtitle,
    this.image,
    this.share,
    this.table,
    this.player,
    this.selectedPlayer,
    this.points,
    this.oldIndex,
    this.newIndex,
    this.oldPlayer,
  });

  Board.fromJson(Map<String, dynamic> json) {
    type = json['type'] as String?;
    title = json['name'] ?? '';
    subtitle = json['desc'] ?? '';
    image = json['image'] ?? '';
    share = json['share'] as String?;
    table = json['table'] as Map<String, dynamic>?;
    player = json['player'] == null
        ? []
        : (json['player'] as List?)
            ?.map((dynamic e) => Player.fromJson(e as Map<String, dynamic>))
            .toList();
    selectedPlayer = json['selectedPlayer'] ?? '';
    points = json['points'] as int?;
    oldIndex = json['oldIndex'] as int?;
    newIndex = json['newIndex'] as int?;
    oldPlayer = json['oldPlayer'] == null
        ? []
        : (json['oldPlayer'] as List?)
            ?.map((dynamic e) => Player.fromJson(e as Map<String, dynamic>))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['type'] = type;
    json['name'] = title;
    json['desc'] = subtitle;
    json['image'] = image;
    json['share'] = share;
    json['table'] = table;
    json['player'] = player?.map((e) => e.toJson()).toList();
    json['selectedPlayer'] = selectedPlayer;
    json['points'] = points;
    json['oldIndex'] = oldIndex;
    json['newIndex'] = newIndex;
    json['oldPlayer'] = oldPlayer?.map((e) => e.toJson()).toList();
    return json;
  }
}

class Player {
  String? name;
  int? points;
  String? image;
  String? userId;

  Player({
    this.name,
    this.points,
    this.image,
    this.userId,
  });

  Player.fromJson(Map<String, dynamic> json) {
    name = json['name'] as String?;
    points = json['points'] as int?;
    image = json['image'] as String?;
    userId = json['userId'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['name'] = name;
    json['points'] = points;
    json['image'] = image;
    json['userId'] = userId;
    return json;
  }

  Player copyWith({points}) {
    return Player(name: name, points: points, image: image, userId: userId);
  }
}
