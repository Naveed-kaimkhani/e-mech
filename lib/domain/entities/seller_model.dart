class SellerModel {
   String? uid;
   String? CNIC;
  String? profileImage;
  String? name;
 String? phone;
  String? email;
 String? address;
  // String? city;
   String? workshopName;
String? service;

  SellerModel({
  required this.uid,
 required   this.profileImage,
   required this.name,
  required  this.phone,
  required  this.email,
  required this.CNIC,
  required this.address,
  // required this.city,
  required this.workshopName,
  required this.service

  });

  
  Map<String, dynamic> toMap(SellerModel user) {
    var data = Map<String, dynamic>();
    data['uid'] = user.uid;
    data['profileImage'] = user.profileImage;
    data['name'] = user.name;
    data['phone'] = user.phone;
    data['email'] = user.email;
    data['CNIC'] = user.CNIC;
    // data['city'] = user.city;
    data['service'] = user.service;
    data['address'] = user.address;
    return data;
  }

  
  SellerModel.fromMap(Map<String, dynamic> mapData) {
    uid = mapData['uid'];
    profileImage = mapData['profileImage'];
    name = mapData['name'];
    phone = mapData['phone'];
    email = mapData['email'];
    CNIC = mapData['CNIC'];
     service = mapData['service'];
     address = mapData['address'];
    // city = mapData['city'];
    
  }

}
