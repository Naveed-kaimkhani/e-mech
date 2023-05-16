class UserModel {
   String? uid;
  String? profileImage;
  String? name;
 String? phone;
  String? email;
 String? gender;
  String? city;

  UserModel({
  required this.uid,
 required   this.profileImage,
   required this.name,
  required  this.phone,
  required  this.email,
  required  this.gender,
  required  this.city,
  });

  
  Map<String, dynamic> toMap(UserModel user) {
    var data = Map<String, dynamic>();
    data['uid'] = user.uid;
    data['profileImage'] = user.profileImage;
    data['name'] = user.name;
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
    phone = mapData['phone'];
    email = mapData['email'];
    gender = mapData['gender'];
    city = mapData['city'];
    
    // this.age = mapData['age'];
  }

}
