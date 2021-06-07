import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ice_cream/consts.dart';
import 'package:ice_cream/data/models/loginModel.dart';
import 'package:ice_cream/data/models/orderModel.dart';
import 'package:ice_cream/data/models/productModel.dart';
import 'package:ice_cream/data/repositories/orderRepository.dart';
import 'package:ice_cream/screens/customer/DrawerTab/orderhistory/ordereditem.dart';
import 'package:ice_cream/widgets/dialogBox.dart';
import 'package:ice_cream/widgets/largeButton.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SingleOrderScreen extends StatelessWidget {

  final Order order;
  final String userType;
  final OrderRepository repository = OrderRepository();

  SingleOrderScreen({Key key, this.order, this.userType}): super(key: key);

  

  @override
  Widget build(BuildContext context) {

    bool isCustomer = userType == null? true : userType == "customer";

    var d = DateTime.parse("2011-02-10");
    print(d);

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Order Info"),
      ),

      bottomNavigationBar: BottomActionButton(order: order, repository: repository, userType: userType?? "customer",),

      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[

            if (isCustomer)
              OrderStatusCard(
                order: order,
              ),

            Hero(
              tag: order.orderId,
              child: Material(
                child: PlacedOrderItem(
                  order: order,
                  userType: userType,
                ),
              ),
            ),

            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(8.0),
              decoration: cardDecoration,
              child: ReceiptTable(
                userType: userType,
                order: order,
              ),
            ),
          ],
        ),
      )
      
    );
  }
}

class BottomActionButton extends StatelessWidget {
  const BottomActionButton({
    Key key,
    @required this.order,
    @required this.repository, this.userType,
  }) : super(key: key);

  final Order order;
  final OrderRepository repository;
  final String userType;

  @override
  Widget build(BuildContext context) {

    // !isCustomer && order.orderStatus == "processing"? 

    if (userType == "cold storage" && order.orderStatus == "processing")
      return VeryLargeButton(
        buttonText: "LOADED",
        textColor: Colors.black,
        buttonColor: Theme.of(context).accentColor,
        
        onTap: (){
          
          showDialog(
            context: context,
            builder: (BuildContext context) {
              bool showLoading = false;
              String message = "Are you sure that you have loaded the order in ${order.driver[0].name}'s truck?";

              return StatefulBuilder(
                builder: (context, refresh) => CustomDialog(
                  title: "",
                  description: message,
                  buttonText: "PROCEED",
                  loading: showLoading,
                  onTap:() async {

                    refresh(() {
                      showLoading = true;
                    });

                    SharedPreferences userData = await SharedPreferences.getInstance();
                    Map userMap = json.decode(userData.getString(userKey));
                    LoginModel loginData = LoginModel.fromJson(userMap);


                    Future<String> orderPlaced = repository.changeOrderStatus(loginData.token, order, "loaded");

                    orderPlaced.then((value){

                      Navigator.pushNamedAndRemoveUntil(context, '/coldstorage', (Route<dynamic> route) => false);
                      print(value);
                    
                    }).catchError((value){
                      
                      message = "Sorry some unexpected error occured please try again";

                    }).whenComplete((){

                      refresh((){
                        showLoading = false;
                      });
                      
                    });
                  },
                  
                ),
            );}
          );
        },

      );
    else if (userType == "driver" && order.orderStatus == "loaded"){
      bool isTapped = false;

      return StatefulBuilder(
        builder: (context, refresh) {
          return isTapped? Container(
            height: 58.0,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: SizedBox(
                width: 30.0,
                height: 30.0,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
                  strokeWidth: 3.0,
                ),
              )),
          ) : VeryLargeButton(
              buttonText: "START RIDE",
              textColor: Colors.black,
              buttonColor: Theme.of(context).accentColor,
              onTap: () async {
                
                refresh((){
                  isTapped = true;
                });

                print(isTapped);

                SharedPreferences userData = await SharedPreferences.getInstance();
                Map userMap = json.decode(userData.getString(userKey));
                LoginModel loginData = LoginModel.fromJson(userMap);
                Future<String> orderPlaced = repository.changeOrderStatus(loginData.token, order, "ontheway");

                orderPlaced.then((value){
                  Navigator.pushNamedAndRemoveUntil(context, '/driver', (Route<dynamic> route) => false);
                  refresh((){
                    isTapped = false;
                  });
                });
              },
            );
        },
      );
    } else if (userType == "driver" && order.orderStatus == "on the way"){
      
      bool isTapped = false;

      return StatefulBuilder(
        builder: (context, refresh) {
          return isTapped? Container(
            height: 58.0,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: SizedBox(
                width: 30.0,
                height: 30.0,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
                  strokeWidth: 3.0,
                ),
              )),
          ) : VeryLargeButton(
              buttonText: "DELIVERED",
              textColor: Colors.black,
              buttonColor: Theme.of(context).accentColor,
              onTap: () async {
                
                refresh((){
                  isTapped = true;
                });

                print(isTapped);

                SharedPreferences userData = await SharedPreferences.getInstance();
                Map userMap = json.decode(userData.getString(userKey));
                LoginModel loginData = LoginModel.fromJson(userMap);
                Future<String> orderPlaced = repository.changeOrderStatus(loginData.token, order, "delivered");

                orderPlaced.then((value){
                  Navigator.pushNamedAndRemoveUntil(context, '/driver', (Route<dynamic> route) => false);
                  refresh((){
                    isTapped = false;
                  });
                });
              },
            );
        },
      );
    } else 
      return SizedBox(height: 0.0,);
  }
}

class ReceiptTable extends StatelessWidget {

  final Order order;
  final String userType;

  const ReceiptTable({
    Key key,
    this.order, this.userType
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int i = 0;
    bool isCash = (order.paymentType == null)? true :order.paymentType.toLowerCase() == "cash";

    print(order.paymentType);

    return Table(
      columnWidths: {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(5),
        2: FlexColumnWidth(9),
        3: FlexColumnWidth(3),
        if (userType == "customer" || (userType != "coldstorage" && (userType == "driver" && isCash)))
        4: FlexColumnWidth(6),
      },
      children: <TableRow>[
        TableRow(
          decoration: BoxDecoration(
            color: Colors.black12,
          ),
          children: <TableCell>[
            headerCell(
              const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0),
              "S#",
              TextAlign.start
            ),
            headerCell(
              const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0),
              "Code",
              TextAlign.start
            ),
            headerCell(
              const EdgeInsets.only(top: 8.0, bottom: 8.0),
              "Item",
              TextAlign.start
            ),

            if (userType == "customer" || (userType != "coldstorage" && (userType == "driver" && isCash)))
            headerCell(
              const EdgeInsets.only(top: 8.0, bottom: 8.0),
              "Qty",
              TextAlign.end
            )
            else
            headerCell(
              const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 8.0),
              "Qty",
              TextAlign.end
            ),
            if (userType == "customer" || (userType != "coldstorage" && (userType == "driver" && isCash)))
            headerCell(
              const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 8.0),
              "Price",
              TextAlign.end
            ),
          ],
        ),

        for (Product product in order.orderProducts)
          TableRow(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black12)),
            ),
            children: <TableCell>[
              rowCell(
                const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0),
                "${++i}",
                TextAlign.start
              ),
              rowCell(
                const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0),
                product.productCode,
                TextAlign.start
              ),
              rowCell(
                const EdgeInsets.only(top: 8.0, bottom: 8.0),
                product.productTitle,
                TextAlign.start
              ),
              
              if (userType == "customer" || (userType != "coldstorage" && (userType == "driver" && isCash)))
              rowCell(
                const EdgeInsets.only(top: 8.0, bottom: 8.0),
                "x" + product.productQuantity.toString(),
                TextAlign.end,
              )
              else 
              rowCell(
                const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 8.0),
                "x" + product.productQuantity.toString(),
                TextAlign.end,
              ),
              if (userType == "customer" || (userType != "coldstorage" && (userType == "driver" && isCash)))
              rowCell(
                const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 8.0),
                (product.productPrice * product.productQuantity).toStringAsFixed(2).replaceAllMapped(reg, mathFunc) ,
                TextAlign.end
              ),
            ],
          ),
   
        if (userType == "customer" || (userType != "coldstorage" && (userType == "driver" && isCash)))
        TableRow(
          decoration: BoxDecoration(color: Colors.black12),
          children: <TableCell>[
            TableCell(child: Container()),
            TableCell(child: Container()),
            rowCell(const EdgeInsets.only(top: 8.0, bottom: 2.0), "Sub Total:", TextAlign.end),
            TableCell(child: Container()),
            rowCell(const EdgeInsets.only(top: 8.0, bottom: 2.0, right: 8.0), order.orderGross.toStringAsFixed(2).replaceAllMapped(reg, mathFunc), TextAlign.end),
          ],
        ),

        if (userType == "customer" || (userType != "coldstorage" && (userType == "driver" && isCash)))
        if ((order.orderDiscount?? -1) > 0)
          TableRow(
            decoration: BoxDecoration(color: Colors.black12),
            children: <TableCell>[
              TableCell(child: Container()),
              TableCell(child: Container()),
              rowCell(const EdgeInsets.only(top: 0.0, bottom: 0.0), "Discount", TextAlign.end),
              TableCell(child: Container()),
              rowCell(const EdgeInsets.only(top: 0.0, bottom: 0.0, right: 8.0), ((order.orderDiscount?? 0) * -1).toStringAsFixed(2).replaceAllMapped(reg, mathFunc), TextAlign.end),
            ],
          ),

        if (userType == "customer" || (userType != "coldstorage" && (userType == "driver" && isCash)))
        TableRow(
          decoration: BoxDecoration(color: Colors.black12),
          children: <TableCell>[
            TableCell(child: Container()),
            TableCell(child: Container()),
            rowCell(const EdgeInsets.only(top: 0.0, bottom: 0.0), "VAT Applied:", TextAlign.end),
            TableCell(child: Container()),
            rowCell(const EdgeInsets.only(top: 0.0, bottom: 0.0, right: 8.0), order.orderTax.toStringAsFixed(2).replaceAllMapped(reg, mathFunc), TextAlign.end),
          ],
        ),

        if (userType == "customer" || (userType != "coldstorage" && (userType == "driver" && isCash)))
        TableRow(
          decoration: BoxDecoration(color: Colors.black12),
          children: <TableCell>[
            TableCell(child: Container()),
            TableCell(child: Container()),
            rowCell(const EdgeInsets.only(top: 2.0, bottom: 8.0), "Total:", TextAlign.end),
            TableCell(child: Container()),
            rowCell(const EdgeInsets.only(top: 2.0, bottom: 8.0, right: 8.0), order.orderTotal.toStringAsFixed(2).replaceAllMapped(reg, mathFunc), TextAlign.end),
          ],
        ),
      ],
    );
  }

  TableCell headerCell(EdgeInsetsGeometry padding, String text, TextAlign align) {
    return TableCell(
      child: Padding(
        padding: padding,
        child: Text(
          text, 
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54, fontSize: 12.0),
          textAlign: align,
        ),
      ),
    );
  }

  TableCell rowCell(EdgeInsetsGeometry padding, String text, TextAlign align) {
    return TableCell(
      child: Padding(
        padding: padding,
        child: Text(
          text,
          textAlign: align,
          style: TextStyle(fontSize: 10.0),
        ),
      ),
    );
  }
}

class OrderStatusCard extends StatelessWidget {
  const OrderStatusCard({
    Key key,
    this.order,
  }) : super(key: key);

  final Order order;

  @override
  Widget build(BuildContext context) {

    String status, message;
    IconData icon;
    Color iconColor;

    // pending
    // processing
    // loaded
    // ontheway
    // delivered
    // cancelled
    // closed

    switch (order.orderStatus.toLowerCase()) {
      case "pending":
        status = "SUBMITTED";
        message = "Your order has been recieved our representative will contact you shortly";
        icon = Icons.assignment_turned_in;
        iconColor = Colors.blue;
        break;
      case "processing":
        status = "CONFIRMED";
        message = "Your order has been confirmed it will be shipped to you within 48 hours";
        icon = Icons.call_end;
        iconColor = Colors.orange;
        break;
      case "loaded":
      case "on the way":
        status = "DISPATCHED";
        message = "Your order is on the way you will recieve you package shortly";
        icon = Icons.local_shipping;
        iconColor = Colors.purple;
        break;
        break;
      case "delivered":
        status = "DELIVERED";
        message = "Your order was successfully delivered";
        icon = Icons.check_circle;
        iconColor = Colors.green;
        break;
      default:
        status = "f";
        message = "d";
        icon = Icons.check_circle;
    }
    
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 200.0,
        decoration: cardDecoration,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    icon,
                    size: 80.0,
                    color: iconColor,
                  ),

                  SizedBox(height: 4.0),

                  Text(status??""),
                  
                  SizedBox(height: 2.0),

                  Flexible(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 64.0),
                      child: Text(
                        message??"",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10.0,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              flex: 2,
              child: Container(
                color: Colors.black12,
                padding: EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    StatusLabel(
                      icon: Icons.assignment_turned_in,
                      label: status,
                      color: order.orderDate == ""? Colors.black26 : Colors.green,
                      date: order.orderDate?? "",
                    ),

                    Container(
                      height: 2.0,
                      width: 16.0,
                      color: order.orderConfirmedDate == ""? Colors.black12 : Colors.green,
                    ),

                    StatusLabel(
                      icon: Icons.call_end,
                      label: "CONFIRMED",
                      color: order.orderConfirmedDate == ""? Colors.black26 : Colors.green,
                      date: order.orderConfirmedDate?? "",
                    ),

                    Container(
                      height: 2.0,
                      width: 16.0,
                      color: order.orderShippedDate == ""? Colors.black12 : Colors.green,
                    ),

                    StatusLabel(
                      icon: Icons.local_shipping,
                      label: "DISPATCHED",
                      color: order.orderShippedDate == ""? Colors.black26 : Colors.green,
                      date: order.orderShippedDate?? "",
                    ),

                    Container(
                      height: 2.0,
                      width: 16.0,
                      color: order.orderDeliveredDate == ""? Colors.black12 : Colors.green,
                    ),

                    StatusLabel(
                      icon: Icons.check_circle,
                      label: "DELIVERED",
                      color: order.orderDeliveredDate == ""? Colors.black26 : Colors.green,
                      date: order.orderDeliveredDate?? "",
                    ),
                  ],
                ),
              ),
            )

            

          ],
        ),
      ),
    );
  }
}

class StatusLabel extends StatelessWidget {
  const StatusLabel({
    Key key, this.icon, this.label, this.color, this.date,
  }) : super(key: key);

  final IconData icon;
  final String label, date;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Icon(
          icon,
          size: 24.0,
          color: color?? Colors.black12,
        ),

        SizedBox(height: 2.0),

        Text(
          label,
          style: TextStyle(
            fontSize: 8.0,
            color: date == ""? Colors.black26: Colors.black,
          ),
        ),

        SizedBox(height: 1.0),

        Text(
          date?? "",
          style: TextStyle(
            fontSize: 6.0,
          ),
        ),

      ],
    );
  }
}