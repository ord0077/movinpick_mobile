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

class DriverHistoryScreen extends StatefulWidget {

  const DriverHistoryScreen({Key key}) : super(key: key);

  @override
  _DriverHistoryScreenState createState() => _DriverHistoryScreenState();
}

class _DriverHistoryScreenState extends State<DriverHistoryScreen> {

  final OrderRepository repository = OrderRepository();
  String userType = "driver";
  
  Future<List<Order>> getOrders() async {

    SharedPreferences userData = await SharedPreferences.getInstance();
    Map userMap = json.decode(userData.getString(userKey));
    LoginModel loginData = LoginModel.fromJson(userMap);


    print(userType);

    Future<List<Order>> orderList = repository.getOrdersForDriver(loginData.token, true);

    orderList.catchError((error){
      print(error);
    });

    return orderList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      drawer: CustomerDrawer(userType: userType,),

      appBar: AppBar(
        title: Text("Delivered Orders"),
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

                    if (snapshot.data.length == 0)
                      Center(child: Padding(
                        padding: const EdgeInsets.all(64.0),
                        child: Text("No Orders Delivered"),
                      ))

                    else
                      for (Order order in snapshot.data)
                        InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SingleOrderScreen(order: order, userType: userType)));
                          },

                          child: Hero(
                            tag: order.orderId,
                            child: Material(
                              child: PlacedOrderItem(
                                order: order,
                                userType: userType,
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