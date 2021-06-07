import 'package:flutter/material.dart';

class DeliveryItem extends StatefulWidget {
  DeliveryItem({Key key}) : super(key: key);

  @override
  _DeliveryItemState createState() => _DeliveryItemState();
}

class _DeliveryItemState extends State<DeliveryItem> {

  final _quantityController = TextEditingController();
  var quantity = 0;
  bool isSelected = false;
  bool isAddedToCart = false;

  @override
  void initState() {
    super.initState();

    _quantityController.text = "$quantity";

  }

  @override
  void dispose() {
    super.dispose();

    _quantityController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0x00F9F8F4),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 96.0,
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black26),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0,3),
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: EdgeInsets.only(top: 8.0, right: 8.0, bottom: 8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Rasberry & Strawberry Sorbet",
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          
                          Expanded(
                            flex: 5,
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.bottomCenter,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 4,
                                        child: Container(
                                          height: 25.0,
                                          color: Colors.yellow,
                                          child: Center(
                                            child: Text(
                                              "5 ltr tub",
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      
                                      SizedBox(width: 2.0,),

                                      Expanded(
                                        flex: 1,
                                        child: InkWell(
                                          onTap: (){
                                            setState(() {
                                              if (quantity > 0){
                                                quantity--;
                                                _quantityController.text = "$quantity";
                                              }
                                            });
                                          },
                                          child: Container(
                                            height: 25.0,
                                            color: Colors.black,
                                            child: Center(
                                              child: Text(
                                                "-",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          height: 25.0,
                                          child: TextField(
                                            maxLength: 4,
                                            keyboardType: TextInputType.numberWithOptions(),
                                            onTap: (){
                                              setState(() {
                                                isSelected = true;
                                                quantity = int.parse(_quantityController.text);
                                                _quantityController.text = "$quantity";
                                              });
                                            },
                                            onSubmitted: (value){
                                              
                                              setState(() {
                                                isSelected = false;
                                                print("$isSelected");
                                                if (value != ""){
                                                  quantity = int.parse(value);
                                                  _quantityController.text = value;
                                                }
                                                print("$quantity");
                                              });
                                            },
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            controller: _quantityController,
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(top: 4.0),
                                              counterText: "",
                                              border: InputBorder.none,
                                              hintText: isSelected? "" : "$quantity",
                                              hintStyle: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),

                                      Expanded(
                                        flex: 1,
                                        child: InkWell(
                                          onTap: (){
                                            setState(() {
                                              quantity++;
                                              _quantityController.text = "$quantity";
                                            });
                                          },
                                          child: Container(
                                            height: 25.0,
                                            color: Colors.black,
                                            child: Center(
                                              child: Text(
                                                "+",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                GestureDetector(

                                  onTap: (){
                                    setState(() {
                                      isAddedToCart = true;
                                    });
                                  },

                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 500),
                                    height: isAddedToCart? 100.0 : 25.0,
                                    color: isAddedToCart? Colors.yellow : Colors.black,
                                    margin: EdgeInsets.only(top: 2.0),
                                    child: Container(
                                      child: Center(
                                        child: Text(
                                          isAddedToCart? "Item Added" : "Add Cart",
                                          style: TextStyle(
                                            color: isAddedToCart? Colors.black : Colors.yellow,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )

                        ],
                      ),
                    ),
                  ),

                  // Image on the right of list item
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(left: BorderSide(color: Colors.black26)),
                      ),
                      child: Image.asset("assets/images/flavour_pic.png")
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}