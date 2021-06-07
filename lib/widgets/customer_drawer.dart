import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ice_cream/about_us.dart';
import 'package:ice_cream/consts.dart';
import 'package:ice_cream/data/models/loginModel.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerDrawer extends StatelessWidget {
  const CustomerDrawer({
    Key key,
    this.userType
  }) : super(key: key);

  final String userType;
  Future<SharedPreferences> sharedPreferences() async => await SharedPreferences.getInstance(); 

  @override
  Widget build(BuildContext context) {

    bool isCustomer = userType == null? true : (userType == "customer");
    print(isCustomer);
    print(userType);


    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[

          FutureBuilder<SharedPreferences>(
            future: sharedPreferences(),
            builder: (context, snapshot) {

              if (snapshot.hasData){
                Map userMap = jsonDecode(snapshot.data.getString(userKey));
                LoginModel userData = LoginModel.fromJson(userMap);
                
                return DrawerHeader(
                  padding: EdgeInsets.fromLTRB(16.0, 16.0, 24.0, 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 48.0,
                      ),

                      SizedBox(width: 8.0),
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[

                            Text(
                              userData.user.name?? "Name is null",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                            SizedBox(height: 4.0),

                            Flexible(
                              child: Text(
                                userData.user.address?? "address is null",
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        )
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorLight,
                  ),
                );
              } else {
                return DrawerHeader(child: Container(color: Colors.black),);
              }
            }
          ),

          Flexible(
            child: ListView(
              padding: EdgeInsets.all(0.0),
              children: <Widget>[
                
                NavigatorListItem(
                  icon: Icons.home,
                  title: "Home",
                  onTap: (){
                    Navigator.pushReplacementNamed(context, '/${userType??"customer"}');

                  },
                ),

                
                if (userType != "maintenance")
                  NavigatorListItem(
                    icon: Icons.local_mall,
                    title: isCustomer? "Your Orders": "Order History",
                    onTap: (){
                      Navigator.pushReplacementNamed(context, '/${(userType??"customer")}/order_history');
                    },
                  ),

                if (userType == "maintenance")
                  NavigatorListItem(
                    icon: Icons.local_mall,
                    title: "Maintenance History",
                    onTap: (){
                      Navigator.pushReplacementNamed(context, '/maintenance/history');
                    },
                  ),

                if (isCustomer)
                  NavigatorListItem(
                    icon: Icons.work,
                    title: "Maintenance Requests",
                    onTap: (){
                      Navigator.pushReplacementNamed(context, '/customer/maintainance_history');
                    },
                  ),

                NavigatorListItem(
                  icon: Icons.power_settings_new,
                  title: "Log Out",
                  onTap: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.remove(userKey);
                    Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
                  },
                ),

                
              ],   
            ),
          ),

          GestureDetector(
            onTap: (){

              PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
                String version = packageInfo.version;
                
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AboutUsPage(version: version,)),
                );
              });
            },
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Text("About App"),
              ),
            ),
          ),
          
        ],
      ),
    );
  }
}

class NavigatorListItem extends StatelessWidget {
  const NavigatorListItem({
    Key key, this.title, this.icon, this.onTap,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black26),
        )
      ),
      child: ListTile(
        leading: Icon(
          this.icon,
          color: Colors.black,
        ),
        title: Text(title),
        onTap: () {

          onTap();
          //Navigator.pop(context);
        },
      ),
    );
  }
}