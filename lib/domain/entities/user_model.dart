class UserModel {
   String? uid;
  String? profileImage;
  String? name;
 double? lat;
 double? long; 
 String? address;
 String? phone;
  String? email;
 String? gender;
  // String? city;
String? deviceToken;
 String? lastActive;
  UserModel({
  required this.uid,
 required   this.profileImage,
   required this.name,
  required  this.phone,
  this.lat,
  this.long,
 // required this.serviceId,
  required  this.email,
  required  this.gender,
  // required  this.city,
  required this.deviceToken,
  required this.lastActive
  });

  
  Map<String, dynamic> toMap(UserModel user) {
    var data = Map<String, dynamic>();
    data['uid'] = user.uid;
    data['profileImage'] = user.profileImage;
    data['name'] = user.name;
    data['lat'] = user.lat;
    data['long'] = user.long;
   data['address'] = user.address;
    data['phone'] = user.phone;
    data['email'] = user.email;
    data['gender'] = user.gender;
    // data['city'] = user.city;
     data['deviceToken'] = user.deviceToken;
     data['lastActive'] = user.lastActive;
    
    return data;
  }

  
  UserModel.fromMap(Map<String, dynamic> mapData) {
    uid = mapData['uid'];
    profileImage = mapData['profileImage'];
    name = mapData['name'];
    lat = mapData['lat'];
    long = mapData['long'];
    address = mapData['address'];
    phone = mapData['phone'];
    email = mapData['email'];
    gender = mapData['gender'];
    // city = mapData['city'];
     deviceToken = mapData['deviceToken'];
     lastActive = mapData['lastActive'];
  
  }

}
