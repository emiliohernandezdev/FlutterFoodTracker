import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Glovo extends StatefulWidget {
  @override
  _GlovoState createState() => _GlovoState();
}

class _GlovoState extends State<Glovo> {
  static final CameraPosition _cameraPosition = CameraPosition(
    target: LatLng(14.6030545, -90.5097146),
    zoom: 14.4746
  );

        Completer<GoogleMapController> _completer = Completer();



  void makeOrder() async{
    var url = 'https://api.glovoapp.com/b2b/orders?limit=1&offset=0';
    var response = await http.get(url, 
    headers: {'Authorization': 'Basic xxxxxxxxxxxxxxxxxxx'});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Image.network('https://cdn.shortpixel.ai/spai/w_979+q_lossless+ret_img+to_webp/https://gabrielapatron.com/wp-content/uploads/2019/01/Glovo.jpg'),
          RaisedButton(
            child: Text('Pedir'),
            onPressed: makeOrder,
          ),
          SizedBox(
            height: 450.0,
            width: 450.0,
            child:           GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _cameraPosition,
        onMapCreated: (GoogleMapController controller){
          _completer.complete(controller);
        },
      ),
          ),
        ],
      ),
    );
  }
  
}
