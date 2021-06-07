import 'package:flutter/material.dart';
import 'package:ice_cream/widgets/customer_drawer.dart';



class TabView extends StatefulWidget {

  final List<Tab> tabs;
  final List<Widget> tabChildren;
  final String userType;

  TabView({Key key, this.tabs, this.tabChildren, this.userType}) : super(key: key);

  @override
  _TabViewState createState() => _TabViewState();
}

class _TabViewState extends State<TabView> with SingleTickerProviderStateMixin{
  
  TabController _tabController;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: widget.tabs.length);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }
  
  
  @override
  Widget build(BuildContext context) {

    final tab = new TabBar(
      tabs: widget.tabs,
      controller: _tabController,
      indicatorColor: Theme.of(context).accentColor,
      labelColor: Theme.of(context).accentColor,
      labelPadding: EdgeInsets.only(top: 32.0),
      unselectedLabelColor: Colors.white54,
    );
    
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(48.0),
        child: Container(
          color: Theme.of(context).primaryColorLight,
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
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              
              Flexible(child: tab),
            ],
          ),
        ),
      ),
      
      drawer: CustomerDrawer(userType: widget.userType),

      body: TabBarView(
        controller: _tabController,
        children: widget.tabChildren,
      ),
    );
  }
}