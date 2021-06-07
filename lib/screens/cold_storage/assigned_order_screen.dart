import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ice_cream/consts.dart';
import 'package:ice_cream/data/models/loginModel.dart';
import 'package:ice_cream/data/models/orderModel.dart';
import 'package:ice_cream/data/repositories/orderRepository.dart';
import 'package:ice_cream/screens/customer/DrawerTab/orderhistory/ordereditem.dart';
import 'package:ice_cream/screens/customer/DrawerTab/orderhistory/singleOrderScreen.dart';
import 'package:ice_cream/screens/customer/customerMenu.dart';
import 'package:ice_cream/widgets/future_list_screen.dart';
import 'package:ice_cream/widgets/tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AssignedOrderScreen extends StatelessWidget {
  const AssignedOrderScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabView(
      userType: "coldstorage",
      tabs: <Tab>[
        Tab(
          child: CustomTab(
            icon: Icons.assignment,
            label: "Current Orders",
          ),
        ),
        Tab(
          child: CustomTab(
            icon: Icons.event,
            label: "Future Orders",
          ),
        ),
      ],

      tabChildren: <Widget>[
        ColdStorageOrders(),
        FurtureListScreen(
          userType: "coldstorage",
        ),
      ],
    );
  }
}

class ColdStorageOrders extends StatefulWidget {

  const ColdStorageOrders({Key key}) : super(key: key);

  @override
  _ColdStorageOrdersState createState() => _ColdStorageOrdersState();
}

class _ColdStorageOrdersState extends State<ColdStorageOrders> with AutomaticKeepAliveClientMixin {

  final OrderRepository repository = OrderRepository();
  String userType = "cold storage";
  DateTime now = DateTime.now();
  
  Future<List<Order>> getOrders() async {

    SharedPreferences userData = await SharedPreferences.getInstance();
    Map userMap = json.decode(userData.getString(userKey));
    LoginModel loginData = LoginModel.fromJson(userMap);

    Future<List<Order>> orderList = repository.getOrdersForColdStorage(loginData.token, false);

    orderList.catchError((error){
      print(error);
    });

    return orderList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

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
                        child: Text("No Assigned Orders"),
                      ))

                    else
                      for (Order order in snapshot.data)
                        if (order.orderStatus == "processing" && !DateTime.parse(order.deliveryDate).isAfter(now))
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

  @override
  bool get wantKeepAlive => true;
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