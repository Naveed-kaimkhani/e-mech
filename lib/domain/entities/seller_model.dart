class SellerModel {
   String? uid;
   String? CNIC;
  String? profileImage;
  String? name;
 String? phone;
  String? email;
 String? address;
  double? lat;
  double? long;
   String? workshopName;
String? service;
String? deviceToken;

  SellerModel({
  this.lat,
  this.long,
  required this.uid,
 required   this.profileImage,
   required this.name,
  required  this.phone,
  required  this.email,
  required this.CNIC,
  required this.address,
  required this.workshopName,
  required this.service,
  required this.deviceToken,

  });

  
  Map<String, dynamic> toMap(SellerModel user) {
    var data = Map<String, dynamic>();
    data['uid'] = user.uid;
    data['profileImage'] = user.profileImage;
    data['name'] = user.name;
    data['lat'] = user.lat;
    data['long'] = user.long;
    data['phone'] = user.phone;
    data['email'] = user.email;
    data['CNIC'] = user.CNIC;
    data['deviceToken'] = user.deviceToken;
    data['service'] = user.service;
    data['address'] = user.address;
    return data;
  }

  
  SellerModel.fromMap(Map<String, dynamic> mapData) {
    uid = mapData['uid'];
    profileImage = mapData['profileImage'];
    name = mapData['name'];
    phone = mapData['phone'];
     lat = mapData['lat'];
    long = mapData['long'];
    email = mapData['email'];
    CNIC = mapData['CNIC'];
     service = mapData['service'];
     address = mapData['address'];
    deviceToken = mapData['deviceToken'];
    
  }

}
