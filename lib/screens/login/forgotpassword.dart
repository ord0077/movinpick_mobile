import 'package:flutter/material.dart';
import 'package:ice_cream/screens/login/login.dart';

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen({Key key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  
  final emailController = TextEditingController();
  
  @override
  void dispose() {
    super.dispose();

    emailController.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "Forgot Password",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      
      body: Builder(
        builder: (context) {
          return Stack(
            children: <Widget>[
              Center(
                child: FractionallySizedBox(
                  widthFactor: 0.6,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[

                        Text(
                          "Instructions on how to reset your password will be sent onto the entered email address",
                          textAlign: TextAlign.center,
                        ),
                        
                        SizedBox(height: 16.0,),

                        // Input textfields for email
                        InputBox(
                          hint: "Email",
                          icon: Icons.mail_outline,
                          isPassword: false,
                          textController: emailController,
                        ),
                        
                        SizedBox(height: 16.0,),

                        // Button
                        InkWell(
                          child: Container(
                            padding: EdgeInsets.all(12.0),
                            color: Colors.black,
                            child: Center(
                              child: Text(
                                "Send",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          onTap: (){
                            
                            if (emailController.text == "")
                              _showToast(context);
                            else
                              print("Email: ${emailController.text}");
                          },

                        ),

                      ],

                    ),
                  ),
                ),
              ),
            ],
          );
        }
      ),
    );
  }

  void _showToast(BuildContext context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('No email address entered'),
        duration: Duration(seconds: 1),
      ),
    );
  }
}