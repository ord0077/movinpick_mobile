import 'package:flutter/material.dart';
import 'package:ice_cream/consts.dart';
import 'package:ice_cream/data/models/loginModel.dart';
import 'package:ice_cream/data/repositories/loginRepository.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  
  final LoginRepository _login = LoginRepository(); 
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool loginIsTapped = false;

  @override
  void dispose() {
    super.dispose();

    emailController.dispose();
    passwordController.dispose();
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Builder(
        builder: (context) {
          return Stack(
            children: <Widget>[

              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Image.asset(
                  'assets/images/cover-image.png',
                  fit: BoxFit.cover,
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 56.0),
                child: Container(
                  child: Image.asset(
                    'assets/images/login_top.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              Center(
                child: FractionallySizedBox(
                  widthFactor: 0.6,
                  child: SingleChildScrollView(
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[

                          // Logo image of login screen
                          Image.asset(
                            "assets/images/login_logo.png"
                          ),

                          SizedBox(height: 16.0,),

                          // Input textfields for email
                          InputBox(
                            hint: "Email",
                            icon: Icons.person_outline,
                            isPassword: false,
                            textController: emailController,
                          ),
                          
                          SizedBox(height: 8.0,),

                          // Input textfields for password
                          InputBox(
                            hint: "Password",
                            icon: Icons.lock_outline,
                            isPassword: true,
                            textController: passwordController,
                          ),

                          // Forgot password

                          // SizedBox(height: 8.0,),

                          // GestureDetector(
                          //   child: Align(
                          //     alignment: Alignment.centerRight,
                          //     child: Text(
                          //       "Forgot Password?",
                          //       style: TextStyle(
                          //         color: Theme.of(context).accentColor,
                          //       ),
                          //     ),
                          //   ),
                          //   onTap: (){
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                          //     );
                          //   },
                          // ),

                          SizedBox(height: 16.0,),

                          // Button
                          InkWell(
                            child: Container(
                              padding: EdgeInsets.all(12.0),
                              color: Theme.of(context).primaryColorLight,
                              child: Center(
                                child: loginIsTapped? Center(
                                  child: SizedBox(
                                    width: 20.0,
                                    height: 20.0,
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.white,
                                      valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
                                      strokeWidth: 3.0,
                                    ),
                                  )
                                ):Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),

                            onTap: () async {

                              if (emailController.text == "" || passwordController.text == ""){
                                _showToast(context, 'One or more feild(s) are empty');
                              } else{

                                setState(() {
                                  loginIsTapped = loginIsTapped? false:true;
                                });
                                
                                // String _email = "customer2@ord.com";
                                // String _password = "secret";
                                String _email = emailController.text;
                                String _password = passwordController.text;

                                

                                Future<LoginModel> loginResponse = _login.login(_email, _password);

                                loginResponse.then((loginModel) async {

                                  SharedPreferences userData = await SharedPreferences.getInstance();
                                  String userJSON = jsonEncode(loginModel);

                                  userData.remove(userKey);
                                  userData.setString(userKey, userJSON);
                                  
                                  print(loginModel.user.userType.toLowerCase());
                                  switch (loginModel.user.userType.toLowerCase()) {
                                    case "customer":
                                      Navigator.pushReplacementNamed(
                                        context,
                                        '/customer',
                                      );
                                      break;

                                    case "driver":
                                      Navigator.pushReplacementNamed(
                                        context,
                                        '/driver',
                                      );
                                      break;
                                    
                                    case "maintenance":
                                      Navigator.pushReplacementNamed(
                                        context,
                                        '/maintenance',
                                      );
                                      break;

                                    case "cold storage":
                                      Navigator.pushReplacementNamed(
                                        context,
                                        '/coldstorage',
                                      );
                                      break;
                                    default:
                                      _showToast(context, 'Some error occurred please try again later');
                                  }
                                }).catchError((error){
                                  _showToast(context, error);

                                }).whenComplete((){
                                  setState(() {
                                    loginIsTapped = false;

                                  });
                                });
                                
                              }
                            },

                          ),

                        ],

                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      )
        
    );
  }

  void _showToast(BuildContext context, String message) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 1),
      ),
    );
  }
}

class InputBox extends StatelessWidget {
  const InputBox({
    Key key,
    @required this.textController, this.hint, this.icon, this.isPassword,
  }) : super(key: key);

  final TextEditingController textController;
  final String hint;
  final IconData icon;
  final bool isPassword;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: Row(
        children: <Widget>[

          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Icon(
              icon,
            ),
          ),

          Flexible(
            child: TextField(
              enableInteractiveSelection: false,
              autofocus: false,
              autocorrect: false,
              obscureText: isPassword,
              controller: textController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
              ),
            ),
          ),
        ],
      ),
    );
  }
}