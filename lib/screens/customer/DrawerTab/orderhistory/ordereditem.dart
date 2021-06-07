import 'package:flutter/material.dart';
import 'package:ice_cream/data/models/orderModel.dart';
import 'package:ice_cream/screens/customer/OrderTab/OrderListItem.dart';
import 'package:ice_cream/consts.dart';



class PlacedOrderItem extends StatelessWidget {
  const PlacedOrderItem({
    Key key, this.order, this.userType
  }) : super(key: key);


  final Order order;
  final String userType;

  @override
  Widget build(BuildContext context) {

    Color statusColor;
    String status;
    bool isCustomer = userType == null? true : userType == "customer";

    if (userType == "driver")
      switch (order.orderStatus.toLowerCase()) {
      case "pending":
        status = "recieved";
        statusColor = Colors.blue;    
        break;

      case "processing":
        status = "Assigned";
        statusColor = Colors.orange;
        break;
      
      case "cancelled":
        status = "cancelled";
        statusColor = Colors.red;
        break;
      
      case "loaded":
        status = "loaded";
        statusColor = Colors.purple;
        break;

      case "on the way":
        status = "dispatched";
        statusColor = Colors.blue;
        break;
      
      case "delivered":
        status = "delivered";
        statusColor = Colors.green;
        break;

      default:
        statusColor = Colors.white;
    }

    else
      switch (order.orderStatus.toLowerCase()) {
        case "pending":
          status = "submitted";
          statusColor = Colors.blue;    
          break;

        case "processing":
          status = isCustomer? "confirmed" : "Assigned";
          statusColor = Colors.orange;
          break;
        
        case "cancelled":
          status = "cancelled";
          statusColor = Colors.red;
          break;
        
        case "loaded":
        case "on the way":
          status = isCustomer? "dispatched" : "loaded";
          statusColor = isCustomer? Colors.purple : Colors.green;
          break;
        
        case "delivered":
          status = isCustomer? "delivered" : "loaded";
          statusColor = Colors.green;
          break;

        default:
          statusColor = Colors.white;
      }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: isCustomer? 100.0 : 180.0,
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
                  "Order# ${order.orderId}",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Center(
                  child: Text(
                    status.toUpperCase(),
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
                  
                  Expanded(
                    flex: 4,
                    child: ProductLabel(
                      icon: Icons.event,
                      labelText: "DATE:",
                      descriptionText: (userType == "customer")? order.orderDate : (order.deliveryDate?? "no date"),
                    ),
                  ),

                  Expanded(
                    flex: 3,
                    child: ProductLabel(
                      icon: Icons.timer,
                      labelText: "TIME:",
                      descriptionText: (userType == "customer")? order.orderTime : (order.deliveryFrom + "\n" + order.deliveryTo),
                    ),
                  ),

                  isCustomer?
                    Expanded(
                      flex: 5,
                      child: ProductLabel(
                        icon: Icons.label,
                        labelText: "TOTAL AMOUNT:",
                        descriptionText: "AED: ${order.orderTotal.toStringAsFixed(2).replaceAllMapped(reg, mathFunc)}",
                      ),
                    ): Expanded(
                      flex: 4,
                      child: ProductLabel(
                        icon: Icons.local_shipping,
                        labelText: "ASSIGNED DRIVER:",
                        descriptionText: (order.driver.length == 0)? " -" : order.driver[0].name,
                      ),
                    ),

                ],
              ),
            ),

            if (!isCustomer)
              Flexible(
                child: ProductLabel(
                  icon: Icons.person_pin_circle,
                  iconSize: 30.0,
                  labelText: order.customerName?? "Name is null",
                  lableStyle: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                  descriptionText: order.customerAddress,
                ),
              ),

          ],
        ),
      ),
    );
  }
}