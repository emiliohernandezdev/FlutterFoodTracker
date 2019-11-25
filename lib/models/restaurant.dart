import 'package:firebase_database/firebase_database.dart';

class Restaurant{
  String key;
  String name;
  String location;
  String image;
  int rating;

  Restaurant({this.key, this.name, this.location, this.image, this.rating});

   Restaurant.fromSnapshot(DataSnapshot snapshot) : 
    key = snapshot.key,
    name = snapshot.value['name'],
    location = snapshot.value['location'],
    image = snapshot.value['image'],
    rating = snapshot.value['rating'];

    toJson(){
      return{
        "name": name,
        "location": location,
        "image": image,
        "rating": rating,
      };
    }

}

