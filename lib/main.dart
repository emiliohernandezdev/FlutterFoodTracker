import 'package:flutter/material.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:badges/badges.dart';
import 'package:foodtracker/views/account.dart';
import 'package:foodtracker/views/restaurants.dart';
import 'package:foodtracker/views/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodTracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.red, fontFamily: 'DM'),
      home: MyHomePage(title: 'Food Tracker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentPage = 0;
  final List<Widget> _childrens = [
    Home(),
    Restaurants(),
    Account()    
  ];

  void onTabTapped(int index){
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Badge(
              badgeContent: Text('3', style: TextStyle(color: Colors.white)),
              child: Icon(Icons.notifications),
            ),
            onPressed: () {},
            color: Colors.grey,
            tooltip: 'Notificaciones',
          )
        ],
      ),
      bottomNavigationBar: FFNavigationBar(
        theme: FFNavigationBarTheme(
            barBackgroundColor: Colors.white,
            selectedItemBackgroundColor: Colors.red,
            selectedItemIconColor: Colors.white,
            selectedItemLabelColor: Colors.black,
            showSelectedItemShadow: true),
        selectedIndex: _currentPage,
        onSelectTab: onTabTapped,
        items: [
          FFNavigationBarItem(
            iconData: Icons.home,
            label: 'Inicio',
          ),
          FFNavigationBarItem(
            iconData: Icons.restaurant,
            label: 'Restaurantes',
          ),
          FFNavigationBarItem(
            iconData: Icons.account_circle,
            label: 'Cuenta',
          ),
        ],
      ),
      body:Center(
        child: _childrens[_currentPage],
      )
    );
  }
}
