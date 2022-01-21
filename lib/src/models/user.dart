class UserData {
  String? name;
  String? email;
  String? image;
  String? phoneNumber;
  bool? isPremium;
  String? roomCode;
  String? uid;
  bool? isLoggedIn;

  UserData({name = '', email = '', image = '', phoneNumber = '', isPremium = false, roomCode = '', uid = '', isLoggedIn = false});

  UserData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    image = json['photoURL'];
    phoneNumber = json['phoneNumber'];
    isPremium = json['isPremium'];
    roomCode = json['roomCode'];
    uid = json['uid'];
    isLoggedIn = json['isLoggedIn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['photoURL'] = image;
    data['phoneNumber'] = phoneNumber;
    data['isPremium'] = isPremium;
    data['roomCode'] = roomCode;
    data['uid'] = uid;
    data['isLoggedIn'] = isLoggedIn;
    return data;
  }
}