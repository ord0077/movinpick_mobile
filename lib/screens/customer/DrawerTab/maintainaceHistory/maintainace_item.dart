import 'package:flutter/material.dart';
import 'package:ice_cream/screens/customer/OrderTab/OrderListItem.dart';
import 'package:ice_cream/consts.dart';

class MaintanaceItem extends StatelessWidget {
  const MaintanaceItem({
    Key key, this.maintainanceNo, this.status, this.date, this.time, this.type,
  }) : super(key: key);

  final int maintainanceNo;
  final String status, date, time, type;

  @override
  Widget build(BuildContext context) {

    Color statusColor;
    String showStatus;

    switch (status.toLowerCase()) {
      case "pending":
        showStatus = "open";
        statusColor = Colors.blue;    
        break;

      case "processing":
        showStatus = "scheduled";
        statusColor = Colors.orange;    
        break;

      
      case "delivered":
        showStatus = "repaired";
        statusColor = Colors.green;
        break;

      default:
        showStatus = "error";
        statusColor = Colors.white;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 100.0,
        decoration: cardDecoration,
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                
                Text(
                  "Request# ${maintainanceNo.toStringAsFixed(0)}",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Center(
                  child: Text(
                    showStatus.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w900,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 8.0),

            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  
                  ProductLabel(
                    icon: Icons.event,
                    labelText: "DATE:",
                    descriptionText: date,
                  ),

                  ProductLabel(
                    icon: Icons.timer ,
                    labelText: "TIME:",
                    descriptionText: time,
                  ),

                  ProductLabel(
                    icon: Icons.build,
                    labelText: "TYPE:",
                    descriptionText: type,
                  ),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}