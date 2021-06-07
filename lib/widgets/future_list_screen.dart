import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ice_cream/consts.dart';
import 'package:ice_cream/data/models/loginModel.dart';
import 'package:ice_cream/data/models/orderModel.dart';
import 'package:ice_cream/data/models/request.dart';
import 'package:ice_cream/data/repositories/maintainaceRepository.dart';
import 'package:ice_cream/data/repositories/orderRepository.dart';
import 'package:ice_cream/screens/customer/DrawerTab/maintainaceHistory/maintainace_item.dart';
import 'package:ice_cream/screens/customer/DrawerTab/maintainaceHistory/single_maintainace_screen.dart';
import 'package:ice_cream/screens/customer/DrawerTab/orderhistory/ordereditem.dart';
import 'package:ice_cream/screens/customer/DrawerTab/orderhistory/singleOrderScreen.dart';
import 'package:ice_cream/screens/driver/DriverScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FurtureListScreen extends StatefulWidget {

  final String userType;
  FurtureListScreen({Key key, this.userType}) : super(key: key);

  @override
  _FurtureListScreenState createState() => _FurtureListScreenState();
}

class _FurtureListScreenState extends State<FurtureListScreen> with AutomaticKeepAliveClientMixin{
  
  final OrderRepository repository = OrderRepository();
  final MaintainaceRepository repositoryM = MaintainaceRepository();
  Future<List<Order>> orders;
  Future<List<RequestModel>> requests;
  DateTime now = DateTime.now();
  
  
  Future<List<Order>> getOrders() async {

    SharedPreferences userData = await SharedPreferences.getInstance();
    Map userMap = json.decode(userData.getString(userKey));
    LoginModel loginData = LoginModel.fromJson(userMap);
    Future<List<Order>> orderList;

    if (loginData.user.userType == "driver")
      orderList = repository.getOrdersForDriver(loginData.token, false);
    else 
      orderList = repository.getOrdersForColdStorage(loginData.token, false);
    
    orderList.catchError((error){
      print(error);
    });

    return orderList;
  }

  Future<List<RequestModel>> getrequests() async {

    SharedPreferences userData = await SharedPreferences.getInstance();
    Map userMap = json.decode(userData.getString(userKey));
    LoginModel loginData = LoginModel.fromJson(userMap);
    Future<List<RequestModel>> requestList;

    requestList = repositoryM.getRequests(loginData.token);

    return requestList;
  }

  @override
  void initState() {
    super.initState();
    if (widget.userType == "maintenance")
      requests = getrequests();
    else
      orders = getOrders();
  }

  @override
  Widget build(BuildContext context) {

    String userType = widget.userType;
    print(userType);

    return (widget.userType == "maintenance")? FutureBuilder<List<RequestModel>>(
        future: requests,
        builder: (context, snapshot) {

          if (snapshot.hasData) {

            return RefreshIndicator(
              onRefresh: () async{
                setState(() {
                  orders = getOrders();
                });
              },
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[

                    InListTitle(title: "Tomorrow's Orders",),

                    if (snapshot.data.length == 0)
                      Center(child: Padding(
                        padding: const EdgeInsets.all(64.0),
                        child: Text("No dispatched"),
                      ))

                    else
                      for (RequestModel request in snapshot.data)
                        if (request.requestStatus == "processing" && DateTime.parse(request.requestScheduleDate).isAfter(now) && DateTime.parse(request.requestScheduleDate).isBefore(now.add(Duration(days:1))) )
                        InkWell(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SingleMaintainaceScreen(request: request, userType: "maintenance", showButton: false,))
                            );
                          },  

                          child: MaintanaceItem(
                            maintainanceNo: request.requestId,
                            date: request.requestScheduleDate?? "2020-01-10",
                            time: request.requestTime,
                            type: request.requestType,
                            status: request.requestStatus,
                          ),
                        ),

                    InListTitle(title: "Future Orders",),

                    
                    if (snapshot.data.length == 0)
                      Center(child: Padding(
                        padding: const EdgeInsets.all(64.0),
                        child: Text("No orders assigned"),
                      ))

                    else
                      for (RequestModel request in snapshot.data)
                        if (request.requestStatus == "processing" && DateTime.parse(request.requestScheduleDate).isAfter(now.add(Duration(days: 1))))                        
                        InkWell(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SingleMaintainaceScreen(request: request, userType: "maintenance", showButton: false,))
                            );
                          },  

                          child: MaintanaceItem(
                            maintainanceNo: request.requestId,
                            date: request.requestScheduleDate?? "2020-01-10",
                            time: request.requestTime,
                            type: request.requestType,
                            status: request.requestStatus,
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
    ) : FutureBuilder<List<Order>>(
        future: orders,
        builder: (context, snapshot) {

          if (snapshot.hasData) {

            return RefreshIndicator(
              onRefresh: () async{
                setState(() {
                  orders = getOrders();
                });
              },
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[

                    InListTitle(title: "Tomorrow's Orders",),

                    if (snapshot.data.length == 0)
                      Center(child: Padding(
                        padding: const EdgeInsets.all(64.0),
                        child: Text("No dispathced"),
                      ))

                    else
                      for (Order order in snapshot.data)
                        if (order.orderStatus == "processing" && DateTime.parse(order.deliveryDate).isAfter(now) && DateTime.parse(order.deliveryDate).isBefore(now.add(Duration(days:1))) )
                        InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SingleOrderScreen(order: order, userType: widget.userType)));
                          },

                          child: Hero(
                            tag: order.orderId.toString() + "chay",
                            child: Material(
                              child: PlacedOrderItem(
                                order: order,
                                userType: userType,
                              ),
                            ),
                          ),
                        ),

                    InListTitle(title: "Future Orders",),

                    
                    if (snapshot.data.length == 0)
                      Center(child: Padding(
                        padding: const EdgeInsets.all(64.0),
                        child: Text("No orders assigned"),
                      ))

                    else
                      for (Order order in snapshot.data)
                        if (order.orderStatus == "processing" && DateTime.parse(order.deliveryDate).isAfter(now.add(Duration(days: 1))))                        
                        InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SingleOrderScreen(order: order, userType: userType)));
                          },

                          child: Hero(
                            tag: order.orderId.toString() + "chay",
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
    );
  }

  @override
  bool get wantKeepAlive => true;
}