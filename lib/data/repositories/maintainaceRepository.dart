import 'dart:convert';
import 'package:http/http.dart';
import 'package:ice_cream/consts.dart';
import 'package:ice_cream/data/models/request.dart';

class MaintainaceRepository {

  Future<String> maintainaceRequest(String message, String token, int userId, String image, String type) async {

    String url = baseURL + 'maintenanceuser';

    Map<String, String> headers = {"Content-type": "application/json", "Authorization":"Bearer $token"};


    String body = '{"customer_id": "$userId", "message": "$message", "image": "$image", "type": "$type"}';

    print(body);

    Response response = await post(url, headers: headers, body: body);
    
    print(response.body);
    if (response.statusCode == 200 && json.decode(response.body)['response_status']){
      return json.decode(response.body)['message'];
    } else if (response.statusCode == 422) {
      throw "Invalid Credentials";
    } else {
      throw "Someting went wrong please try again!";
    }

  }

  Future<List<RequestModel>> getRequests(String token) async {

    String url = baseURL + 'maintenanceuser';
    Map<String, String> headers = {"Content-type": "application/json", "Authorization":"Bearer $token"};
    Response response = await get(url, headers: headers);

    var requestJsonList = json.decode(response.body) as List;
    var requestList = requestJsonList.map((request) => RequestModel.fromJson(request)).toList();
    
    print(response.body);

    if (response.statusCode == 200){      
      return requestList;
    } else {
      throw "Someting went wrong please try again!";
    }

  }

  Future<String> changeOrderStatus(String token, RequestModel request) async {

    String url = baseURL + 'request_status_change';

    Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};
    
    String body = '{"request_id": ${request.requestId}, "status_id": 5}';

    Response response = await post(url, headers: headers, body: body);


    if (response.statusCode == 200 && json.decode(response.body)['response_status']){
      return json.decode(response.body)['message'];
    } else if (response.statusCode == 422) {
      throw "Invalid Credentials";
    } else {
      throw "Someting went wrong please try again!";
    }

  }
}