import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart';
import 'package:ice_cream/consts.dart';
import 'package:ice_cream/data/models/productModel.dart';

class ProductRepository {

  // Future<List<Product>> get() async {
  //   var productJson = await rootBundle.loadString(productJsonPath);
  //   var productJsonList = json.decode(productJson) as List;
    
  //   var productList = productJsonList
  //       .map((categoryJson) => Product.fromJson(categoryJson))
  //       .toList();

  //   return productList;
  // }

  Future<List<Product>> getProducts(String token) async {

    String url = baseURL + 'product';
    Map<String, String> headers = {"Content-type": "application/json", "Authorization":"Bearer $token"};
    Response response = await get(url, headers: headers);

    print(response.body);
    var productJsonList = json.decode(response.body) as List;
    var productList = productJsonList.map((product) => Product.fromJson(product)).toList();
    
    if (response.statusCode == 200){      
      return productList;
    } else {
      throw "Someting went wrong please try again!";
    }
  }

}