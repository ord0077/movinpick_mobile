import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ice_cream/consts.dart';
import 'package:ice_cream/data/models/loginModel.dart';
import 'package:ice_cream/data/models/productModel.dart';
import 'package:ice_cream/data/repositories/productRepository.dart';
import 'package:ice_cream/screens/customer/OrderTab/CartScreen.dart';
import 'package:ice_cream/screens/customer/OrderTab/OrderListItem.dart';
import 'package:ice_cream/screens/customer/customerMenu.dart';
import 'package:ice_cream/widgets/dialogBox.dart';
import 'package:ice_cream/widgets/largeButton.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key key}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> with AutomaticKeepAliveClientMixin{

  ProductRepository repository = ProductRepository();
  TextEditingController _searchController = TextEditingController();
  Future<List<Product>> productList;
  List<Product> cartList;
  String searchText = "";
  bool isPressed;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState(); 
    cartList = [];
    productList = getProductList();  
  }

  Future<List<Product>> getProductList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map userMap = jsonDecode(prefs.getString(userKey));
    LoginModel userData = LoginModel.fromJson(userMap);
    return repository.getProducts(userData.token);
  }


  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

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

  bool itemIsInCart(Product product){
    if (cartList.length != 0){                                
      for (Product cartItem in cartList){
        if (cartItem.productId == product.productId){
          return true;
        }
      }
    }
    return false;
  }

  refresh(List<Product> updatedList){
    cartList = updatedList;
  }

  @mustCallSuper
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      bottomNavigationBar: cartList.length == 0? null : VeryLargeButton(
        buttonColor: Theme.of(context).accentColor,
        buttonText: "VIEW CART",
        textColor: Theme.of(context).primaryColorLight,
        onTap: (){
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) => CartScreen(
                cartProduct: cartList, 
                updateList: (List<Product> product) {
                  refresh(product);
                },
              )
            )
          );
        },
      ),

      body: Column(
          children: <Widget>[
            Container(
              color: Colors.black,
              padding: const EdgeInsets.all(8.0),
              height: 65.0,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  
                  Expanded(
                    flex: 7,
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        autofocus: false,
                        controller: _searchController,
                        onChanged: (value){
                          setState(() {
                            searchText = _searchController.text;
                            print(searchText);
                          });
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search"
                        ),
                      ),
                    ),
                  ),
                  
                  Expanded(
                    flex: 2,
                    child: InkWell(
                      onTap: (){
                        searchText = _searchController.text;
                      },
                      child: Container(
                        color: Theme.of(context).accentColor,
                        child: Icon(
                          Icons.search,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 2.0,),
                  
                  Expanded(
                    flex: 2,
                    child: InkWell(
                      onTap: (){
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context) => CartScreen(
                              cartProduct: cartList, 
                              updateList: (List<Product> product) {
                                refresh(product);
                              },
                            )
                          )
                        );
                      },
                      child: Container(
                        color: Theme.of(context).accentColor,
                        padding: EdgeInsets.only(right: 4.0, left: 4.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[

                                cartList.length != 0?
                                Text(
                                  "${cartList.length}",
                                  style: TextStyle(
                                    fontSize: 12.0,
                                  ),
                                ) : Container(),

                                Icon(
                                  Icons.shopping_cart,
                                ),
                              ],
                            ),
                            
                            cartList.length != 0?
                            Text(
                              "${cartTotal(cartList).toStringAsFixed(2).replaceAllMapped(reg, mathFunc)} AED",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: (cartTotal(cartList) < 99999.99)? 8.0 : 6.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ) : Container(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            FutureBuilder<List<Product>>(
              future: productList,
              builder: (_, AsyncSnapshot<List<Product>> snapshot){
                if (snapshot.hasData){

                  return Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          
                          for (var product in snapshot.data)

                            if(product.productTitle.toLowerCase().contains(searchText.toLowerCase()))
                              OrderListItem(
                                inCart: false,
                                buttonPressed: itemIsInCart(product),
                                onAddToCart: (){

                                  if (product.productQuantity == 0 || product.productQuantity == null) {
                                    _showToast(context, "Invalid Item Quantity");
                                  } else {
                                    
                                    bool itemAdded = false;
                                    int itemIndex = 0;

                                    if (cartList.length != 0){
                                      
                                      int i = 0;
                                      for (Product cartItem in cartList){
                                        if (cartItem.productId == product.productId){
                                          itemAdded = true;
                                          itemIndex = i;
                                        }
                                        i++;
                                      }
                                    } 

                                    if (itemAdded){                            
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) => CustomDialog(
                                          loading: false,
                                          title: "Success",
                                          description:
                                              "This item is already placed in cart. Are you sure you want to update it?",
                                          buttonText: "Update",
                                          onTap: (){
                                            setState(() {
                                              cartList[itemIndex].productQuantity = product.productQuantity;
                                              
                                              Navigator.pop(context);

                                              _showToast(_scaffoldKey.currentContext, "Item Updated");
                                              
                                            });
                                          },
                                        ),
                                      );
                                    } else {
                                      Product newProduct = Product(
                                        productId: product.productId,
                                        productTitle: product.productTitle,
                                        productQuantity: product.productQuantity,
                                        productPrice: product.productPrice,
                                        productExpiry: product.productExpiry,
                                        productDescription: product.productDescription,
                                        productImage: product.productImage,
                                        productDiscount: product.productDiscount,
                                      );

                                      setState(() {
                                        cartList.add(newProduct);  
                                      });
                                      
                                      _showToast(context, "Item Added To Cart");
                                    }
                                  }     
                                },
                                product: product,
                              ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 50.0,
                          height: 50.0,
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                            valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
                            strokeWidth: 5.0,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
              },
            ),
          ],
        ),
    );
  }

  void _showToast(BuildContext context, String message) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(milliseconds: 300),
        backgroundColor: Theme.of(context).primaryColorLight,
      ),
    );
  }
}


class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final Widget _tabBar;

  @override
  double get minExtent => 60.0;
  @override
  double get maxExtent => 60.0;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return true;
  }
}