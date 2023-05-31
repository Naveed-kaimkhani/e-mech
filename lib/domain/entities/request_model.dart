class RequestModel {
  // String? receiverUid;
  String? senderUid;
  String? documentId;
  String? senderName;
  String? senderPhone;
  String? sentDate;
  String? sentTime;
  String? serviceRequired;
  String? serviceId;
  double? senderLat;
  double? senderLong;
  String? senderProfileImage;
  RequestModel({
    // this.receiverUid,
    this.documentId,
    this.serviceId,
    this.senderLat,
    this.senderLong,
    this.senderUid,
    this.serviceRequired,
    this.senderName,
    this.sentDate,
    this.sentTime,
    this.senderProfileImage,
    this.senderPhone,
  });

  Map<String, dynamic> toMap(RequestModel request) {
    var data = Map<String, dynamic>();
    // data['receiverUid'] = request.receiverUid;
    data['documentId'] = request.documentId;
    data['senderUid'] = request.senderUid;
    data['serviceRequired'] = request.serviceRequired;
    data['senderLat'] = request.senderLat;
    data['senderLong'] = request.senderLong;
    data['senderPhone'] = request.senderPhone;
    data['serviceId'] = request.serviceId;
    data['senderName'] = request.senderName;
    data['senderProfileImage'] = request.senderProfileImage;
    data['sentDate'] = request.sentDate;
    data['sentTime'] = request.sentTime;

    return data;
  }

  RequestModel.fromMap(Map<String, dynamic> mapData) {
    // receiverUid = mapData['receiverUid'];
    documentId = mapData['documentId'];
    serviceRequired = mapData['serviceRequired'];
    senderName = mapData['senderName'];
    senderUid = mapData['senderUid'];
    senderLat = mapData['senderLat'];
    senderLong = mapData['senderLong'];
    senderPhone = mapData['senderPhone'];
    serviceId = mapData['serviceId'];
    senderProfileImage = mapData['senderProfileImage'];
    sentDate = mapData['sentDate'];
    sentTime = mapData['sentTime'];
  }

  // bool equals(RequestModel user) => user.uid == this.uid;
}
