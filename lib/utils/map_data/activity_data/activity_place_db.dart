import 'dart:convert';

import 'package:hike_uw/utils/map_data/activity_data/activity_place.dart';
import 'package:hike_uw/utils/map_data/place_db.dart';

class ActivityPlaceDB extends PlaceDB {
  ActivityPlaceDB.initializeFromJson(String jsonString)
      : super.intitalizeSuper(_decodePlaceListJson(jsonString));

  static List<ActivityPlace> _decodePlaceListJson(String jsonString) {
    final listMap = jsonDecode(jsonString);
    final theList = (listMap as List).map((element) {
      return ActivityPlace.fromJson(element);
    }).toList();
    return theList;
  }
}
