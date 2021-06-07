// To parse this JSON data, do
//
//     final request = requestFromJson(jsonString);

import 'dart:convert';

List<RequestModel> requestFromJson(String str) => List<RequestModel>.from(json.decode(str).map((x) => RequestModel.fromJson(x)));

String requestToJson(List<RequestModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RequestModel {
    int requestId , customerId;
    String requestType;
    String requestTime;
    String requestDate;
    String requestScheduleDate;
    String requestMessage;
    String requestImage;
    String requestStatus;

    RequestModel({
        this.requestId,
        this.customerId,
        this.requestType,
        this.requestTime,
        this.requestDate,
        this.requestScheduleDate,
        this.requestMessage,
        this.requestImage,
        this.requestStatus,
    });

    factory RequestModel.fromJson(Map<String, dynamic> json) => RequestModel(
        requestId: json["id"],
        requestType: json["type"],
        requestTime: json["time"],
        requestDate: json["date"],
        requestScheduleDate: json["schedule"]?? "2030-01-27",
        requestMessage: json["message"],
        requestImage: json["image"],
        requestStatus: json["status_text"]?? "error",
    );

    Map<String, dynamic> toJson() => {
        "customer_id": customerId,
        "id": requestId,
        "type": requestType,
        "time": requestTime,
        "date": requestDate,
        "message": requestMessage,
        "image": requestImage
    };

    Map<String, dynamic> toJsonToSendRequest() => {
        "customer_id": customerId,
        "id": requestId,
        "type": requestType,
        "time": requestTime,
        "date": requestDate,
        "message": requestMessage,
    };
}
