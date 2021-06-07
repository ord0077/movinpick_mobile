import 'dart:convert';
import 'package:http/http.dart';
import 'package:ice_cream/consts.dart';
import 'package:ice_cream/data/models/loginModel.dart';

/// This class is responsible for hendling the network request related to login
class LoginRepository {


  /// The function takes email and password as parameters and than recives a
  /// Customer object if the credentials are valid else throws exceptions
  Future<LoginModel> login(String email, String password) async {

    String url = baseURL + 'login';

    Map<String, String> headers = {"Content-type": "application/json"};

    String body = '{"email": "${email.toLowerCase()}", "password": "$password", "device_type" : "mobile"}';

    print(body);

    Response response = await post(url, headers: headers, body: body);

    print(response.body);
    
    if (response.statusCode == 200){      
      return LoginModel.fromJson(json.decode(response.body));

    } else if (response.statusCode == 422) {
      throw "Invalid Credentials";
    } else {
      throw "Someting went wrong please try again!";
    }

  }
}