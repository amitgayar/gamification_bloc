class GameUserData {
  String? name;
  String? email;
  String? image;
  String? phoneNumber;
  bool? isPremium;
  String? roomCode;
  String? uid;
  bool? isLoggedIn;

  GameUserData({this.name = '', this.email = '', this.image = '', this.phoneNumber = '', this.isPremium = false, this.roomCode = '', this.uid = '', this.isLoggedIn = false});

  GameUserData.fromJson(Map<dynamic, dynamic> json) {
    name = json['name']??'';
    email = json['email']??'';
    image = json['image']??'';
    phoneNumber = json['phoneNumber']??'';
    isPremium = json['isPremium']??false;
    roomCode = json['roomCode']??'';
    uid = json['uid']??'';
    isLoggedIn = json['isLoggedIn']??false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['image'] = image;
    data['phoneNumber'] = phoneNumber;
    data['isPremium'] = isPremium;
    data['roomCode'] = roomCode;
    data['uid'] = uid;
    data['isLoggedIn'] = isLoggedIn;
    return data;
  }
}