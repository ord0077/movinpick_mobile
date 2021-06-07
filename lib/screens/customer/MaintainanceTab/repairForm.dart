import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ice_cream/consts.dart';
import 'package:ice_cream/data/models/loginModel.dart';
import 'package:ice_cream/data/repositories/maintainaceRepository.dart';
import 'package:ice_cream/widgets/dialogBox.dart';
import 'package:ice_cream/widgets/largeButton.dart';
import 'package:ice_cream/widgets/largeInputField.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class RepairForm extends StatefulWidget {
  const RepairForm({Key key}) : super(key: key);

  @override
  _RepairFormState createState() => _RepairFormState();
}

class _RepairFormState extends State<RepairForm> {

  TextEditingController _textController = TextEditingController();
  MaintainaceRepository request = MaintainaceRepository();
  String image;

  void _choose() async {
    //image = await ImagePicker.pickImage(source: ImageSource.gallery);
    File imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    List<int> imageBytes = imageFile.readAsBytesSync();
    image = base64.encode(imageBytes);

    setState(() {
      
    });
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Theme.of(context).primaryColorLight,
        title: Text(
          "Repair Form"
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            
            Expanded(
              flex: 4,
              child: LargeInputField(
                controller: _textController,
                hintText: "Enter text here",
                padding: EdgeInsets.all(8.0),
              ),
            ),



            VeryLargeButton(
              buttonText: image == null? "Add Image": "Uploaded",
              buttonColor: Theme.of(context).primaryColorLight,
              textColor: Colors.white,
              onTap: _choose,
            ),

            SizedBox(height: 8.0),

            VeryLargeButton(
              buttonText: "Send",
              buttonColor: Theme.of(context).accentColor,
              textColor: Colors.black,
              splashColor: Colors.orangeAccent,
              onTap: (){

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    bool showLoading = false;
                    String message = "Are you sure you want to submit this maintenance request to the administration?";

                    if (_textController.text == "") {
                      message = "Kindly fill out the feedback feild before sending feedback";
                    }

                    return StatefulBuilder(
                      builder: (context, refresh) => CustomDialog(
                        title: "chay",
                        description: message,
                        buttonText: (_textController.text == "")? "OK" : "SEND REQUEST",
                        loading: showLoading,
                        onTap: (_textController.text == "")? (){
                          Navigator.pop(context);
                        }:() async {

                          refresh(() {
                            showLoading = true;
                          });

                          SharedPreferences userData = await SharedPreferences.getInstance();
                          Map userMap = json.decode(userData.getString(userKey));
                          LoginModel loginData = LoginModel.fromJson(userMap);


                          Future<String> giveFeedback = request.maintainaceRequest(_textController.text, loginData.token, loginData.user.id, image, "repair");

                          giveFeedback.then((value){
                            
                            print(value);
                            Navigator.pushReplacementNamed(context, '/customer');
                          
                          }).catchError((value){
                            
                            print(value);
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
        ),
      ),
    );
  }
}