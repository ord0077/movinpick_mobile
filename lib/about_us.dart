import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatelessWidget {


  final String version;

  const AboutUsPage({Key key, this.version}) : super(key: key);

  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Image.asset(
              'assets/images/movenpick-logo.png',
              scale: 0.25,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60.0),
            child: Image.asset(
              'assets/images/unitedcool-logo.png',
            ),
          ),

          Column(
            children: <Widget>[

              Text(
                'Version: $version',
              ),

              SizedBox(height: 4.0,),

              RichText(
                text: TextSpan(
                  text: 'Powered By: ',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Orange Room Digital', 
                      style: TextStyle(
                        fontWeight: FontWeight.bold, 
                        color: Colors.orange,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: new TapGestureRecognizer()
                        ..onTap = () { launch('https://www.orangeroomdigital.com');
                      },  
                    ),
                    TextSpan(text: ' DMCC.'),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}