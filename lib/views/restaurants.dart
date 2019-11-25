import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:foodtracker/models/restaurant.dart';

class Restaurants extends StatefulWidget {
  @override
  _RestaurantsState createState() => _RestaurantsState();
}

class _RestaurantsState extends State<Restaurants> {
  List<Restaurant> _restaurantList;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _textEditingController = TextEditingController();
  StreamSubscription<Event> _onRestaurantAdded;
  StreamSubscription<Event> _onRestaurantChanged;
  Query _restaurantQuery;

  @override
  void initState() {
    super.initState();
    _restaurantList = new List();
    _restaurantQuery = _database.reference()
    .child("restaurants").orderByChild("name");
    _onRestaurantAdded = _restaurantQuery.onChildAdded.listen(onEntryAdded);
    _onRestaurantChanged = _restaurantQuery.onChildChanged.listen(onEntryChanged);
  }


  void onEntryAdded(Event event){
    setState(() {
      _restaurantList.add(Restaurant.fromSnapshot(event.snapshot));
    });
  }

  void onEntryChanged(Event event){
    var oldEntry = _restaurantList.singleWhere((entry){
      return entry.key == event.snapshot.key;
    });

    setState(() {
      _restaurantList[_restaurantList.indexOf(oldEntry)] =
      Restaurant.fromSnapshot(event.snapshot);
    });
  }

    @override
  void dispose() {
    _onRestaurantAdded.cancel();
    _onRestaurantChanged.cancel();
    super.dispose();
  }

    showAddTodoDialog(BuildContext context) async {
    _textEditingController.clear();
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Agregar restaurante:'),
            content: new Row(
              children: <Widget>[
                new Expanded(
                    child: new TextField(
                  controller: _textEditingController,
                  autofocus: true,
                  decoration: new InputDecoration(
                    labelText: 'Nombre del restaurante',
                  ),
                ))
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                  child: const Text('Cancelar'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              new FlatButton(
                  child: const Text('Guardar'),
                  onPressed: () {
                    addNewRestaurant(_textEditingController.text.toString());
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }

  addNewRestaurant(String name){
    if(name.length > 0){
      Restaurant rest = new Restaurant(name: name.toString(), location: 'Mixco', image: 'https://gigamall.com.vn/data/2019/09/20/11491513_LOGO-McDonald_s.jpg', rating: 5);
      _database.reference().child("restaurants").push().set(rest.toJson())
      .then((_){
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Restaurante agregado con éxito.'),
        duration: Duration(seconds: 3),
      ));
      });
    }
  }

  deleteRestaurant(String restId, int index) {
    _database.reference().child("restaurants").child(restId).remove().then((_) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Restaurante eliminado con éxito.'),
        duration: Duration(seconds: 3),
      ));
      setState(() {
        _restaurantList.removeAt(index);
      });
    });
  }


  void _showModalSheet(){
    showModalBottomSheet(context: context, builder: (builder){
      return ListView(
        children: <Widget>[
          ListTile(
            leading: ClipRRect(
              child: Image.network('https://img7.apk.tools/300/a/b/7/com.contapps.android.dialer.png'),
              borderRadius: BorderRadius.circular(30),
            ),
            title: Text("Llamar al restaurante"),
            subtitle: Text("Comunícate para pedir más información."),
            onTap: (){
              print('On Glovo');
            },
          ),
          ListTile(
            leading: ClipRRect(
              child: Image.network('https://www.conector.com/wp-content/uploads/18403419-1454830741242403-2752884136058597031-n-1.png'),
              borderRadius: BorderRadius.circular(30),
            ),
            title: Text("Pedir por Glovo"),
            subtitle: Text("Enviaremos tu pedido con un Glover"),
            onTap: (){
              print('On Glovo');
            },
          ),

          ListTile(
              leading: ClipRRect(
              child: Image.network('https://logodownload.org/wp-content/uploads/2019/05/uber-eats-logo-1.png'),
              borderRadius: BorderRadius.circular(30),
            ),
            title: Text("Uber Eats"),
            subtitle: Text("Será entregado a la puerta de tu casa con Uber Eats"),
          ),
          ListTile(
              leading: ClipRRect(
              child: Image.network('https://lh3.googleusercontent.com/XblDxQ9NEOogr-8fogjTjqnSrW3ufFq926-tBZ8Q-s9VqbIAtndut-X0_XxOC9WRTOoM'),
              borderRadius: BorderRadius.circular(30),
            ),
            title: Text("Hugo"),
            subtitle: Text("Envíaremos tu pedido por Hugo"),
          ),
        ],
      );
    });
  }



  Widget showRestaurantList(){
    if(_restaurantList.length > 0){
      return ListView.builder(
        shrinkWrap: true,
        itemCount: _restaurantList.length,
        itemBuilder: (BuildContext context, int index){
          String restId = _restaurantList[index].key;
          String name = _restaurantList[index].name;
          String location = _restaurantList[index].location;
          String image = _restaurantList[index].image;
          return Dismissible(
            key: Key(restId),
            background: Container(color: Colors.red),
            onDismissed: (direction) async {
              deleteRestaurant(restId, index);
            },
            child: ListTile(
              leading: Image.network(image),
              title: Text(name, style: TextStyle(fontSize: 20.0)),
              subtitle: Text(location, style: TextStyle(fontSize: 16.0)),
              onLongPress: (){
                _showModalSheet();
              },
            ),
          );
        },
      );
    }else{
      return Center(
        child: Text("No hay restaurantes por aquí.", textAlign: TextAlign.center, style: TextStyle(fontSize: 30.0)),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          showRestaurantList()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          showAddTodoDialog(context);
        },
        tooltip: 'Añadir restaurante',
      ),
    );
  }
}