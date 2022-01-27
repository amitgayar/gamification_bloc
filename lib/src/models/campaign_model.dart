class CampaignListMeta {
  List<Campaign>? campaign;

  CampaignListMeta({
    this.campaign,
  });

  CampaignListMeta.fromJson(Map<String, dynamic> json) {
    campaign = (json['campaign'] as List?)?.map((dynamic e) => Campaign.fromJson(e as Map<String,dynamic>)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['campaign'] = campaign?.map((e) => e.toJson()).toList();
    return json;
  }
}

class Campaign {
  int? id;
  String? name;
  String? desc;
  String? image;
  Map? gameMap;
  bool? isAd;
  int? adCount;

  Campaign({
    this.id,
    this.name,
    this.desc,
    this.image,
    this.gameMap,
    this.isAd,
    this.adCount,
  });

  Campaign.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    adCount = json['adCount'] as int?;
    isAd = json['isAd'] as bool?;
    name = json['name'] as String?;
    desc = json['desc'] as String?;
    image = json['image'] as String?;
    gameMap = json['gameMap'] as Map<String,dynamic>?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['name'] = name;
    json['desc'] = desc;
    json['image'] = image;
    json['adCount'] = adCount;
    json['isAd'] = isAd;
    json['gameMap'] = gameMap;
    return json;
  }
}
