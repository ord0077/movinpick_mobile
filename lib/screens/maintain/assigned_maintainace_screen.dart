import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ice_cream/consts.dart';
import 'package:ice_cream/data/models/loginModel.dart';
import 'package:ice_cream/data/models/request.dart';
import 'package:ice_cream/data/repositories/maintainaceRepository.dart';
import 'package:ice_cream/screens/customer/DrawerTab/maintainaceHistory/maintainace_item.dart';
import 'package:ice_cream/screens/customer/DrawerTab/maintainaceHistory/single_maintainace_screen.dart';
import 'package:ice_cream/screens/customer/customerMenu.dart';
import 'package:ice_cream/widgets/future_list_screen.dart';
import 'package:ice_cream/widgets/tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MaintainaceScreen extends StatelessWidget {
  const MaintainaceScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabView(
      userType: "maintenance",
      tabs: <Tab>[
        Tab(
          child: CustomTab(
            icon: Icons.assignment,
            label: "Current Requests",
          ),
        ),
        Tab(
          child: CustomTab(
            icon: Icons.event,
            label: "Future Requests",
          ),
        ),
      ],

      tabChildren: <Widget>[
        TodayAssignedRequests(),
        FurtureListScreen(
          userType: "maintenance",
        ),
      ],
    );
  }
}

class TodayAssignedRequests extends StatefulWidget {

  const TodayAssignedRequests({Key key}) : super(key: key);

  @override
  _TodayAssignedRequestsState createState() => _TodayAssignedRequestsState();
}

class _TodayAssignedRequestsState extends State<TodayAssignedRequests> with AutomaticKeepAliveClientMixin{

  final MaintainaceRepository repository = MaintainaceRepository();
  DateTime now = DateTime.now();

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

      // drawer: CustomerDrawer(userType: "maintenance",),


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
                      
                      if (request.requestStatus != "delivered" && !DateTime.parse(request.requestScheduleDate).isAfter(now))
                        InkWell(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SingleMaintainaceScreen(request: request, userType: "maintenance",))
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