class UserModel {
   String? uid;
  String? profileImage;
  String? name;
 double? lat;
 double? long; 
 //String? serviceId;
 String? phone;
  String? email;
 String? gender;
  String? city;

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
  required  this.city,
  });

  
  Map<String, dynamic> toMap(UserModel user) {
    var data = Map<String, dynamic>();
    data['uid'] = user.uid;
    data['profileImage'] = user.profileImage;
    data['name'] = user.name;
    data['lat'] = user.lat;
    data['long'] = user.long;
   // data['serviceId'] = user.serviceId;
    data['phone'] = user.phone;
    data['email'] = user.email;
    data['gender'] = user.gender;
    data['city'] = user.city;
    return data;
  }

  
  UserModel.fromMap(Map<String, dynamic> mapData) {
    uid = mapData['uid'];
    profileImage = mapData['profileImage'];
    name = mapData['name'];
    lat = mapData['lat'];
    long = mapData['long'];
    //serviceId = mapData['serviceId'];
    phone = mapData['phone'];
    email = mapData['email'];
    gender = mapData['gender'];
    city = mapData['city'];
    
    // this.age = mapData['age'];
  }

}
