import 'package:flutter/material.dart';

class VeryLargeButton extends StatelessWidget {
  const VeryLargeButton({
    Key key,
    this.buttonText, 
    this.buttonColor, 
    this.splashColor,  
    this.textColor,
    this.onTap
  }) : super(key: key);

  final String buttonText;
  final Color buttonColor, splashColor, textColor;
  final Function onTap;


  @override
  Widget build(BuildContext context) {
    
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).buttonColor,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: splashColor,
          onTap: onTap,

          child: Container(
            height: 56.0,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(
                buttonText,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}