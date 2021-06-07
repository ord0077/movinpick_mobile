import 'package:flutter/material.dart';
import 'package:ice_cream/screens/customer/FeedbackTab/feedbackScreen.dart';
import 'package:ice_cream/screens/customer/MaintainanceTab/maintainanceMenu.dart';
import 'package:ice_cream/screens/customer/OrderTab/OrderScreen.dart';
import 'package:ice_cream/widgets/customer_drawer.dart';



class CustomerMenuScreen extends StatefulWidget {

  const CustomerMenuScreen({Key key}) : super(key: key);

  @override
  _CustomerMenuScreenState createState() => _CustomerMenuScreenState();
}

class _CustomerMenuScreenState extends State<CustomerMenuScreen> with SingleTickerProviderStateMixin{
  
  TabController _tabController;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }
  
  
  @override
  Widget build(BuildContext context) {

    final tab = new TabBar(
      tabs: <Tab>[
        new Tab(
          child: CustomTab(
            icon: Icons.store,
            label: "STORE",
          ),
        ),
        new Tab(
          child: CustomTab(
            icon: Icons.build,
            label: "MAINTENANCE",
          ),
        ),
        new Tab(
          child: CustomTab(
            icon: Icons.assignment,
            label: "FEEDBACK",
          ),
        ),
      ],
      controller: _tabController,
      // labelColor: Theme.of(context).accentColor,
      // labelPadding: EdgeInsets.only(top: 32.0),
      // unselectedLabelColor: Colors.white54,
    );
    
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(48.0),
        child: Container(
          // color: Theme.of(context).primaryColorLight,
          color: Colors.white,
          child: Row(
            children: <Widget>[
              GestureDetector(

                onTap: (){
                  _scaffoldKey.currentState.openDrawer();
                },

                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 32.0, left: 16.0, right: 16.0),
                    child: Icon(
                      Icons.menu,
                    ),
                  ),
                ),
              ),
              Flexible(child: tab),
            ],
          ),
        ),
      ),
      
      drawer: CustomerDrawer(),

      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          OrderScreen(),
          MaintainanceMenuScreen(),
          FeedbackScreen(),
        ],
      ),
    );
  }
}

class CustomTab extends StatelessWidget {
  const CustomTab({
    Key key, this.label, this.icon,
  }) : super(key: key);

  final String label;
  final IconData icon;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Icon(
          icon,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 8.0,
          ),
        ),
      ],
    );
  }
}