// To parse this JSON data, do
//
//     final order = orderFromJson(jsonString);

import 'dart:convert';
import 'package:ice_cream/data/models/productModel.dart';

List<Order> orderFromJson(String str) => List<Order>.from(json.decode(str).map((x) => Order.fromJson(x)));

String orderToJson(List<Order> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Order {
    int orderId, customerId;
    String orderDate, orderConfirmedDate, orderShippedDate, orderDeliveredDate, customerName, customerAddress;
    String orderTime, customerType;
    double orderTotal, orderTax, orderGross, orderDiscount;
    String deliveryDate, deliveryTo, deliveryFrom;
    String orderStatus, paymentType;
    List<Driver> driver;
    List<Product> orderProducts;


    Order({
        this.orderId,
        this.customerId,
        this.orderDate,
        this.orderConfirmedDate,
        this.orderShippedDate,
        this.orderDeliveredDate,
        this.orderTime,
        this.orderTotal,
        this.deliveryDate,
        this.deliveryTo,
        this.deliveryFrom,
        this.orderStatus,
        this.paymentType,
        this.orderProducts,
        this.orderGross,
        this.orderDiscount,
        this.orderTax,
        this.driver,
        this.customerType,
        this.customerName,
        this.customerAddress,
    });

    factory Order.fromJsonForCheckout(Map<String, dynamic> json) => Order(
        orderId: json["id"],
        orderDate: json["order_date"],
        orderConfirmedDate: json["order_confirmed_date"],
        orderShippedDate: json["order_shipped_date"],
        orderDeliveredDate: json["order_delivered_date"],
        orderTime: json["order_time"],
        orderGross: json["order_gross"].toDouble(),
        orderTax: json["order_tax"].toDouble(),
        orderTotal: json["order_total"].toDouble(),
        orderStatus: json["status"],
        orderDiscount: (json["discounted_price"] == null )? 0.0 : double.parse(json["discounted_price"]),
        orderProducts: List<Product>.from(json["order_products"].map((x) => Product.fromOrderRequestJson(x))),
    );


    factory Order.fromJson(Map<String, dynamic> json) => Order(
        orderId: json["id"],
        orderDate: json["order_date"],
        orderConfirmedDate: json["order_confirmed_date"],
        orderShippedDate: json["order_shipped_date"],
        orderDeliveredDate: json["order_delivered_date"],
        orderTime: json["order_time"],
        orderGross: json["order_gross"].toDouble(),
        orderTax: json["order_tax"].toDouble(),
        orderTotal: json["order_total"].toDouble(),
        orderStatus: json["status"],
        customerName: json["company_name"],
        paymentType: json["payment_type"],
        customerAddress: json["address"],
        deliveryDate: json["delivery_date"]?? "2020-01-27",
        deliveryFrom: json["delivery_from"]?? " - ",
        deliveryTo: json["delivery_to"]?? " - ",
        orderDiscount: (json["discounted_price"] == null )? 0.0 : double.parse(json["discounted_price"]),
        orderProducts: List<Product>.from(json["order_products"].map((x) => Product.fromOrderRequestJson(x))),
        driver: List<Driver>.from(json["driver"].map((x) => Driver.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "order_date": orderDate,
        "order_time": orderTime,
        "order_confirmed_date":  orderConfirmedDate,
        "order_shipped_date":  orderShippedDate,
        "order_delivered_date":  orderDeliveredDate,
        "order_total": orderTotal,
        "order_tax": orderTax,
        "order_gross": orderGross,
        "order_status": orderStatus,
        "products": List<dynamic>.from(orderProducts.map((x) => x.toJson())),
    };

    Map<String, dynamic> toJsonforCheckout() => {
        "customer_id": customerId,
        "order_total": orderTotal,
        "order_tax": orderTax,
        "order_gross": orderGross,
        "discounted_price": orderDiscount.toString(),
        "products": List<dynamic>.from(orderProducts.map((x) => x.toJsonForCart())),
    };
}

class Driver {
    int driverId;
    String name;
    int roleId;
    dynamic customerCategoryId;
    int master;
    String email;
    String phoneNumber;
    String mobileNumber;
    dynamic ntn;
    String address;
    String stateId;
    String cityId;
    String password;
    int isActive;

    Driver({
        this.driverId,
        this.name,
        this.roleId,
        this.customerCategoryId,
        this.master,
        this.email,
        this.phoneNumber,
        this.mobileNumber,
        this.ntn,
        this.address,
        this.stateId,
        this.cityId,
        this.password,
        this.isActive,
    });

    factory Driver.fromJson(Map<String, dynamic> json) => Driver(
        driverId: json["driver_id"],
        name: json["name"],
        roleId: json["role_id"],
        customerCategoryId: json["customer_category_id"],
        master: json["master"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        mobileNumber: json["mobile_number"],
        ntn: json["ntn"],
        address: json["address"],
        stateId: json["state_id"],
        cityId: json["city_id"],
        password: json["password"],
        isActive: json["IsActive"],
    );

    Map<String, dynamic> toJson() => {
        "driver_id": driverId,
        "name": name,
        "role_id": roleId,
        "customer_category_id": customerCategoryId,
        "master": master,
        "email": email,
        "phone_number": phoneNumber,
        "mobile_number": mobileNumber,
        "ntn": ntn,
        "address": address,
        "state_id": stateId,
        "city_id": cityId,
        "password": password,
        "IsActive": isActive,
    };
}
