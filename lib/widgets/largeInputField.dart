import 'package:flutter/material.dart';
import 'package:ice_cream/consts.dart';

class LargeInputField extends StatelessWidget {
  const LargeInputField({
    Key key,
    @required this.controller, this.label, this.hintText, this.padding,
  }) : super(key: key);

  final TextEditingController controller;
  final String label, hintText;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          if (label != null)
            Text(
              label,
              style: Theme.of(context).textTheme.headline,
            ),
          
          SizedBox(height: 8.0),

          Flexible(
            child: Container(
              padding: EdgeInsets.all(8.0),
              decoration: cardDecoration,
              child: TextField(
                maxLines: 100,
                controller: controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hintText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}