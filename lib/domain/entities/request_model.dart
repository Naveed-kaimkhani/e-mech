class RequestModel {
  // String? receiverUid;
  String? senderUid;
  String? receiverUid;
  String? documentId;
  String? senderName;
  String? senderPhone;
  String? sentDate;
  String? sentTime;
  String? serviceRequired;
  String? serviceId;
  String? senderDeviceToken;
  double? senderLat;
  double? senderLong;
  String? senderProfileImage;
  String? senderAddress;
  String? distance;
  RequestModel({
    // this.receiverUid,
    this.documentId,
    this.serviceId,
    this.senderLat,
    this.senderLong,
    this.senderAddress,
    this.senderDeviceToken,
    this.senderUid,
    this.receiverUid,
    this.serviceRequired,
    this.senderName,
    this.sentDate,
    this.sentTime,
    this.senderProfileImage,
    this.senderPhone,
    this.distance,
  });

  Map<String, dynamic> toMap(RequestModel request) {
    var data = Map<String, dynamic>();
    // data['receiverUid'] = request.receiverUid;
    data['documentId'] = request.documentId;
    data['senderUid'] = request.senderUid;
    data['receiverUid'] = request.receiverUid;
    data['serviceRequired'] = request.serviceRequired;
    data['senderLat'] = request.senderLat;
    data['senderLong'] = request.senderLong;
    data['senderPhone'] = request.senderPhone;
    data['senderAddress'] = request.senderAddress;
    data['serviceId'] = request.serviceId;
    data['senderName'] = request.senderName;
    data['senderProfileImage'] = request.senderProfileImage;
    data['sentDate'] = request.sentDate;
    data['sentTime'] = request.sentTime;
    data['distance'] = request.distance;
    data['senderDeviceToken'] = request.senderDeviceToken;

    return data;
  }

  RequestModel.fromMap(Map<String, dynamic> mapData) {
    // receiverUid = mapData['receiverUid'];
    documentId = mapData['documentId'];
    serviceRequired = mapData['serviceRequired'];
    senderName = mapData['senderName'];
    senderUid = mapData['senderUid'];
    receiverUid = mapData['receiverUid'];
    senderLat = mapData['senderLat'];
    senderLong = mapData['senderLong'];
    senderPhone = mapData['senderPhone'];
    senderAddress = mapData['senderAddress'];
    serviceId = mapData['serviceId'];
    senderProfileImage = mapData['senderProfileImage'];
    sentDate = mapData['sentDate'];
    sentTime = mapData['sentTime'];
    distance = mapData['distance'];
    senderDeviceToken = mapData['senderDeviceToken'];
  }

  // bool equals(RequestModel user) => user.uid == this.uid;
}
