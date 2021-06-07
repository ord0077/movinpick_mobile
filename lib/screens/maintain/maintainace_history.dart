import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ice_cream/consts.dart';
import 'package:ice_cream/data/models/loginModel.dart';
import 'package:ice_cream/data/models/request.dart';
import 'package:ice_cream/data/repositories/maintainaceRepository.dart';
import 'package:ice_cream/screens/customer/DrawerTab/maintainaceHistory/maintainace_item.dart';
import 'package:ice_cream/screens/customer/DrawerTab/maintainaceHistory/single_maintainace_screen.dart';
import 'package:ice_cream/widgets/customer_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MaintenanceManHistory extends StatefulWidget {

  const MaintenanceManHistory({Key key}) : super(key: key);

  @override
  _MaintenanceManHistoryState createState() => _MaintenanceManHistoryState();
}

class _MaintenanceManHistoryState extends State<MaintenanceManHistory> {

  final MaintainaceRepository repository = MaintainaceRepository();
  String userType = "cold storage";
  

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

      drawer: CustomerDrawer(userType: "maintenance",),

      appBar: AppBar(
        title: Text("Maintainenance Requests"),
        backgroundColor: Colors.black,
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

                    if (snapshot.data.length == 0)
                      Center(child: Padding(
                        padding: const EdgeInsets.all(64.0),
                        child: Text("No Current Requests"),
                      ))

                    else
                      for (RequestModel request in snapshot.data)
                      
                      if (request.requestStatus == "delivered")
                        InkWell(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SingleMaintainaceScreen(request: request, userType: "maintenance",))
                            );
                          },  

                          child: MaintanaceItem(
                            maintainanceNo: request.requestId,
                            date: request.requestScheduleDate,
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