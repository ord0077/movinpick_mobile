import 'package:flutter/material.dart';
import 'package:ice_cream/screens/customer/MaintainanceTab/repairForm.dart';
import 'package:ice_cream/widgets/largeButton.dart';

class MaintainanceMenuScreen extends StatelessWidget {
  const MaintainanceMenuScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Freezer",
            style: Theme.of(context).textTheme.headline,
          ),
        ),

        SizedBox(height: 8.0,),

        // VeryLargeButton(
        //   buttonColor: Theme.of(context).accentColor,
        //   buttonText: "MAINTENANCE",
        //   textColor: Colors.black,
        //   onTap: (){
        //     print("You tapped me");
        //   },
        // ),

        // SizedBox(height: 8.0,),

        VeryLargeButton(
          buttonColor: Theme.of(context).primaryColorLight,
          buttonText: "Repair",
          textColor: Colors.white,
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RepairForm()),
            );
          },
        ),

      ],
    );
  }
}