class RequestModel {
  String? receiverUid;
  String? senderUid;
  String? serviceId;
  // String? requestName;
  String? senderName;
  String? sentDate;
  String? serviceRequired;
  String? senderProfileImage;
  RequestModel({
    this.receiverUid,
    this.serviceId,
    this.senderUid,
    this.serviceRequired,
    this.senderName,
    this.sentDate,
    this.senderProfileImage,
  });

  Map<String, dynamic> toMap(RequestModel request) {
    var data = Map<String, dynamic>();
    data['receiverUid'] = request.receiverUid;
    data['serviceId'] = request.serviceId;
    data['senderUid'] = request.senderUid;
    data['serviceRequired'] = request.serviceRequired;
    data['senderName'] = request.senderName;
    data['senderProfileImage'] = request.senderProfileImage;
    data['sentDate'] = request.sentDate;

    return data;
  }

  RequestModel.fromMap(Map<String, dynamic> mapData) {
    receiverUid = mapData['receiverUid'];
    serviceId = mapData['serviceId'];
    serviceRequired = mapData['serviceRequired'];
    senderName = mapData['senderName'];
    senderUid = mapData['senderUid'];
    senderProfileImage = mapData['senderProfileImage'];
    sentDate = mapData['sentDate'];
  }

  // bool equals(RequestModel user) => user.uid == this.uid;
}
