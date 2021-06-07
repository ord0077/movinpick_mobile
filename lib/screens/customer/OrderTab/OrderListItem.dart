import 'package:flutter/material.dart';
import 'package:ice_cream/consts.dart';
import 'package:ice_cream/data/models/productModel.dart';
import 'package:ice_cream/widgets/quantityCounter.dart';


/// The following widget is used for a listitem to be shown in the order list

class OrderListItem extends StatefulWidget {

  final Function onAddToCart, onRemove, refreshCart;
  final Product product;
  final bool inCart;
  final bool removeItem;
  final bool buttonPressed;
  
  OrderListItem({Key key, this.onAddToCart, this.product, this.inCart, this.removeItem, this.onRemove, this.refreshCart, this.buttonPressed = false}) : super(key: key);

  @override
  _OrderListItemState createState() => _OrderListItemState();
}

class _OrderListItemState extends State<OrderListItem> {


  TextEditingController _quantityController;
  bool counterSelected = false;
  bool isAddedToCart = false;
  
  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _quantityController.dispose();
  }

  String applyDiscount (Product product) {

    double discountAmount = product.productDiscount.discountAmount;
    double productPrice = product.productPrice;

    switch (product.productDiscount.discountType) {
      case "percentage":

        double percentage = (productPrice / 100) * discountAmount;

        return (productPrice - percentage).toStringAsFixed(2);
        break;

      case "amount":
        
        return (productPrice - discountAmount).toStringAsFixed(2);
        break;

      default:
        return "error";
    }

  }


  @override
  Widget build(BuildContext context) {

    double itemTotalPrice = (widget.product.productDiscount == null)? widget.product.productQuantity * widget.product.productPrice : widget.product.productQuantity * double.parse(applyDiscount(widget.product));
    
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[

          widget.inCart && widget.removeItem?
          Expanded(
            flex: 1,
            child: Center(
              child: IconButton(
                icon: Icon(
                  Icons.remove_circle,
                  color: Colors.red,
                ),
                onPressed: (){
                  widget.onRemove();
                },
              ),
            ),
          ): Container(),


          Expanded(
            flex: 8,
            child: Container(
              height: widget.inCart? 132.0 : 172.0,
              width: MediaQuery.of(context).size.width,
              decoration: cardDecoration,


              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[

                  Expanded(

                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[

                        // Image on the left of list item
                        Expanded(
                          flex: 2,
                          child: Container(
                            child: Image.network(widget.product.productImage)
                          ),
                        ),

                        Expanded(
                          flex: 5,
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[

                                Expanded(
                                  flex: 2,
                                  child: ListTitle(
                                    title: widget.product.productTitle,
                                    isSmall: widget.inCart && widget.removeItem,
                                  ),
                                ),


                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[

                                      Expanded(
                                        flex: 4,
                                        child: ProductLabel(
                                          icon: Icons.event_busy,
                                          // icon: Icons.event,
                                          labelText: "Expiry Date:",
                                          descriptionText: widget.product.productExpiry,
                                        ),
                                      ),

                                      Expanded(
                                        flex: 4,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            ProductLabel(
                                              icon: Icons.label,
                                              labelText: "Unit Price:",
                                              descriptionText: (widget.product.productDiscount == null)? "AED: ${widget.product.productPrice}" : "${applyDiscount(widget.product)} AED",
                                              child: (widget.product.productDiscount == null)? null : 
                                                Text(
                                                  "${widget.product.productPrice.toStringAsFixed(2)} AED",
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                    fontSize: 8.0,
                                                    decoration: TextDecoration.lineThrough,
                                                    decorationStyle: TextDecorationStyle.solid,
                                                  ),
                                                ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      
                                    ],
                                  ),
                                ),


                                Expanded(
                                  flex: 2,
                                  child: Align(
                                    child: Container(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          
                                          Expanded(
                                            flex: 4,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[

                                                Flexible(
                                                  child: Text(
                                                    "Total Price (Excl. VAT):",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 8.0,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                ),

                                                Flexible(
                                                  child: Text(
                                                    "AED: ${itemTotalPrice.toStringAsFixed(2).replaceAllMapped(reg, mathFunc)}",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: (widget.inCart && widget.removeItem) || (itemTotalPrice > 999999.9)? 11.0 : 14.0,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          
                                          SizedBox(width: 2.0),

                                          Expanded(
                                            flex: 4,
                                            child: EditableCounter( 
                                              quantity: widget.product.productQuantity,
                                              onValueChange: (value){
                                                setState(() {
                                                  widget.product.productQuantity = value;

                                                  if (widget.refreshCart != null){
                                                    widget.refreshCart();
                                                  }
                                                });
                                              }
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )

                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  !widget.inCart?
                  GestureDetector(
                    onTap: (){
                      widget.onAddToCart();
                      setState(() {
                      });
                      // print(buttonPressed);
                    },

                    child: Container(
                      color: widget.buttonPressed? Color(0xFFEAE8E8) : Theme.of(context).primaryColorLight,
                      padding: EdgeInsets.all(12.0),
                      child: Center(
                        child: Text(
                          widget.buttonPressed? "UPDATE ITEM" : "ADD TO CART",
                          style: TextStyle(
                            color: widget.buttonPressed? Theme.of(context).primaryColorLight : Theme.of(context).accentColor,
                          ),
                        ),
                      ),
                    ),
                  ): Container (),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductLabel extends StatelessWidget {

  final String labelText, descriptionText;
  final IconData icon;
  final TextStyle lableStyle, descriptionStyle;
  final double iconSize;
  final Widget child;

  const ProductLabel({
    Key key, this.labelText, this.descriptionText, this.icon, this.lableStyle, this.descriptionStyle, this.iconSize, this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[

        Icon(
          icon,
          size: iconSize?? (icon == null? 0.0: 20.0),
        ),

        SizedBox(width: 2.0),

        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[

              Flexible(
                child: Text(
                  labelText,
                  style: lableStyle?? TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 8.0,
                    color: Colors.black54,
                  ),
                ),
              ),

              Flexible(
                child: Text(
                  descriptionText,
                  style: descriptionStyle?? TextStyle(
                    fontSize: 12.0,
                  ),
                ),
              ),

              if(child != null)
              Expanded(
                child: child,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ListTitle extends StatelessWidget {
  const ListTitle({
    Key key, 
    @required this.title, this.isSmall,
  }) : super(key: key);

  final String title;
  final bool isSmall;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: isSmall? 14.0 : 15.0,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}