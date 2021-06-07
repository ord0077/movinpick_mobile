// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

List<Product> productFromJson(String str) => List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
    String productId;
    String productImage;
    String productTitle;
    String productDescription;
    String productExpiry;
    String productType;
    String productCode;
    double productPrice;
    int productQuantity;
    Discount productDiscount;

    Product({
        this.productId,
        this.productTitle,
        this.productDescription,
        this.productExpiry,
        this.productType,
        this.productPrice,
        this.productCode,
        this.productQuantity, 
        this.productImage,
        this.productDiscount,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        productId: json["id"].toString(),
        productTitle: json["product_title"],
        productDescription: json["product_description"],
        productImage: json["product_image"].toString(),
        productExpiry: json["expiry_date"].toString().replaceAll('\/', '/'),
        productType: json["product_type"],
        productPrice: double.parse(json["product_price"]),
        productCode: json["legacy_code_sku"],
        productDiscount: (json["discount"] == null)? null : Discount.fromJson(json["discount"]),
        productQuantity: 1
    );

    factory Product.fromOrderRequestJson(Map<String, dynamic> json) => Product(
        productId: json["id"].toString(),
        productTitle: json["product_title"],
        productDescription: json["product_description"],
        productImage: json["product_image"].toString(),
        productExpiry: json["expiry_date"].toString().replaceAll('\/', '/'),
        productType: json["product_type"],
        productPrice: double.parse(json["product_price"]),
        productQuantity: int.parse(json["product_quantity"]),
        productCode: json["legacy_code_sku"],
    );

    Map<String, dynamic> toJson() => {
        "product_id": productId,
        "product_title": productTitle,
        "product_image": productImage,
        "product_description": productDescription,
        "product_expiry": productExpiry,
        "product_type": productType,
        "product_price": productPrice,
        "product_quantity": productQuantity,
    };

    Map<String, dynamic> toJsonForCart() => {
        "product_id": int.parse(productId),
        "product_quantity": productQuantity,
        "discount": productDiscount
    };
}

class Discount {
    int id;
    String discountType;
    String discountTitle;
    double discountAmount;
    Discount({
        this.id,
        this.discountType,
        this.discountTitle,
        this.discountAmount,
    });

    factory Discount.fromJson(Map<String, dynamic> json) => Discount(
        id: json["id"],
        discountType: json["discount_type"],
        discountTitle: json["discount_title"],
        discountAmount: double.parse(json["discount_amount"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "discount_type": discountType,
        "discount_title": discountTitle,
        "discount_amount": discountAmount,
    };
}
