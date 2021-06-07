import 'package:flutter/material.dart';

class EditableCounter extends StatefulWidget {

  const EditableCounter({
    Key key,
    @required this.onValueChange, this.quantity,
  }) :  super(key: key);

  final Function(int value) onValueChange;
  final int quantity;
  
  @override
  _EditableCounterState createState() => _EditableCounterState();

}

class _EditableCounterState extends State<EditableCounter> {
  
  TextEditingController _inputTextController;
  bool counterSelected = false;
  int quantity;

  @override
  void initState() {
    super.initState();
    _inputTextController = TextEditingController();
    quantity = widget.quantity?? 0;
  }

  @override
  void dispose() {
    super.dispose();
    _inputTextController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[

        if(!counterSelected)
          Expanded(
            flex: 1,
            child: new CounterButton(
              onTap: (){
                setState(() {
                  if (quantity > 1){
                    quantity--;
                  }

                  widget.onValueChange(quantity);
                });
              },
              buttonText: "-",
            ),
          ),

        Expanded(
          flex: 2,
          child: GestureDetector(

            onTap: (){
              setState(() {
                counterSelected = true;
                _inputTextController.text = "$quantity";
              });
            },

            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: counterSelected? TextField(
                  controller: _inputTextController,
                  keyboardType: TextInputType.number,
                  autofocus: true,
                  textAlign: TextAlign.center,
                  maxLength: 4,
                  decoration: InputDecoration(
                    counterText: "",
                  ),
                  onSubmitted: (value){
                    
                    quantity = (value == "" || value[0] == "-")? 1 : int.parse(value);
                    
                    setState(() {
                      counterSelected = false;  
                    });

                    widget.onValueChange(quantity);
                    
                  },
                ) : Text(
                  "$quantity",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                ),
              )
            ),
          ),
        ),

        Expanded(
          flex: 1,
          child: (counterSelected)? CounterButton(
            onTap: (){
              FocusScope.of(context).unfocus();

              setState(() {
                counterSelected = false;
                String value = _inputTextController.text;
                quantity = (value == "" || value[0] == "-")? 1 : int.parse(value);
              });

              widget.onValueChange(quantity);
            },
            buttonText: "DONE",
            textStyle: TextStyle(
              fontSize: 6.0,
              color: Theme.of(context).accentColor,
            ),
            ) : CounterButton(
              onTap: (){
                setState(() {
                  if (quantity < 9999)
                    quantity++;
                });

                widget.onValueChange(quantity);
              },
              buttonText: "+",
            ),
        ),
      ],
    );
  }
}

class CounterButton extends StatelessWidget {
  const CounterButton({
    Key key, 
    @required this.onTap, 
    @required this.buttonText,
    this.textStyle,
  }) : super(key: key);

  final Function onTap;
  final String buttonText;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 25.0,
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: Center(
          child: Text(
            buttonText,
            style: textStyle?? TextStyle(
              color: Theme.of(context).accentColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}