import 'dart:convert';
import 'package:http/http.dart';
import 'package:ice_cream/consts.dart';

class FeedbackRepository {

  Future<String> giveFeedback(String feedback, int userId) async {

    String url = baseURL + 'feedback';

    Map<String, String> headers = {"Content-type": "application/json"};


    String body = '{"user_id": $userId, "feedback": "$feedback"}';

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