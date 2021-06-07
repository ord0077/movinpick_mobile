import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:ice_cream/consts.dart';
import 'package:ice_cream/data/models/orderModel.dart';


/// This class is responsible for placing order
class OrderRepository {

  /// The function takes email and password as parameters and than recives a
  /// Customer object if the credentials are valid else throws exceptions
  Future<Order> placeOrder(String token, Order order) async {

    String url = baseURL + 'order';

    Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};

    String body = json.encode(order.toJsonforCheckout());

    print(body);

    Response response = await post(url, headers: headers, body: body);


    if (response.statusCode == 200){
      return Order.fromJsonForCheckout(json.decode(response.body));
    } else if (response.statusCode == 422) {
      throw "Invalid Credentials";
    } else {
      throw "Someting went wrong please try again!";
    }

  }

  Future<List<Order>> getOrders(String token) async {

    String url = baseURL + 'order_by_user';

    Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};

    Response response = await get(url, headers: headers);

    var orderJsonList = json.decode(response.body) as List;
    var orderList = orderJsonList.map((order) => Order.fromJsonForCheckout(order)).toList();
  
    if (response.statusCode == 200){
      return orderList;
    } else if (response.statusCode == 422) {
      throw "Invalid Credentials";
    } else {
      throw "Someting went wrong please try again!";
    }

  }

  Future<List<Order>> getOrdersForColdStorage(String token, bool showHistory) async {

    String endpoint = showHistory? "orders_by_coldstorage" : "processing_orders_by_coldstorage";
    String url = baseURL + endpoint;

    Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};

    Response response = await get(url, headers: headers);
    
    var orderJsonList = json.decode(response.body) as List;
    
    var orderList = orderJsonList.map((order) => Order.fromJson(order)).toList();

    if (response.statusCode == 200){
      return orderList;
    } else if (response.statusCode == 422) {
      throw "Invalid Credentials";
    } else {
      throw "Someting went wrong please try again!";
    }

  }

  Future<List<Order>> getOrdersForDriver(String token, bool showHistory) async {

    String endpoint = showHistory? "delivered_orders_by_driver" : "assigned_orders_to_driver";
    String url = baseURL + endpoint;

    Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};

    Response response = await get(url, headers: headers);
    
    var orderJsonList = json.decode(response.body) as List;
    
    var orderList = orderJsonList.map((order) => Order.fromJson(order)).toList();

    if (response.statusCode == 200){
      return orderList;
    } else if (response.statusCode == 422) {
      throw "Invalid Credentials";
    } else {
      throw "Someting went wrong please try again!";
    }

  }

  // loaded = 3
  // ontheway = 4
  // delivered = 5

  Future<String> changeOrderStatus(String token, Order order, String status) async {

    int statusId = 0;

    switch (status) {
      case 'loaded':
        statusId = 3;    
        break;
      
      case 'ontheway':
        statusId = 4;    
        break;
      
      case 'delivered':
        statusId = 5;    
        break;

      default:
    }

    String url = baseURL + 'status_change';

    Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};
    
    String body = '{"order_id": ${order.orderId}, "status_id": $statusId}';

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

  Future<List<Order>> getchay() async {

    var orderJson = await rootBundle.loadString(orderJsonPath);
    
    var orderJsonList = json.decode(orderJson) as List;

    var orderList = orderJsonList
        .map((categoryJson) => Order.fromJson(categoryJson))
        .toList();

    return orderList;
  }

}