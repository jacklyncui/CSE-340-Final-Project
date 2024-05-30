import 'dart:convert';

import 'package:hike_uw/utils/map_data/food_data/food_place.dart';
import 'package:hike_uw/utils/map_data/place.dart';
import 'package:hike_uw/utils/map_data/place_db.dart';

class FoodPlaceDB extends PlaceDB {
  FoodPlaceDB.initializeFromJson(String jsonString)
      : super.intitalizeSuper(_decodePlaceListJson(jsonString));

  static List<Place> _decodePlaceListJson(String jsonString) {
    final listMap = jsonDecode(jsonString);
    final theList = (listMap as List).map((element) {
      return FoodPlace.fromJson(element);
    }).toList();
    return theList;
  }
}
