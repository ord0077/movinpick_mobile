import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:ice_cream/consts.dart';
import 'package:ice_cream/data/models/loginModel.dart';
import 'package:ice_cream/data/models/orderModel.dart';
import 'package:ice_cream/data/models/productModel.dart';
import 'package:ice_cream/data/repositories/orderRepository.dart';
import 'package:ice_cream/screens/customer/DrawerTab/orderhistory/singleOrderScreen.dart';
import 'package:ice_cream/screens/customer/OrderTab/OrderListItem.dart';
import 'package:ice_cream/widgets/dialogBox.dart';
import 'package:ice_cream/widgets/largeButton.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {

  final List<Product> cartProduct;
  final Function updateList;

  const CartScreen({Key key, this.cartProduct, this.updateList}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  ListModel<Product> _list;
  Product _selectedItem;
  bool removeItemSelected = false;
  bool loading = false;

  OrderRepository placeOrder = OrderRepository();

  double applyDiscount (Product product) {

    double discountAmount = product.productDiscount.discountAmount;
    double productPrice = product.productPrice;

    switch (product.productDiscount.discountType) {
      case "percentage":

        double percentage = (productPrice / 100) * discountAmount;

        return (productPrice - percentage) * product.productQuantity;
        break;

      case "amount":
        
        return (productPrice - discountAmount) * product.productQuantity;

        break;

      default:
        return 0;
    }

  }

  double cartTotal(List<Product> list){
    
    double sum = 0;

    list.forEach((e){
      if (e.productDiscount == null)
        sum += (e.productPrice * e.productQuantity);
      else
        sum += applyDiscount(e);
    });

    return sum;

  }

  double cartTotalRegardlessofDiscount(List<Product> list){
    
    double sum = 0;

    list.forEach((e){
      sum += (e.productPrice * e.productQuantity);
    });

    return sum;

  }

  double calculateVAT(List<Product> list, bool vatApplied){
    
    double sum = 0;
    double vat = 0;

    if (vatApplied){
      list.forEach((e){
        if (e.productDiscount == null)
          sum += (e.productPrice * e.productQuantity);
        else
          sum += applyDiscount(e);
      });

      vat = ((sum / 100) * 5);


    }
    return vat;
  }

  void refresh(){
    setState(() {
      
    });
  }

  @override
  void initState() {
    super.initState();

    _list = ListModel<Product>(
      listKey: _listKey,
      initialItems: widget.cartProduct,
      removedItemBuilder: _buildRemovedItem,
    );
  }

  // Used to build list items that haven't been removed.
  Widget _buildItem(BuildContext context, int index, Animation<double> animation) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction){
        _selectedItem = _selectedItem == _list[index] ? null : _list[index];
        widget.cartProduct.removeAt(index);
        _swipeRemove();
      },
      child: CardItem(
        animation: animation,
        child: OrderListItem(
          inCart: true,
          refreshCart: refresh,
          removeItem: removeItemSelected,
          product: widget.cartProduct[index],
          onRemove: (){
            _selectedItem = _selectedItem == _list[index] ? null : _list[index];
            widget.cartProduct.removeAt(index);
            _remove();
          },
        ),
      ),
    );
  }

  Widget _buildRemovedItem(Product index, BuildContext context, Animation<double> animation) {
    return CardItem(
      animation: animation,
      child: OrderListItem(
        inCart: true,
        removeItem: removeItemSelected,
        product: index,
      ),
      // No gesture detector here: we don't want removed items to be interactive.
    );
  }

  void _remove() {
    if (_selectedItem != null) {
      _list.removeAt(_list.indexOf(_selectedItem));
      setState(() {
        _selectedItem = null;
      });
    }
  }

  void _swipeRemove() {
    if (_selectedItem != null) {
      _list.swipeRemove(_list.indexOf(_selectedItem));
      setState(() {
        _selectedItem = null;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColorLight,
        ),

        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            widget.updateList(widget.cartProduct);
            Navigator.pop(context);
          }
        ),

        actions: <Widget>[

          InkWell(
            onTap: (){
              setState(() {
                removeItemSelected = removeItemSelected? false:true;
              });
            },

            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Icon(Icons.delete),
              ),
            ),
          )

        ],

        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          "Cart",
          style: TextStyle(
            color: Theme.of(context).primaryColorLight,
          ),
        ),
      ),

      bottomNavigationBar: Container(
        color: Colors.white,
        height: 100.0,
        child: Column(
          children: <Widget>[

            Expanded(
              flex: 3,
              child: Container(
                color: Colors.black12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[

                    Flexible(
                      child: ProductLabel(
                        labelText: "Sub Total:",
                        descriptionText: "${cartTotalRegardlessofDiscount(widget.cartProduct).toStringAsFixed(2).replaceAllMapped(reg, mathFunc)}",
                        descriptionStyle: TextStyle(
                            fontSize: 12.0,
                        )
                      ),
                    ),

                    Text("+"),

                    Flexible(
                      child: ProductLabel(
                        labelText: "VAT (5%):",
                        descriptionText: "${calculateVAT(widget.cartProduct, true).toStringAsFixed(2).replaceAllMapped(reg, mathFunc)}",
                        descriptionStyle: TextStyle(
                            fontSize: 12.0,
                        ),
                      ),
                    ),

                    if (cartTotalRegardlessofDiscount(widget.cartProduct) - cartTotal(widget.cartProduct) != 0)
                      Text("-"),

                    if (cartTotalRegardlessofDiscount(widget.cartProduct) - cartTotal(widget.cartProduct) != 0)
                      Flexible(
                        child: ProductLabel(
                          labelText: "Discount:",
                          descriptionText: "${(cartTotalRegardlessofDiscount(widget.cartProduct) - cartTotal(widget.cartProduct)).toStringAsFixed(2).replaceAllMapped(reg, mathFunc)}",
                          descriptionStyle: TextStyle(
                            fontSize: 12.0,
                          ),
                        ),
                      ),

                    Text("="),

                    Flexible(
                      child: ProductLabel(
                        labelText: "TOTAL:",
                        descriptionText: "${(cartTotal(widget.cartProduct) + calculateVAT(widget.cartProduct, true)).toStringAsFixed(2).replaceAllMapped(reg, mathFunc)}",
                        descriptionStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            Expanded(
              flex: 3,
              child: VeryLargeButton(
                buttonColor: Theme.of(context).accentColor,
                buttonText: "SUBMIT",
                onTap: (){

                  List<Product> products = widget.cartProduct;

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      bool showLoading = false;
                      String message = "After this step your order will be placed. Are you sure you want to proceed?";

                      if (products.length == 0) {
                        message = "You cannot checkout an empty cart! Kindly revisit the store to add products";
                      }

                      return StatefulBuilder(
                        builder: (context, refresh) => CustomDialog(
                          title: "chay",
                          description: message,
                          buttonText: (products.length == 0)? "GO BACK TO STORE" : "CONFIRM",
                          loading: showLoading,
                          onTap: (products.length == 0)? (){
                              Navigator.popUntil(context, ModalRoute.withName('/customer'));
                            }: () async {

                            refresh(() {
                              showLoading = true;
                            });

                            SharedPreferences userData = await SharedPreferences.getInstance();
                            Map userMap = json.decode(userData.getString(userKey));
                            LoginModel loginData = LoginModel.fromJson(userMap);


                            Order order = Order(
                              customerId: loginData.user.id,
                              orderTotal: (cartTotal(widget.cartProduct) + calculateVAT(widget.cartProduct, true)),
                              orderGross: cartTotalRegardlessofDiscount(widget.cartProduct),
                              orderTax: calculateVAT(widget.cartProduct, true),
                              orderDate: "24-12-18",
                              orderId: 1,
                              orderDiscount: cartTotalRegardlessofDiscount(widget.cartProduct) - cartTotal(widget.cartProduct),
                              orderStatus: "recieved",
                              orderTime: "12:12",
                              orderConfirmedDate: "",
                              orderShippedDate: "",
                              orderDeliveredDate: "",
                              orderProducts: products
                            );

                            Future<Order> orderPlaced = placeOrder.placeOrder(loginData.token, order);

                            orderPlaced.then((value){
                              setState(() {
                                var length = widget.cartProduct.length;
                                for (var i = 0; i < length; i++) {
                                  _selectedItem = _selectedItem == _list[0] ? null : _list[0];
                                  _list.swipeRemove(_list.indexOf(_selectedItem));
                                  widget.cartProduct.removeAt(0);
                                  widget.updateList(widget.cartProduct);
                                }  
                              });

                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SingleOrderScreen(order: value, userType: "customer",)), ModalRoute.withName('/customer'));
                            
                            }).catchError((value){
                              
                              message = "Sorry some unexpected error occured please try again";

                            }).whenComplete((){

                              refresh((){
                                loading = false;
                              });
                              
                            });
                          },
                          
                        ),
                    );}
                  );
                  
                  

                  // print(order.toJsonforCheckout());


                  // setState(() {
                  //   var length = widget.cartProduct.length;
                  //   for (var i = 0; i < length; i++) {
                  //     _selectedItem = _selectedItem == _list[0] ? null : _list[0];
                  //     _list.swipeRemove(_list.indexOf(_selectedItem));
                  //     widget.cartProduct.removeAt(0);
                  //     widget.updateList(widget.cartProduct);
                  //   }  
                  // });
                  
                },
              ),
            ),

          ],
        ),
      ),

      body: AnimatedList(
        key: _listKey,
        initialItemCount: _list.length,
        itemBuilder: _buildItem,
      ),

      
    );
  }
}

class ListModel<E> {
  ListModel({
    @required this.listKey,
    @required this.removedItemBuilder,
    Iterable<E> initialItems,
  }) : assert(listKey != null),
      assert(removedItemBuilder != null),
      _items = List<E>.from(initialItems ?? <E>[]);

  final GlobalKey<AnimatedListState> listKey;
  final dynamic removedItemBuilder;
  final List<E> _items;

  AnimatedListState get _animatedList => listKey.currentState;

  void insert(int index, E item) {
    _items.insert(index, item);
    _animatedList.insertItem(index);
  }

  E removeAt(int index) {
    final E removedItem = _items.removeAt(index);
    if (removedItem != null) {
      _animatedList.removeItem(
        index,
          (BuildContext context, Animation<double> animation) => removedItemBuilder(removedItem, context, animation),
      );
    }
    return removedItem;
  }

  E swipeRemove(int index) {
    final E removedItem = _items.removeAt(index);
    if (removedItem != null) {
      _animatedList.removeItem(
        index,
          (BuildContext context, Animation<double> animation) => removedItemBuilder(removedItem, context, animation),
        duration: Duration(seconds: 0),
      );
    }
    return removedItem;
  }

  int get length => _items.length;

  E operator [](int index) => _items[index];

  int indexOf(E item) => _items.indexOf(item);
}

class CardItem extends StatelessWidget {
  const CardItem({
    Key key,
    @required this.animation,
    this.child,
  }) : assert(animation != null),
       super(key: key);

  final Widget child;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2.0),
      child: SizeTransition(
        axis: Axis.vertical,
        sizeFactor: animation,
        child: child,
      ),
    );
  }
}