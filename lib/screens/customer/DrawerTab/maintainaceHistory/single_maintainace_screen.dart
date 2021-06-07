import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ice_cream/consts.dart';
import 'package:ice_cream/data/models/loginModel.dart';
import 'package:ice_cream/data/models/request.dart';
import 'package:ice_cream/data/repositories/maintainaceRepository.dart';
import 'package:ice_cream/screens/customer/DrawerTab/maintainaceHistory/maintainace_item.dart';
import 'package:ice_cream/widgets/largeButton.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SingleMaintainaceScreen extends StatelessWidget {

  final RequestModel request;
  final String userType;
  final bool showButton;

  const SingleMaintainaceScreen({Key key, this.request, this.userType, this.showButton}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    bool isMaintainace = (userType == null)? false: true;
    bool button = showButton?? true;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Request Info"),
      ),

      bottomNavigationBar: isMaintainace && request.requestStatus == "processing" && button? 
        ActionButton(request: request)
        : null,

      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[

            MaintanaceItem(
              maintainanceNo: request.requestId,
              date: !isMaintainace? request.requestDate : request.requestScheduleDate,
              time: request.requestTime,
              type: request.requestType,
              status: request.requestStatus,
            ),

            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(8.0),
              decoration: cardDecoration,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Message",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(
                      height: 16.0,
                    ),

                    Text(
                      request.requestMessage,
                    ),
                  ],
                ),
              ),
            ),

            if (request.requestImage != null)
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.all(8.0),
                decoration: cardDecoration,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Reference Image",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(
                        height: 16.0,
                      ),

                      Stack(
                        children: <Widget>[
                          
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: SizedBox(
                                width: 50.0,
                                height: 50.0,
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                  valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
                                  strokeWidth: 5.0,
                                ),
                              )
                            ),
                          ),
                          
                          Image.network(
                            request.requestImage,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      )
      
    );
  }
}

class ActionButton extends StatelessWidget {
  final RequestModel request;
  final MaintainaceRepository repository = MaintainaceRepository();

  ActionButton({
    Key key, this.request,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            buttonText: "REQUEST FULFILLED",
            textColor: Colors.black,
            buttonColor: Theme.of(context).accentColor,
            onTap: () async {
              
              refresh((){
                isTapped = true;
              });


              SharedPreferences userData = await SharedPreferences.getInstance();
              Map userMap = json.decode(userData.getString(userKey));
              LoginModel loginData = LoginModel.fromJson(userMap);
              Future<String> requestUpdate = repository.changeOrderStatus(loginData.token, request);

              requestUpdate.then((value){
                Navigator.pushNamedAndRemoveUntil(context, '/maintenance', (Route<dynamic> route) => false);
                refresh((){
                  isTapped = false;
                });
              });
            },
          );
      },
    );
  }
}