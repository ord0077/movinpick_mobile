import 'dart:ui';

import 'package:flutter/material.dart';

double _sigmaX = 10.0; // from 0-10
double _sigmaY = 10.0; // from 0-1.0

class CustomDialog extends StatefulWidget {
  final String title, description, buttonText;
  final Image image;
  final Function onTap;
  final bool loading;

  CustomDialog({
    this.title,
    loading,
    this.description,
    this.buttonText,
    this.image, this.onTap,
  }) : loading = loading?? false;

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: _sigmaX, sigmaY: _sigmaY),
        child: Dialog(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: widget.loading? Center(
            child: SizedBox(
              width: 50.0,
              height: 50.0,
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
                strokeWidth: 5.0,
              ),
            )
          ):dialogContent(context),
        ),
      ),
    );
  }

  dialogContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        
        InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          
          child: Container(
            color: Theme.of(context).buttonColor,
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
        ),

        SizedBox(height: 32.0),

        Container(
          padding: EdgeInsets.all(16.0),
          color: Colors.black,
          width: MediaQuery.of(context).size.width,
          child: Text(
            widget.description?? "",
            style: TextStyle(
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        
        InkWell(
          onTap: widget.onTap == null? (){
            Navigator.pop(context);
          }: (){
            setState(() {
              widget.onTap();
            });
          },

          child: Container(
            height: 56.0,
            color: Colors.white,
            child: Center(
              child: Text(
                widget.buttonText??"",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}