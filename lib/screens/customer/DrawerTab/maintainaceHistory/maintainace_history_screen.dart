import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ice_cream/consts.dart';
import 'package:ice_cream/data/models/loginModel.dart';
import 'package:ice_cream/data/models/request.dart';
import 'package:ice_cream/data/repositories/maintainaceRepository.dart';
import 'package:ice_cream/screens/cold_storage/assigned_order_screen.dart';
import 'package:ice_cream/screens/customer/DrawerTab/maintainaceHistory/maintainace_item.dart';
import 'package:ice_cream/screens/customer/DrawerTab/maintainaceHistory/single_maintainace_screen.dart';
import 'package:ice_cream/widgets/customer_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MaintainanceHistoryScreen extends StatefulWidget {
  
  MaintainanceHistoryScreen({Key key}) : super(key: key);

  @override
  _MaintainanceHistoryScreenState createState() => _MaintainanceHistoryScreenState();
}

class _MaintainanceHistoryScreenState extends State<MaintainanceHistoryScreen> {
  
  final MaintainaceRepository repository = MaintainaceRepository();

  Future<List<RequestModel>> getMaintainaces() async {

    SharedPreferences userData = await SharedPreferences.getInstance();
    Map userMap = json.decode(userData.getString(userKey));
    LoginModel loginData = LoginModel.fromJson(userMap);


    Future<List<RequestModel>> requestList = repository.getRequests(loginData.token);

    requestList.catchError((error){
      print(error);
    });

    return requestList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomerDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Your Maintainace Requests"),
      ),

      body: FutureBuilder<List<RequestModel>>(
        future: getMaintainaces(),
        builder: (context, snapshot) {

          if (snapshot.hasData){
            return RefreshIndicator(
              onRefresh: () async{
                setState(() {
                });
              },
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[

                    InListTitle(title: "Open Requests"),

                    if (snapshot.data.length == 0)
                      Center(child: Padding(
                        padding: const EdgeInsets.all(64.0),
                        child: Text("No Current Request"),
                      ))

                    else
                      for (RequestModel request in snapshot.data)

                        if (request.requestStatus != "delivered")                          
                        InkWell(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SingleMaintainaceScreen(request: request,))
                            );
                          },  

                          child: MaintanaceItem(
                            maintainanceNo: request.requestId,
                            date: request.requestDate,
                            time: request.requestTime,
                            type: request.requestType,
                            status: request.requestStatus,
                          ),
                        ),

                    InListTitle(title: "Repaired"),

                    if (snapshot.data.length == 0)
                      Center(child: Padding(
                        padding: const EdgeInsets.all(64.0),
                        child: Text("No Repaired"),
                      ))

                    else
                      for (RequestModel request in snapshot.data)

                        if (request.requestStatus == "delivered")                          
                        InkWell(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SingleMaintainaceScreen(request: request,))
                            );
                          },  

                          child: MaintanaceItem(
                            maintainanceNo: request.requestId,
                            date: request.requestDate,
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
      )

    );
  }
}