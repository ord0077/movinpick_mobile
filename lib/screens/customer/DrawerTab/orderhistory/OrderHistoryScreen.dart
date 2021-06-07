import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ice_cream/consts.dart';
import 'package:ice_cream/data/models/loginModel.dart';
import 'package:ice_cream/data/models/orderModel.dart';
import 'package:ice_cream/data/repositories/orderRepository.dart';
import 'package:ice_cream/screens/customer/DrawerTab/orderhistory/ordereditem.dart';
import 'package:ice_cream/screens/customer/DrawerTab/orderhistory/singleOrderScreen.dart';
import 'package:ice_cream/widgets/customer_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderHistory extends StatefulWidget {

  OrderHistory({Key key}) : super(key: key);

  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  final OrderRepository repository = OrderRepository();

  Future<List<Order>> getOrders() async {

    SharedPreferences userData = await SharedPreferences.getInstance();
    Map userMap = json.decode(userData.getString(userKey));
    LoginModel loginData = LoginModel.fromJson(userMap);


    Future<List<Order>> orderList = repository.getOrders(loginData.token);

    orderList.catchError((error){
      print(error);
    });

    return orderList;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: CustomerDrawer(),
      appBar: AppBar(
        title: Text("Your Orders"),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<Order>>(
        future: getOrders(),
        builder: (context, snapshot) {

          if (snapshot.hasData) {
            return RefreshIndicator(
              onRefresh: () async{
                setState(() {
                });
              },
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[

                    InListTitle(title: "Recent Order"),

                    if (snapshot.data.length == 0)
                      Center(child: Padding(
                        padding: const EdgeInsets.all(64.0),
                        child: Text("No Orders Placed"),
                      ))

                    else
                      for (Order order in snapshot.data)
                        if (order.orderStatus != "delivered")
                          InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SingleOrderScreen(order: order, userType: "customer",)));
                            },

                            child: Hero(
                              tag: order.orderId,
                              child: Material(
                                child: PlacedOrderItem(
                                  userType: "customer",
                                  order: order,
                                ),
                              ),
                            ),
                          ),

                    InListTitle(title: "Order History"),

                    if (snapshot.data.length == 0)
                      Center(child: Padding(
                        padding: const EdgeInsets.all(64.0),
                        child: Text("No Orders Deleviered"),
                      ))

                    else
                      for (Order order in snapshot.data)
                        if (order.orderStatus == "delivered")
                          InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SingleOrderScreen(order: order, userType: "customer",)));
                            },

                            child: Hero(
                              tag: order.orderId,
                              child: Material(
                                child: PlacedOrderItem(
                                  userType: "customer",
                                  order: order,
                                ),
                              ),
                            ),
                          ),
                          
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
                  strokeWidth: 5.0,
                ),
              )
            );
          }
        }
      ),
    );
  }
}

class InListTitle extends StatelessWidget {
  const InListTitle({
    Key key, this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.all(8.0),
      child: Text(
        title,
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
      ),
    );
  }
}