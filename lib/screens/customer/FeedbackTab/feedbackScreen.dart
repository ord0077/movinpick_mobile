import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ice_cream/consts.dart';
import 'package:ice_cream/data/models/loginModel.dart';
import 'package:ice_cream/data/repositories/feedbackRepository.dart';
import 'package:ice_cream/widgets/dialogBox.dart';
import 'package:ice_cream/widgets/largeButton.dart';
import 'package:ice_cream/widgets/largeInputField.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackScreen extends StatefulWidget {
  FeedbackScreen({Key key}) : super(key: key);

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {

  TextEditingController _feedbackController = TextEditingController();
  FeedbackRepository feedback = FeedbackRepository();

  @override
  void dispose() {
    super.dispose();
    _feedbackController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        
        Expanded(
          flex: 4,
          child: LargeInputField(
            controller: _feedbackController,
            label: "Feedback / Queries",
            hintText: "Enter text here",
            padding: EdgeInsets.all(8.0),
          ),
        ),

        VeryLargeButton(
          buttonText: "Send",
          buttonColor: Theme.of(context).buttonColor,
          textColor: Colors.black,
          onTap: (){

            showDialog(
              context: context,
              builder: (BuildContext context) {
                bool showLoading = false;
                String message = "Are you sure you want to submit this feedback to the administration?";

                if (_feedbackController.text == "") {
                  message = "Kindly fill out the feedback feild before sending feedback";
                }

                return StatefulBuilder(
                  builder: (context, refresh) => CustomDialog(
                    title: "chay",
                    description: message,
                    buttonText: (_feedbackController.text == "")? "OK" : "SEND FEEDBACK",
                    loading: showLoading,
                    onTap: (_feedbackController.text == "")? (){
                      Navigator.pop(context);
                    }:() async {

                      refresh(() {
                        showLoading = true;
                      });

                      SharedPreferences userData = await SharedPreferences.getInstance();
                      Map userMap = json.decode(userData.getString(userKey));
                      LoginModel loginData = LoginModel.fromJson(userMap);


                      Future<String> giveFeedback = feedback.giveFeedback(_feedbackController.text, loginData.user.id);

                      giveFeedback.then((value){
                        
                        print(value);
                        Navigator.pushReplacementNamed(context, '/customer');
                      
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
        ),
      ],
    );
  }
}